import { readFileSync, rmSync, existsSync } from 'node:fs';
import { getDb } from '../db.js';

async function main(): Promise<void> {
  const path = process.env.PUDS_DB ?? 'data/puds.duckdb';
  if (existsSync(path)) {
    rmSync(path);
    if (existsSync(`${path}.wal`)) rmSync(`${path}.wal`);
    console.log(`removed ${path}`);
  }
  const conn = await getDb(); // re-creates file, schema, views
  await conn.run(readFileSync('db/seed.sql', 'utf8'));
  console.log('seeded');
  process.exit(0);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
