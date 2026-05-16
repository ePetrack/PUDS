import type { FastifyInstance } from 'fastify';
import { query, exec } from '../db.js';
import { page, table, esc, options } from '../views/layout.js';

type ReadingRow = {
  reading_id: number;
  site_name: string;
  utility: string;
  unit: string;
  period_end: unknown;
  value: unknown;
  usage: unknown;
  days: unknown;
};
type MeterOpt = { id: number; label: string };

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/readings', async (_req, reply) => {
    const [rows, meters] = await Promise.all([
      query<ReadingRow>(`
        SELECT v.reading_id, s.name AS site_name, v.utility, v.unit,
               v.period_end, v.value, v.usage, v.days
        FROM v_period_usage v
        JOIN site s ON s.id = v.site_id
        ORDER BY v.period_end DESC, v.reading_id DESC
        LIMIT 200`),
      query<MeterOpt>(`
        SELECT m.id, s.name || ' / ' || m.utility || ' (' || m.label || ')' AS label
        FROM meter m JOIN site s ON s.id = m.site_id
        ORDER BY s.name, m.utility`),
    ]);
    const body = `
      ${table(rows, [
        { header: 'When',    cell: (r) => esc(r.period_end) },
        { header: 'Site',    cell: (r) => esc(r.site_name) },
        { header: 'Utility', cell: (r) => esc(r.utility) },
        { header: 'Value',   cell: (r) => esc(r.value) },
        { header: 'Usage Δ', cell: (r) => esc(r.usage) },
        { header: 'Unit',    cell: (r) => esc(r.unit) },
        { header: 'Days',    cell: (r) => esc(r.days) },
      ])}
      <h3>Add reading</h3>
      <form method="post" action="/readings">
        <label>Meter <select name="meter_id" required>${options(meters, (m) => m.id, (m) => m.label)}</select></label>
        <label>Date/time <input name="read_at" type="datetime-local" required /></label>
        <label>Value <input name="value" type="number" step="0.001" required /></label>
        <label>Note <input name="note" /></label>
        <button>Add</button>
      </form>`;
    reply.type('text/html').send(page('Readings', body, { active: '/readings' }));
  });

  app.post<{
    Body: { meter_id: string; read_at: string; value: string; note?: string };
  }>('/readings', async (req, reply) => {
    const meter_id = Number(req.body.meter_id);
    const value = Number(req.body.value);
    const read_at = (req.body.read_at ?? '').replace('T', ' ');
    const note = (req.body.note ?? '').trim() || null;
    if (!Number.isInteger(meter_id) || !Number.isFinite(value) || !read_at) {
      return reply.code(400).send('invalid input');
    }
    await exec(
      `INSERT INTO reading (meter_id, read_at, value, note)
       VALUES ($1, CAST($2 AS TIMESTAMP), $3, $4)`,
      [meter_id, read_at, value, note],
    );
    reply.redirect('/readings', 303);
  });
}
