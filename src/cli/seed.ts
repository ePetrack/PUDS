import { readFileSync, rmSync } from 'node:fs';
import { getDb } from '../db.js';

async function main(): Promise<void> {
  const path = process.env.PUDS_DB ?? 'data/puds.duckdb';
  rmSync(path, { force: true });
  rmSync(`${path}.wal`, { force: true });
  const conn = await getDb();
  await conn.run(readFileSync('db/seed.sql', 'utf8'));
  console.log('seeded');
  process.exit(0);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
