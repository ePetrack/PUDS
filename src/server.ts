import Fastify from 'fastify';
import formbody from '@fastify/formbody';
import fstatic from '@fastify/static';
import { resolve } from 'node:path';
import { getDb } from './db.js';
import dashboard from './routes/dashboard.js';
import sites from './routes/sites.js';
import meters from './routes/meters.js';
import readings from './routes/readings.js';
import bills from './routes/bills.js';
import budgets from './routes/budgets.js';
import alerts from './routes/alerts.js';

const PORT = Number(process.env.PORT ?? 3000);

async function main(): Promise<void> {
  await getDb(); // open + apply schema/views before serving traffic
  const app = Fastify({ logger: true });
  await app.register(formbody);
  await app.register(fstatic, { root: resolve('public'), prefix: '/' });
  await app.register(dashboard);
  await app.register(sites);
  await app.register(meters);
  await app.register(readings);
  await app.register(bills);
  await app.register(budgets);
  await app.register(alerts);
  await app.listen({ port: PORT, host: '0.0.0.0' });
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
