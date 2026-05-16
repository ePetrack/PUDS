-- All derivations live in DuckDB views.

-- Period spans (period_start, period_end]; usage is attributed to period_start
-- so a reading taken on May 1 closes out April.
CREATE OR REPLACE VIEW v_period_usage AS
SELECT
  r.id                                                   AS reading_id,
  r.meter_id,
  m.site_id,
  m.utility,
  m.unit,
  LAG(r.read_at) OVER w                                  AS period_start,
  r.read_at                                              AS period_end,
  r.value,
  r.value - LAG(r.value) OVER w                          AS usage,
  date_diff('day', LAG(r.read_at) OVER w, r.read_at)     AS days
FROM reading r
JOIN meter m ON m.id = r.meter_id
WINDOW w AS (PARTITION BY r.meter_id ORDER BY r.read_at);

-- Monthly usage rolled up by period_start (the month the consumption occurred).
CREATE OR REPLACE VIEW v_monthly_usage AS
SELECT
  site_id,
  utility,
  date_trunc('month', period_start)::DATE AS month,
  SUM(usage)                              AS usage
FROM v_period_usage
WHERE usage IS NOT NULL AND period_start IS NOT NULL
GROUP BY 1, 2, 3;

-- Budget status = actual monthly usage vs. configured budget.
CREATE OR REPLACE VIEW v_budget_status AS
SELECT
  b.id                                                       AS budget_id,
  b.site_id,
  s.name                                                     AS site_name,
  b.utility,
  b.month,
  b.max_usage,
  COALESCE(u.usage, 0)                                       AS actual_usage,
  COALESCE(u.usage, 0) > b.max_usage                         AS over_budget,
  CASE WHEN b.max_usage > 0
       THEN ROUND(100.0 * COALESCE(u.usage, 0) / b.max_usage, 1)
       ELSE NULL END                                         AS pct_of_budget
FROM budget b
JOIN site s ON s.id = b.site_id
LEFT JOIN v_monthly_usage u
  ON u.site_id = b.site_id
 AND u.utility = b.utility
 AND u.month   = b.month;
