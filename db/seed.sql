-- Demo data so the dashboard isn't empty on first run.

INSERT INTO site (name, address) VALUES
  ('Home',  '1 Maple St'),
  ('Cabin', 'Off-grid Rd');

INSERT INTO meter (site_id, utility, unit, label) VALUES
  ((SELECT id FROM site WHERE name='Home'),  'electric', 'kWh', 'main'),
  ((SELECT id FROM site WHERE name='Home'),  'gas',      'therm','main'),
  ((SELECT id FROM site WHERE name='Home'),  'water',    'gal',  'main'),
  ((SELECT id FROM site WHERE name='Cabin'), 'electric', 'kWh',  'main');

-- Two readings per meter, ~one month apart. Deltas surface via v_period_usage.
INSERT INTO reading (meter_id, read_at, value) VALUES
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Home') AND utility='electric'), TIMESTAMP '2026-04-01 08:00', 12000.000),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Home') AND utility='electric'), TIMESTAMP '2026-05-01 08:00', 12480.500),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Home') AND utility='gas'),      TIMESTAMP '2026-04-01 08:00',  3200.000),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Home') AND utility='gas'),      TIMESTAMP '2026-05-01 08:00',  3245.250),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Home') AND utility='water'),    TIMESTAMP '2026-04-01 08:00', 88000.000),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Home') AND utility='water'),    TIMESTAMP '2026-05-01 08:00', 91200.000),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Cabin') AND utility='electric'),TIMESTAMP '2026-04-01 08:00',   500.000),
  ((SELECT id FROM meter WHERE site_id=(SELECT id FROM site WHERE name='Cabin') AND utility='electric'),TIMESTAMP '2026-05-01 08:00',   580.000);

INSERT INTO bill (site_id, utility, period_start, period_end, amount, usage, due_date, paid) VALUES
  ((SELECT id FROM site WHERE name='Home'), 'electric', DATE '2026-04-01', DATE '2026-04-30',  72.40,   480.500, DATE '2026-05-20', FALSE),
  ((SELECT id FROM site WHERE name='Home'), 'gas',      DATE '2026-04-01', DATE '2026-04-30',  38.10,    45.250, DATE '2026-05-20', TRUE),
  ((SELECT id FROM site WHERE name='Home'), 'water',    DATE '2026-04-01', DATE '2026-04-30',  41.00,  3200.000, DATE '2026-05-20', FALSE);

-- Budget tight on water for April so /alerts shows an overage.
INSERT INTO budget (site_id, utility, month, max_usage, max_cost) VALUES
  ((SELECT id FROM site WHERE name='Home'), 'electric', DATE '2026-04-01',   600.000,  90.00),
  ((SELECT id FROM site WHERE name='Home'), 'gas',      DATE '2026-04-01',    60.000,  50.00),
  ((SELECT id FROM site WHERE name='Home'), 'water',    DATE '2026-04-01',  2500.000,  35.00);
