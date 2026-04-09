-- ============================================================
-- FILE: 03_Clinic_Schema_Setup.sql
-- PURPOSE: Create tables and insert sample data for Clinic system
-- ============================================================

DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS customer;

-- ─────────────────────────────────────────
-- TABLE: clinics
-- ─────────────────────────────────────────
CREATE TABLE clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

-- ─────────────────────────────────────────
-- TABLE: customer
-- ─────────────────────────────────────────
CREATE TABLE customer (
    uid     VARCHAR(50) PRIMARY KEY,
    name    VARCHAR(100),
    mobile  VARCHAR(15)
);

-- ─────────────────────────────────────────
-- TABLE: clinic_sales
-- ─────────────────────────────────────────
CREATE TABLE clinic_sales (
    oid           VARCHAR(50) PRIMARY KEY,
    uid           VARCHAR(50),
    cid           VARCHAR(50),
    amount        DECIMAL(12, 2),
    datetime      DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ─────────────────────────────────────────
-- TABLE: expenses
-- ─────────────────────────────────────────
CREATE TABLE expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(12, 2),
    datetime    DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
-- SAMPLE DATA INSERTS
-- ============================================================

INSERT INTO clinics VALUES
  ('cnc-001', 'Apollo Clinic',   'Mumbai',    'Maharashtra', 'India'),
  ('cnc-002', 'Wellness Hub',    'Pune',       'Maharashtra', 'India'),
  ('cnc-003', 'CareFirst',       'Delhi',      'Delhi',       'India'),
  ('cnc-004', 'HealthPlus',      'Delhi',      'Delhi',       'India'),
  ('cnc-005', 'MediCare',        'Bangalore',  'Karnataka',   'India'),
  ('cnc-006', 'City Clinic',     'Bangalore',  'Karnataka',   'India');

INSERT INTO customer VALUES
  ('cust-001', 'Alice Johnson', '9800000001'),
  ('cust-002', 'Bob Williams',  '9800000002'),
  ('cust-003', 'Carol Davis',   '9800000003'),
  ('cust-004', 'Dan Miller',    '9800000004'),
  ('cust-005', 'Eva Wilson',    '9800000005');

-- Sales spread across months, clinics, channels
INSERT INTO clinic_sales VALUES
  ('ord-001', 'cust-001', 'cnc-001', 5000,  '2021-01-05 10:00:00', 'online'),
  ('ord-002', 'cust-002', 'cnc-001', 8000,  '2021-01-12 11:30:00', 'walk-in'),
  ('ord-003', 'cust-003', 'cnc-002', 3000,  '2021-02-08 09:00:00', 'online'),
  ('ord-004', 'cust-001', 'cnc-002', 7500,  '2021-02-15 14:00:00', 'referral'),
  ('ord-005', 'cust-004', 'cnc-003', 12000, '2021-03-10 10:00:00', 'walk-in'),
  ('ord-006', 'cust-005', 'cnc-003', 9000,  '2021-03-20 13:00:00', 'online'),
  ('ord-007', 'cust-002', 'cnc-004', 15000, '2021-04-02 09:30:00', 'referral'),
  ('ord-008', 'cust-003', 'cnc-004', 6000,  '2021-04-18 15:00:00', 'walk-in'),
  ('ord-009', 'cust-001', 'cnc-005', 11000, '2021-05-05 10:00:00', 'online'),
  ('ord-010', 'cust-004', 'cnc-005', 4500,  '2021-05-22 11:00:00', 'walk-in'),
  ('ord-011', 'cust-005', 'cnc-006', 7000,  '2021-06-08 09:00:00', 'referral'),
  ('ord-012', 'cust-001', 'cnc-001', 9500,  '2021-07-14 14:00:00', 'online'),
  ('ord-013', 'cust-002', 'cnc-002', 5500,  '2021-08-03 10:30:00', 'walk-in'),
  ('ord-014', 'cust-003', 'cnc-003', 8800,  '2021-09-19 11:00:00', 'online'),
  ('ord-015', 'cust-004', 'cnc-004', 13000, '2021-10-07 16:00:00', 'referral'),
  ('ord-016', 'cust-005', 'cnc-005', 6200,  '2021-11-12 09:00:00', 'walk-in'),
  ('ord-017', 'cust-001', 'cnc-006', 4000,  '2021-12-01 13:00:00', 'online'),
  ('ord-018', 'cust-002', 'cnc-006', 17000, '2021-12-20 10:00:00', 'referral');

-- Expenses per clinic per month
INSERT INTO expenses VALUES
  ('exp-001', 'cnc-001', 'Salaries',          3000, '2021-01-31 00:00:00'),
  ('exp-002', 'cnc-001', 'Supplies',           800,  '2021-01-31 00:00:00'),
  ('exp-003', 'cnc-002', 'Rent',               2000, '2021-02-28 00:00:00'),
  ('exp-004', 'cnc-002', 'Utilities',          500,  '2021-02-28 00:00:00'),
  ('exp-005', 'cnc-003', 'Salaries',           4000, '2021-03-31 00:00:00'),
  ('exp-006', 'cnc-003', 'Equipment Repair',   1200, '2021-03-31 00:00:00'),
  ('exp-007', 'cnc-004', 'Rent',               3500, '2021-04-30 00:00:00'),
  ('exp-008', 'cnc-004', 'Supplies',           700,  '2021-04-30 00:00:00'),
  ('exp-009', 'cnc-005', 'Salaries',           3800, '2021-05-31 00:00:00'),
  ('exp-010', 'cnc-005', 'Marketing',          600,  '2021-05-31 00:00:00'),
  ('exp-011', 'cnc-006', 'Rent',               2500, '2021-06-30 00:00:00'),
  ('exp-012', 'cnc-001', 'Salaries',           3000, '2021-07-31 00:00:00'),
  ('exp-013', 'cnc-002', 'Supplies',           400,  '2021-08-31 00:00:00'),
  ('exp-014', 'cnc-003', 'Utilities',          900,  '2021-09-30 00:00:00'),
  ('exp-015', 'cnc-004', 'Salaries',           4200, '2021-10-31 00:00:00'),
  ('exp-016', 'cnc-005', 'Rent',               2200, '2021-11-30 00:00:00'),
  ('exp-017', 'cnc-006', 'Salaries',           3100, '2021-12-31 00:00:00'),
  ('exp-018', 'cnc-006', 'Supplies',           600,  '2021-12-31 00:00:00');
