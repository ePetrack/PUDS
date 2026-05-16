-- ENUM types are created by src/db.ts:ensureEnums() (DuckDB has no CREATE TYPE IF NOT EXISTS).

CREATE SEQUENCE IF NOT EXISTS seq_site;
CREATE TABLE IF NOT EXISTS site (
  id         INTEGER PRIMARY KEY DEFAULT nextval('seq_site'),
  name       TEXT NOT NULL UNIQUE,
  address    TEXT,
  created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE SEQUENCE IF NOT EXISTS seq_meter;
CREATE TABLE IF NOT EXISTS meter (
  id      INTEGER PRIMARY KEY DEFAULT nextval('seq_meter'),
  site_id INTEGER NOT NULL REFERENCES site(id),
  utility utility NOT NULL,
  unit    unit    NOT NULL,
  label   TEXT,
  UNIQUE(site_id, utility, label)
);

CREATE SEQUENCE IF NOT EXISTS seq_reading;
CREATE TABLE IF NOT EXISTS reading (
  id       INTEGER PRIMARY KEY DEFAULT nextval('seq_reading'),
  meter_id INTEGER NOT NULL REFERENCES meter(id),
  read_at  TIMESTAMP NOT NULL,
  value    DECIMAL(14,3) NOT NULL,
  note     TEXT,
  UNIQUE(meter_id, read_at)
);

CREATE SEQUENCE IF NOT EXISTS seq_bill;
CREATE TABLE IF NOT EXISTS bill (
  id           INTEGER PRIMARY KEY DEFAULT nextval('seq_bill'),
  site_id      INTEGER NOT NULL REFERENCES site(id),
  utility      utility NOT NULL,
  period_start DATE NOT NULL,
  period_end   DATE NOT NULL,
  amount       DECIMAL(10,2) NOT NULL,
  usage        DECIMAL(14,3),
  due_date     DATE,
  paid         BOOLEAN DEFAULT FALSE
);

CREATE SEQUENCE IF NOT EXISTS seq_budget;
CREATE TABLE IF NOT EXISTS budget (
  id        INTEGER PRIMARY KEY DEFAULT nextval('seq_budget'),
  site_id   INTEGER NOT NULL REFERENCES site(id),
  utility   utility NOT NULL,
  month     DATE NOT NULL,
  max_usage DECIMAL(14,3),
  max_cost  DECIMAL(10,2),
  UNIQUE(site_id, utility, month)
);
