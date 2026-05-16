import { DuckDBInstance } from '@duckdb/node-api';
import type { DuckDBConnection, DuckDBPreparedStatement } from '@duckdb/node-api';
import { readFileSync, mkdirSync } from 'node:fs';
import { dirname } from 'node:path';

const DB_PATH = process.env.PUDS_DB ?? 'data/puds.duckdb';

let connectionPromise: Promise<DuckDBConnection> | null = null;

export async function getDb(): Promise<DuckDBConnection> {
  if (!connectionPromise) connectionPromise = open(DB_PATH);
  return connectionPromise;
}

async function open(path: string): Promise<DuckDBConnection> {
  if (path !== ':memory:') mkdirSync(dirname(path), { recursive: true });
  const instance = await DuckDBInstance.create(path);
  const conn = await instance.connect();
  await ensureEnums(conn);
  await conn.run(readFileSync('db/schema.sql', 'utf8'));
  await conn.run(readFileSync('db/views.sql', 'utf8'));
  return conn;
}

// CREATE TYPE has no IF NOT EXISTS in DuckDB; check the catalog first.
async function ensureEnums(c: DuckDBConnection): Promise<void> {
  const reader = await c.runAndReadAll(
    `SELECT type_name FROM duckdb_types() WHERE type_name IN ('utility','unit')`,
  );
  const names = new Set(reader.getRowObjects().map((r) => String(r['type_name'])));
  if (!names.has('utility')) {
    await c.run(`CREATE TYPE utility AS ENUM ('electric','gas','water')`);
  }
  if (!names.has('unit')) {
    await c.run(`CREATE TYPE unit AS ENUM ('kWh','m3','therm','gal','L')`);
  }
}

export type Row = Record<string, unknown>;

export async function query<T extends Row = Row>(
  sql: string,
  params: unknown[] = [],
): Promise<T[]> {
  const conn = await getDb();
  if (params.length === 0) {
    const reader = await conn.runAndReadAll(sql);
    return reader.getRowObjects() as T[];
  }
  const prep = await conn.prepare(sql);
  bindAll(prep, params);
  const reader = await prep.runAndReadAll();
  return reader.getRowObjects() as T[];
}

export async function exec(sql: string, params: unknown[] = []): Promise<void> {
  const conn = await getDb();
  if (params.length === 0) {
    await conn.run(sql);
    return;
  }
  const prep = await conn.prepare(sql);
  bindAll(prep, params);
  await prep.run();
}

function bindAll(prep: DuckDBPreparedStatement, params: unknown[]): void {
  for (let i = 0; i < params.length; i++) {
    const idx = i + 1;
    const v = params[i];
    if (v === null || v === undefined) {
      prep.bindNull(idx);
    } else if (typeof v === 'boolean') {
      prep.bindBoolean(idx, v);
    } else if (typeof v === 'number') {
      if (Number.isInteger(v)) prep.bindInteger(idx, v);
      else prep.bindDouble(idx, v);
    } else if (typeof v === 'bigint') {
      prep.bindBigInt(idx, v);
    } else if (typeof v === 'string') {
      prep.bindVarchar(idx, v);
    } else {
      throw new Error(`unsupported param type at $${idx}: ${typeof v}`);
    }
  }
}
