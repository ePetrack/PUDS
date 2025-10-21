-- PUDS Database Initialization Script
-- Creates TimescaleDB hypertables for time-series data

-- Enable TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Note: Tables will be created automatically by SQLAlchemy
-- This script sets up TimescaleDB-specific features after table creation

-- Create hypertable for meter_readings (time-series data)
-- Run this after initial table creation
DO $$
BEGIN
    -- Check if table exists and is not already a hypertable
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'meter_readings') THEN
        -- Only create hypertable if it doesn't exist
        IF NOT EXISTS (SELECT 1 FROM timescaledb_information.hypertables WHERE hypertable_name = 'meter_readings') THEN
            PERFORM create_hypertable('meter_readings', 'timestamp',
                chunk_time_interval => INTERVAL '1 week',
                if_not_exists => TRUE
            );

            -- Create compression policy (compress data older than 30 days)
            PERFORM add_compression_policy('meter_readings', INTERVAL '30 days');

            -- Create retention policy (keep data for 5 years)
            PERFORM add_retention_policy('meter_readings', INTERVAL '5 years');
        END IF;
    END IF;
END
$$;

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_meter_readings_quality ON meter_readings(quality) WHERE quality != 'good';
CREATE INDEX IF NOT EXISTS idx_utility_bills_date_range ON utility_bills(billing_period_start, billing_period_end);
CREATE INDEX IF NOT EXISTS idx_buildings_org ON buildings(organization_id);

-- Create views for common queries
CREATE OR REPLACE VIEW v_latest_meter_readings AS
SELECT DISTINCT ON (meter_id)
    meter_id,
    timestamp,
    value,
    unit,
    quality
FROM meter_readings
ORDER BY meter_id, timestamp DESC;

CREATE OR REPLACE VIEW v_monthly_utility_costs AS
SELECT
    DATE_TRUNC('month', bill_date) as month,
    u.utility_type,
    SUM(ub.total_cost) as total_cost,
    SUM(ub.consumption) as total_consumption,
    AVG(ub.total_cost / NULLIF(ub.consumption, 0)) as avg_unit_cost
FROM utility_bills ub
JOIN utilities u ON ub.utility_id = u.id
GROUP BY DATE_TRUNC('month', bill_date), u.utility_type;

-- Grant permissions
GRANT SELECT ON v_latest_meter_readings TO PUBLIC;
GRANT SELECT ON v_monthly_utility_costs TO PUBLIC;

COMMENT ON EXTENSION timescaledb IS 'TimescaleDB extension for efficient time-series data handling';
COMMENT ON TABLE meter_readings IS 'Time-series meter readings optimized with TimescaleDB hypertable';
