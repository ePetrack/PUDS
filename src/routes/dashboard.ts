import type { FastifyInstance } from 'fastify';
import { query } from '../db.js';
import { page, table, esc } from '../views/layout.js';

type Counts = { sites: number; meters: number; readings: number; bills: number };
type LatestUsage = {
  site_name: string;
  utility: string;
  month: unknown;
  usage: unknown;
};
type Overage = {
  site_name: string;
  utility: string;
  month: unknown;
  pct_of_budget: unknown;
};

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/', async (_req, reply) => {
    const [counts] = await query<Counts>(`
      SELECT
        (SELECT COUNT(*) FROM site)::INTEGER     AS sites,
        (SELECT COUNT(*) FROM meter)::INTEGER    AS meters,
        (SELECT COUNT(*) FROM reading)::INTEGER  AS readings,
        (SELECT COUNT(*) FROM bill)::INTEGER     AS bills`);
    const latest = await query<LatestUsage>(`
      SELECT s.name AS site_name, u.utility, u.month, u.usage
      FROM v_monthly_usage u JOIN site s ON s.id = u.site_id
      ORDER BY u.month DESC, s.name, u.utility
      LIMIT 12`);
    const overages = await query<Overage>(`
      SELECT site_name, utility, month, pct_of_budget
      FROM v_budget_status
      WHERE over_budget
      ORDER BY pct_of_budget DESC NULLS LAST
      LIMIT 3`);

    const c = counts ?? { sites: 0, meters: 0, readings: 0, bills: 0 };
    const summary = `
      <ul class="stats">
        <li><span>${esc(c.sites)}</span> sites</li>
        <li><span>${esc(c.meters)}</span> meters</li>
        <li><span>${esc(c.readings)}</span> readings</li>
        <li><span>${esc(c.bills)}</span> bills</li>
      </ul>`;

    const body = `
      ${summary}
      <h3>Latest monthly usage</h3>
      ${table(latest, [
        { header: 'Month',   cell: (r) => esc(r.month) },
        { header: 'Site',    cell: (r) => esc(r.site_name) },
        { header: 'Utility', cell: (r) => esc(r.utility) },
        { header: 'Usage',   cell: (r) => esc(r.usage) },
      ])}
      <h3>Top overages</h3>
      ${
        overages.length === 0
          ? '<p class="ok">No budgets exceeded.</p>'
          : table(overages, [
              { header: 'Month',    cell: (r) => esc(r.month) },
              { header: 'Site',     cell: (r) => esc(r.site_name) },
              { header: 'Utility',  cell: (r) => esc(r.utility) },
              { header: '% of max', cell: (r) => esc(r.pct_of_budget) },
            ])
      }`;
    reply.type('text/html').send(page('Dashboard', body, { active: '/' }));
  });
}
