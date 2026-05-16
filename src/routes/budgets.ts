import type { FastifyInstance } from 'fastify';
import { query, exec } from '../db.js';
import { page, table, esc, options } from '../views/layout.js';
import { UTILITIES, isUtility } from '../constants.js';

type BudgetRow = {
  budget_id: number;
  site_name: string;
  utility: string;
  month: unknown;
  max_usage: unknown;
  actual_usage: unknown;
  over_budget: boolean;
  pct_of_budget: unknown;
};
type SiteOpt = { id: number; name: string };

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/budgets', async (_req, reply) => {
    const [rows, sites] = await Promise.all([
      query<BudgetRow>(`
        SELECT budget_id, site_name, utility, month, max_usage, actual_usage, over_budget, pct_of_budget
        FROM v_budget_status
        ORDER BY month DESC, site_name, utility
        LIMIT 200`),
      query<SiteOpt>(`SELECT id, name FROM site ORDER BY name`),
    ]);
    const body = `
      ${table(rows, [
        { header: 'Month',     cell: (r) => esc(r.month) },
        { header: 'Site',      cell: (r) => esc(r.site_name) },
        { header: 'Utility',   cell: (r) => esc(r.utility) },
        { header: 'Max usage', cell: (r) => esc(r.max_usage) },
        { header: 'Actual',    cell: (r) => esc(r.actual_usage) },
        { header: '% of max',  cell: (r) => esc(r.pct_of_budget) },
        { header: 'Status',    cell: (r) => (r.over_budget ? '<span class="over">OVER</span>' : 'ok') },
      ])}
      <h3>Set budget</h3>
      <form method="post" action="/budgets">
        <label>Site <select name="site_id" required>${options(sites, (s) => s.id, (s) => s.name)}</select></label>
        <label>Utility <select name="utility">${options(UTILITIES)}</select></label>
        <label>Month (1st of) <input name="month" type="date" required /></label>
        <label>Max usage <input name="max_usage" type="number" step="0.001" required /></label>
        <label>Max cost <input name="max_cost" type="number" step="0.01" /></label>
        <button>Save</button>
      </form>`;
    reply.type('text/html').send(page('Budgets', body, { active: '/budgets' }));
  });

  app.post<{
    Body: {
      site_id: string;
      utility: string;
      month: string;
      max_usage: string;
      max_cost?: string;
    };
  }>('/budgets', async (req, reply) => {
    const b = req.body;
    const site_id = Number(b.site_id);
    const max_usage = Number(b.max_usage);
    const max_cost = b.max_cost ? Number(b.max_cost) : null;
    if (!Number.isInteger(site_id) || !Number.isFinite(max_usage) || !isUtility(b.utility)) {
      return reply.code(400).send('invalid input');
    }
    await exec(
      `INSERT INTO budget (site_id, utility, month, max_usage, max_cost)
       VALUES ($1, $2::utility, CAST($3 AS DATE), $4, $5)
       ON CONFLICT (site_id, utility, month)
       DO UPDATE SET max_usage = EXCLUDED.max_usage, max_cost = EXCLUDED.max_cost`,
      [site_id, b.utility, b.month, max_usage, max_cost],
    );
    reply.redirect('/budgets', 303);
  });
}
