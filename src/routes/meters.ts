import type { FastifyInstance } from 'fastify';
import { query, exec } from '../db.js';
import { page, table, esc, options } from '../views/layout.js';
import { UTILITIES, UNITS, isUtility, isUnit } from '../constants.js';

type Meter = {
  id: number;
  site_name: string;
  utility: string;
  unit: string;
  label: string | null;
};
type SiteOpt = { id: number; name: string };

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/meters', async (_req, reply) => {
    const [meters, sites] = await Promise.all([
      query<Meter>(`
        SELECT m.id, s.name AS site_name, m.utility, m.unit, m.label
        FROM meter m JOIN site s ON s.id = m.site_id
        ORDER BY s.name, m.utility, m.label`),
      query<SiteOpt>(`SELECT id, name FROM site ORDER BY name`),
    ]);
    const body = `
      ${table(meters, [
        { header: 'ID',      cell: (r) => esc(r.id) },
        { header: 'Site',    cell: (r) => esc(r.site_name) },
        { header: 'Utility', cell: (r) => esc(r.utility) },
        { header: 'Unit',    cell: (r) => esc(r.unit) },
        { header: 'Label',   cell: (r) => esc(r.label) },
      ])}
      <h3>Add meter</h3>
      <form method="post" action="/meters">
        <label>Site <select name="site_id" required>${options(sites, (s) => s.id, (s) => s.name)}</select></label>
        <label>Utility <select name="utility">${options(UTILITIES)}</select></label>
        <label>Unit <select name="unit">${options(UNITS)}</select></label>
        <label>Label <input name="label" placeholder="main" /></label>
        <button>Add</button>
      </form>`;
    reply.type('text/html').send(page('Meters', body, { active: '/meters' }));
  });

  app.post<{
    Body: { site_id: string; utility: string; unit: string; label?: string };
  }>('/meters', async (req, reply) => {
    const site_id = Number(req.body.site_id);
    const { utility, unit } = req.body;
    const label = (req.body.label ?? '').trim() || 'main';
    if (!Number.isInteger(site_id) || !isUtility(utility) || !isUnit(unit)) {
      return reply.code(400).send('invalid input');
    }
    await exec(
      `INSERT INTO meter (site_id, utility, unit, label) VALUES ($1, $2::utility, $3::unit, $4)`,
      [site_id, utility, unit, label],
    );
    reply.redirect('/meters', 303);
  });
}
