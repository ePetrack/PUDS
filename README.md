# PUDS

Personal utility data system — energy & water management on top of **vanilla DuckDB**.

A small Node/TypeScript app that opens an embedded DuckDB file, applies an idempotent SQL schema + views on boot, and serves a minimal Fastify web UI for logging meter readings, recording bills, setting monthly budgets, and seeing alerts when usage exceeds the budget. All deltas, rollups, and alert flags are computed in DuckDB views — there is no ORM and no app-side aggregation.

## Quick start

```bash
npm install
npm run seed     # creates data/puds.duckdb and inserts demo data
npm run dev      # http://localhost:3000
```

Run tests:

```bash
npm test
```

## Stack

- **DuckDB** (`@duckdb/node-api`) — embedded, file-backed at `data/puds.duckdb`
- **Fastify** + `@fastify/formbody` + `@fastify/static`
- **TypeScript** (`tsx` for dev, `tsc` for build)
- Plain template-literal HTML, single hand-written CSS file. No JSX, no bundler.

## Routes

| Path        | Purpose |
|-------------|---------|
| `/`         | Stats summary, latest monthly usage, top overages |
| `/sites`    | List and add sites |
| `/meters`   | List and add meters (per site, utility ∈ {electric, gas, water}) |
| `/readings` | List recent readings with computed delta (`v_period_usage`); add a reading |
| `/bills`    | List bills with paid status; add a bill |
| `/budgets`  | Monthly per-utility budgets vs. actual; upsert a budget |
| `/alerts`   | Rows of `v_budget_status` where actual > max |

## Schema

Defined in `db/schema.sql`:

- `site (id, name, address, created_at)`
- `meter (id, site_id, utility, unit, label)` — `utility` and `unit` are DuckDB `ENUM` types
- `reading (id, meter_id, read_at, value, note)` — UNIQUE(meter_id, read_at)
- `bill (id, site_id, utility, period_start, period_end, amount, usage, due_date, paid)`
- `budget (id, site_id, utility, month, max_usage, max_cost)` — UNIQUE(site_id, utility, month) (upsert target)

Views in `db/views.sql` do all the analytics:

- `v_period_usage` — uses `LAG(value) OVER (PARTITION BY meter_id ORDER BY read_at)` to compute period delta and days between readings.
- `v_monthly_usage` — `date_trunc('month', read_at)` rollup of `v_period_usage`.
- `v_budget_status` — joins `budget` to `v_monthly_usage`, returns `over_budget` and `pct_of_budget`.

## Notes

- The DB file lives in `./data/puds.duckdb` (gitignored). Override with `PUDS_DB=/some/path`.
- `CREATE TYPE` has no `IF NOT EXISTS` in DuckDB yet, so `src/db.ts` probes `duckdb_types()` and only creates ENUMs if missing.
- `npm run seed` deletes the DB file, recreates schema/views, and inserts demo data.
