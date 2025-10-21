# Dual Database Architecture: SQLite + DuckDB

PUDS uses a sophisticated dual-database architecture that combines the strengths of both SQLite and DuckDB.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PUDS Application Layer                    │
└──────────────────────┬──────────────────┬───────────────────┘
                       │                  │
        ┌──────────────▼─────────────┐   │
        │  Transactional Operations  │   │
        │  (OLTP - SQLite)           │   │
        └──────────────┬─────────────┘   │
                       │                  │
                ┌──────▼──────┐          │
                │  SQLite DB  │          │
                │  (puds.db)  │          │
                │             │◄─────────┼─────────┐
                │ - Users     │          │         │
                │ - Buildings │          │         │
                │ - Bills     │          │         │
                │ - Meters    │          │         │
                └─────────────┘          │         │
                                         │         │
                       ┌─────────────────▼─────────┴──────┐
                       │  Analytical Operations           │
                       │  (OLAP - DuckDB)                 │
                       │                                  │
                       │  Reads from SQLite via           │
                       │  sqlite_scan() - No duplication! │
                       └──────────────────────────────────┘
```

## Database Roles

### SQLite - Transactional Database (OLTP)

**Purpose:** Handle all data writes and real-time operations

**Optimized For:**
- ✅ INSERT, UPDATE, DELETE operations
- ✅ ACID transactions
- ✅ Concurrent reads
- ✅ Data integrity
- ✅ Real-time data entry

**Use Cases in PUDS:**
- User authentication and management
- Organization and building data
- Utility account management
- Bill uploads and updates
- Meter registrations
- Real-time meter readings

**Storage:** Row-based (fast for transactional operations)

**File:** `backend/puds.db`

### DuckDB - Analytical Database (OLAP)

**Purpose:** Handle complex analytical queries and reporting

**Optimized For:**
- ✅ Complex aggregations (SUM, AVG, GROUP BY)
- ✅ Time-series analysis
- ✅ Statistical calculations
- ✅ Window functions (LAG, LEAD, ROW_NUMBER)
- ✅ Large dataset scans
- ✅ Multi-table joins

**Use Cases in PUDS:**
- ISO 50001 EnPI calculations
- Energy baseline computations
- Trend analysis and forecasting
- Building performance comparisons
- Monthly/annual reports
- Weather normalization
- Regression analysis

**Storage:** Column-based (fast for analytical operations)

**Mode:** In-memory (no separate file needed!)

## How They Work Together

### Data Flow

1. **All Writes → SQLite**
   ```python
   # User uploads a utility bill
   session.add(UtilityBill(...))
   session.commit()
   # Data saved to SQLite
   ```

2. **Complex Analytics → DuckDB reads from SQLite**
   ```python
   # Calculate 12-month energy baseline
   analytics = get_analytics()
   baseline = analytics.calculate_energy_baseline(months=12)
   # DuckDB reads from SQLite, no data duplication!
   ```

### No Data Duplication!

DuckDB uses the `sqlite_scan()` function to read directly from SQLite:

```sql
-- DuckDB query that reads from SQLite
SELECT
    DATE_TRUNC('month', billing_period_start) as month,
    SUM(consumption) as total_consumption,
    AVG(total_cost) as avg_cost
FROM sqlite_scan('puds.db', 'utility_bills')
WHERE billing_period_start >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY month
ORDER BY month DESC
```

**Benefits:**
- ✅ Single source of truth (SQLite)
- ✅ No ETL processes needed
- ✅ No data synchronization issues
- ✅ Real-time analytics on latest data
- ✅ Minimal storage overhead

## Performance Comparison

### SQLite vs DuckDB for Common Operations

| Operation | Best Database | Reason |
|-----------|--------------|--------|
| Insert 1 bill | SQLite | Row-based, transactional |
| Update building info | SQLite | ACID compliance |
| Calculate 12-month average | DuckDB | Column scan, aggregation |
| Time-series grouping | DuckDB | Window functions |
| Join 3+ tables with aggregation | DuckDB | Analytical optimizer |
| Get single user record | SQLite | Row-based lookup |
| Generate monthly report | DuckDB | Large scans, complex math |

### Example Performance Gains

**Scenario:** Calculate average consumption across 1 million meter readings

- **SQLite:** ~2-5 seconds (row-by-row scan)
- **DuckDB:** ~100-300ms (column scan, vectorized)

**Speedup:** 10-50x faster! 🚀

## API Endpoints

### SQLite Endpoints (Standard CRUD)

```
POST   /api/bills              # Create new bill
PUT    /api/bills/{id}         # Update bill
DELETE /api/bills/{id}         # Delete bill
GET    /api/bills/{id}         # Get single bill
```

### DuckDB Endpoints (Analytics)

```
GET /api/analytics-advanced/energy-baseline
GET /api/analytics-advanced/enpi-trends
GET /api/analytics-advanced/time-series-aggregation
GET /api/analytics-advanced/custom-query
```

## Code Examples

### Using SQLite (Transactional)

```python
from sqlalchemy import select
from db.session import AsyncSessionLocal
from models.utility import UtilityBill

# Insert a new bill
async with AsyncSessionLocal() as session:
    bill = UtilityBill(
        utility_id=1,
        bill_date=datetime.now(),
        consumption=5000,
        total_cost=650.00
    )
    session.add(bill)
    await session.commit()
```

### Using DuckDB (Analytical)

```python
from services.analytics import get_analytics

# Calculate energy baseline
analytics = get_analytics()

# Option 1: Use helper method
baseline = analytics.calculate_energy_baseline(months=12)

# Option 2: Execute custom SQL
result = analytics.execute_analytical_query("""
    SELECT
        building_id,
        AVG(consumption) as avg_consumption,
        STDDEV(consumption) as stddev_consumption
    FROM utility_bills
    WHERE billing_period_start >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY building_id
    ORDER BY avg_consumption DESC
""")
```

## ISO 50001 Use Cases

### Energy Baseline Calculation

**Requirement:** Calculate 12-month rolling baseline

**Implementation:** DuckDB
```python
baseline = analytics.calculate_energy_baseline(months=12)
```

**Why DuckDB:**
- Aggregates millions of readings
- Statistical functions (AVG, STDDEV)
- Date arithmetic built-in

### EnPI Trend Analysis

**Requirement:** Month-over-month performance tracking

**Implementation:** DuckDB with window functions
```sql
SELECT
    month,
    consumption,
    LAG(consumption) OVER (ORDER BY month) as prev_month,
    (consumption - LAG(consumption) OVER (ORDER BY month)) /
        LAG(consumption) OVER (ORDER BY month) * 100 as pct_change
FROM monthly_consumption
```

**Why DuckDB:**
- Window functions (LAG, LEAD)
- Complex calculations
- Time-series optimization

### Weather Normalization

**Requirement:** Adjust consumption for weather variations

**Implementation:** DuckDB with regression
```sql
SELECT
    regression_slope(heating_degree_days, consumption) as weather_coefficient
FROM utility_bills
```

**Why DuckDB:**
- Statistical regression functions
- Large dataset handling
- Fast correlation calculations

## When to Use Which Database

### Use SQLite When:
- ✅ Creating, updating, or deleting data
- ✅ Single-record lookups
- ✅ Transactional operations requiring ACID
- ✅ User authentication/authorization
- ✅ Real-time data entry

### Use DuckDB When:
- ✅ Aggregating across many records
- ✅ Time-series analysis
- ✅ Statistical calculations
- ✅ Generating reports
- ✅ Complex multi-table joins
- ✅ ISO 50001 EnPI calculations
- ✅ Baseline computations

## Benefits of This Architecture

### 1. Performance
- Each database optimized for its workload
- 10-100x faster analytics queries
- No performance impact on transactional operations

### 2. Simplicity
- Both are embedded databases (no servers!)
- Single file for data (puds.db)
- No complex synchronization
- Easy backup (just copy puds.db)

### 3. Scalability
- SQLite handles up to ~1TB databases
- DuckDB processes billions of rows
- Can migrate to PostgreSQL + TimescaleDB later if needed

### 4. Development Experience
- Fast local development
- No database servers to manage
- Easy testing and debugging
- Can run on any platform

### 5. Cost
- Zero database licensing costs
- No server infrastructure needed
- Can run on developer laptops
- Scale up to cloud when ready

## Migration Path

As your PUDS deployment grows, you can migrate:

### Phase 1: Development (Current)
```
SQLite (transactions) + DuckDB (analytics)
```

### Phase 2: Small Production (<100 buildings)
```
SQLite (transactions) + DuckDB (analytics)
```
Still works great! Single-file deployment.

### Phase 3: Medium Production (100-1000 buildings)
```
PostgreSQL (transactions) + DuckDB (analytics)
```
PostgreSQL for better concurrency, DuckDB still reads directly.

### Phase 4: Large Production (1000+ buildings)
```
PostgreSQL + TimescaleDB (transactions + time-series)
+ DuckDB (analytics)
```
Add TimescaleDB for optimized meter data, DuckDB for reporting.

**The beauty:** Your application code doesn't change much! The dual-database pattern scales with you.

## Monitoring

### Check Database Sizes

```bash
# SQLite database size
ls -lh backend/puds.db

# DuckDB is in-memory, check process memory
ps aux | grep uvicorn
```

### Query Performance

```python
import time

# Time a DuckDB query
start = time.time()
result = analytics.execute_analytical_query("SELECT ...")
elapsed = time.time() - start
print(f"Query took {elapsed:.3f} seconds")
```

## Best Practices

### 1. Use SQLite for All Writes
```python
# Good
session.add(bill)
await session.commit()

# Bad - Don't write to DuckDB
# DuckDB is read-only in this architecture
```

### 2. Use DuckDB for Heavy Analytics
```python
# Good - Complex aggregation
analytics.calculate_enpi_trend(months=24)

# Avoid - Simple single-record lookup (use SQLite)
# analytics.query_sqlite("SELECT * FROM bills WHERE id = 1")
```

### 3. Cache Expensive Queries
```python
from functools import lru_cache

@lru_cache(maxsize=100)
def get_baseline(building_id, months):
    return analytics.calculate_energy_baseline(
        months=months,
        building_id=building_id
    )
```

### 4. Close Connections Properly
```python
# Use context manager
with DuckDBAnalytics() as analytics:
    result = analytics.execute_analytical_query("...")
# Connection closed automatically
```

## Troubleshooting

### DuckDB Can't Find SQLite File

**Error:** `sqlite_scan: file not found`

**Solution:** Use absolute path
```python
import os
db_path = os.path.abspath("backend/puds.db")
analytics = DuckDBAnalytics(db_path)
```

### SQLite Database Locked

**Error:** `database is locked`

**Solution:** SQLite handles concurrent reads fine, but only one writer at a time. This is normal and handled by connection pooling.

### Out of Memory

**Error:** DuckDB uses too much memory

**Solution:** Use streaming or limit query results
```sql
SELECT * FROM large_table LIMIT 10000
```

## Summary

The dual-database architecture gives PUDS:

✅ **Best of both worlds** - OLTP + OLAP optimized
✅ **Simple deployment** - No servers needed
✅ **High performance** - 10-100x faster analytics
✅ **No duplication** - Single source of truth
✅ **Easy migration** - Scales from laptop to enterprise
✅ **ISO 50001 ready** - Perfect for EnPI calculations

This architecture is perfect for PUDS because utility management is inherently analytical - you're constantly calculating baselines, trends, and performance metrics across historical data.
