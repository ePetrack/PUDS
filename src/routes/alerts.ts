import type { FastifyInstance } from 'fastify';
import { query } from '../db.js';
import { page, table, esc } from '../views/layout.js';

type AlertRow = {
  site_name: string;
  utility: string;
  month: unknown;
  max_usage: unknown;
  actual_usage: unknown;
  pct_of_budget: unknown;
};

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/alerts', async (_req, reply) => {
    const rows = await query<AlertRow>(`
      SELECT site_name, utility, month, max_usage, actual_usage, pct_of_budget
      FROM v_budget_status
      WHERE over_budget
      ORDER BY pct_of_budget DESC NULLS LAST`);
    const body =
      rows.length === 0
        ? `<p class="ok">All sites within budget.</p>`
        : table(rows, [
            { header: 'Month',     cell: (r) => esc(r.month) },
            { header: 'Site',      cell: (r) => esc(r.site_name) },
            { header: 'Utility',   cell: (r) => esc(r.utility) },
            { header: 'Max',       cell: (r) => esc(r.max_usage) },
            { header: 'Actual',    cell: (r) => esc(r.actual_usage) },
            { header: '% of max',  cell: (r) => esc(r.pct_of_budget) },
          ]);
    reply.type('text/html').send(page('Alerts', body, { active: '/alerts' }));
  });
}
