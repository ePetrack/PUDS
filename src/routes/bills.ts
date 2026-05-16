import type { FastifyInstance } from 'fastify';
import { query, exec } from '../db.js';
import { page, table, esc } from '../views/layout.js';

type BillRow = {
  id: number;
  site_name: string;
  utility: string;
  period_start: unknown;
  period_end: unknown;
  amount: unknown;
  usage: unknown;
  due_date: unknown;
  paid: boolean;
};
type SiteOpt = { id: number; name: string };

const UTILITIES = ['electric', 'gas', 'water'] as const;

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/bills', async (_req, reply) => {
    const rows = await query<BillRow>(`
      SELECT b.id, s.name AS site_name, b.utility,
             b.period_start, b.period_end, b.amount, b.usage, b.due_date, b.paid
      FROM bill b JOIN site s ON s.id = b.site_id
      ORDER BY b.period_start DESC, b.id DESC`);
    const sites = await query<SiteOpt>(`SELECT id, name FROM site ORDER BY name`);
    const siteOptions = sites
      .map((s) => `<option value="${esc(s.id)}">${esc(s.name)}</option>`)
      .join('');
    const utilOptions = UTILITIES.map((u) => `<option>${u}</option>`).join('');
    const body = `
      ${table(rows, [
        { header: 'Site',    cell: (r) => esc(r.site_name) },
        { header: 'Utility', cell: (r) => esc(r.utility) },
        { header: 'Start',   cell: (r) => esc(r.period_start) },
        { header: 'End',     cell: (r) => esc(r.period_end) },
        { header: 'Amount',  cell: (r) => esc(r.amount) },
        { header: 'Usage',   cell: (r) => esc(r.usage) },
        { header: 'Due',     cell: (r) => esc(r.due_date) },
        { header: 'Paid',    cell: (r) => (r.paid ? 'yes' : 'no') },
      ])}
      <h3>Add bill</h3>
      <form method="post" action="/bills">
        <label>Site <select name="site_id" required>${siteOptions}</select></label>
        <label>Utility <select name="utility">${utilOptions}</select></label>
        <label>Period start <input name="period_start" type="date" required /></label>
        <label>Period end <input name="period_end" type="date" required /></label>
        <label>Amount <input name="amount" type="number" step="0.01" required /></label>
        <label>Usage <input name="usage" type="number" step="0.001" /></label>
        <label>Due <input name="due_date" type="date" /></label>
        <label>Paid <input name="paid" type="checkbox" /></label>
        <button>Add</button>
      </form>`;
    reply.type('text/html').send(page('Bills', body, { active: '/bills' }));
  });

  app.post<{
    Body: {
      site_id: string;
      utility: string;
      period_start: string;
      period_end: string;
      amount: string;
      usage?: string;
      due_date?: string;
      paid?: string;
    };
  }>('/bills', async (req, reply) => {
    const b = req.body ?? ({} as Record<string, string | undefined>);
    const site_id = Number(b.site_id);
    const amount = Number(b.amount);
    const usage = b.usage ? Number(b.usage) : null;
    const utility = String(b.utility ?? '');
    if (!Number.isInteger(site_id) || !Number.isFinite(amount) || !UTILITIES.includes(utility as never)) {
      return reply.code(400).send('invalid input');
    }
    await exec(
      `INSERT INTO bill (site_id, utility, period_start, period_end, amount, usage, due_date, paid)
       VALUES ($1, $2::utility, CAST($3 AS DATE), CAST($4 AS DATE), $5, $6, CAST($7 AS DATE), $8)`,
      [site_id, utility, b.period_start, b.period_end, amount, usage, b.due_date || null, !!b.paid],
    );
    reply.redirect('/bills', 303);
  });
}
