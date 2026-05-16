import type { FastifyInstance } from 'fastify';
import { query, exec } from '../db.js';
import { page, table, esc } from '../views/layout.js';

type Site = { id: number; name: string; address: string | null; created_at: unknown };

export default async function (app: FastifyInstance): Promise<void> {
  app.get('/sites', async (_req, reply) => {
    const sites = await query<Site>(`SELECT id, name, address, created_at FROM site ORDER BY name`);
    const body = `
      ${table(sites, [
        { header: 'ID',      cell: (r) => esc(r.id) },
        { header: 'Name',    cell: (r) => esc(r.name) },
        { header: 'Address', cell: (r) => esc(r.address) },
        { header: 'Added',   cell: (r) => esc(r.created_at) },
      ])}
      <h3>Add site</h3>
      <form method="post" action="/sites">
        <label>Name <input name="name" required /></label>
        <label>Address <input name="address" /></label>
        <button>Add</button>
      </form>`;
    reply.type('text/html').send(page('Sites', body, { active: '/sites' }));
  });

  app.post<{ Body: { name: string; address?: string } }>('/sites', async (req, reply) => {
    const body = req.body ?? ({} as { name?: string; address?: string });
    const name = (body.name ?? '').trim();
    const address = (body.address ?? '').trim() || null;
    if (!name) return reply.code(400).send('name required');
    await exec(`INSERT INTO site (name, address) VALUES ($1, $2)`, [name, address]);
    reply.redirect('/sites', 303);
  });
}
