import { test } from 'node:test';
import assert from 'node:assert/strict';
import { DuckDBInstance } from '@duckdb/node-api';
import { readFileSync } from 'node:fs';

// Self-contained smoke test against an in-memory DuckDB.
// Validates schema applies cleanly, ENUMs work, and v_period_usage
// computes deltas with the LAG window function.

async function setupMemoryDb() {
  const instance = await DuckDBInstance.create(':memory:');
  const conn = await instance.connect();
  await conn.run(`CREATE TYPE utility AS ENUM ('electric','gas','water')`);
  await conn.run(`CREATE TYPE unit AS ENUM ('kWh','m3','therm','gal','L')`);
  await conn.run(readFileSync('db/schema.sql', 'utf8'));
  await conn.run(readFileSync('db/views.sql', 'utf8'));
  return conn;
}

test('schema + views apply, reading delta is computed by v_period_usage', async () => {
  const conn = await setupMemoryDb();
  await conn.run(`INSERT INTO site (name) VALUES ('T')`);
  await conn.run(
    `INSERT INTO meter (site_id, utility, unit, label)
     VALUES ((SELECT id FROM site WHERE name='T'), 'electric', 'kWh', 'm')`,
  );
  await conn.run(
    `INSERT INTO reading (meter_id, read_at, value)
     VALUES ((SELECT id FROM meter LIMIT 1), TIMESTAMP '2026-01-01 00:00', 100),
            ((SELECT id FROM meter LIMIT 1), TIMESTAMP '2026-02-01 00:00', 150)`,
  );
  const reader = await conn.runAndReadAll(
    `SELECT usage, days FROM v_period_usage WHERE usage IS NOT NULL`,
  );
  const rows = reader.getRowObjects();
  assert.equal(rows.length, 1);
  assert.equal(String(rows[0]!['usage']), '50.000');
  assert.equal(Number(rows[0]!['days']), 31);
});

test('v_budget_status flags overage', async () => {
  const conn = await setupMemoryDb();
  await conn.run(`INSERT INTO site (name) VALUES ('T')`);
  await conn.run(
    `INSERT INTO meter (site_id, utility, unit, label)
     VALUES ((SELECT id FROM site WHERE name='T'), 'water', 'gal', 'm')`,
  );
  await conn.run(
    `INSERT INTO reading (meter_id, read_at, value)
     VALUES ((SELECT id FROM meter LIMIT 1), TIMESTAMP '2026-01-01 00:00', 0),
            ((SELECT id FROM meter LIMIT 1), TIMESTAMP '2026-01-15 00:00', 1000)`,
  );
  await conn.run(
    `INSERT INTO budget (site_id, utility, month, max_usage)
     VALUES ((SELECT id FROM site WHERE name='T'), 'water', DATE '2026-01-01', 500)`,
  );
  const reader = await conn.runAndReadAll(`SELECT over_budget FROM v_budget_status`);
  const rows = reader.getRowObjects();
  assert.equal(rows.length, 1);
  assert.equal(rows[0]!['over_budget'], true);
});
