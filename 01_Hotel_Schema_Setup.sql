-- ============================================================
-- FILE: 01_Hotel_Schema_Setup.sql
-- PURPOSE: Create tables and insert sample data for Hotel system
-- ============================================================

-- Drop tables if they already exist (for re-runs)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- ─────────────────────────────────────────
-- TABLE: users
-- ─────────────────────────────────────────
CREATE TABLE users (
    user_id         VARCHAR(50) PRIMARY KEY,
    name            VARCHAR(100),
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

-- ─────────────────────────────────────────
-- TABLE: items
-- ─────────────────────────────────────────
CREATE TABLE items (
    item_id     VARCHAR(50) PRIMARY KEY,
    item_name   VARCHAR(100),
    item_rate   DECIMAL(10, 2)
);

-- ─────────────────────────────────────────
-- TABLE: bookings
-- ─────────────────────────────────────────
CREATE TABLE bookings (
    booking_id      VARCHAR(50) PRIMARY KEY,
    booking_date    DATETIME,
    room_no         VARCHAR(50),
    user_id         VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ─────────────────────────────────────────
-- TABLE: booking_commercials
-- ─────────────────────────────────────────
CREATE TABLE booking_commercials (
    id              VARCHAR(50) PRIMARY KEY,
    booking_id      VARCHAR(50),
    bill_id         VARCHAR(50),
    bill_date       DATETIME,
    item_id         VARCHAR(50),
    item_quantity   DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
-- SAMPLE DATA INSERTS
-- ============================================================

INSERT INTO users VALUES
  ('usr-001', 'John Doe',   '9700000001', 'john.doe@example.com',   '10, Street A, City X'),
  ('usr-002', 'Jane Smith', '9700000002', 'jane.smith@example.com', '20, Street B, City Y'),
  ('usr-003', 'Bob Ray',    '9700000003', 'bob.ray@example.com',    '30, Street C, City Z');

INSERT INTO items VALUES
  ('itm-a9e8-q8fu',  'Tawa Paratha',  18.00),
  ('itm-a07vh-aer8', 'Mix Veg',       89.00),
  ('itm-w978-23u4',  'Butter Naan',   25.00),
  ('itm-b123-xy45',  'Dal Makhani',   120.00),
  ('itm-c456-zw89',  'Lassi',         60.00),
  ('itm-d789-pq12',  'Paneer Tikka',  200.00);

INSERT INTO bookings VALUES
  ('bk-001', '2021-09-15 10:00:00', 'rm-101', 'usr-001'),
  ('bk-002', '2021-10-05 14:00:00', 'rm-202', 'usr-001'),
  ('bk-003', '2021-10-18 09:30:00', 'rm-303', 'usr-002'),
  ('bk-004', '2021-11-02 11:00:00', 'rm-101', 'usr-003'),
  ('bk-005', '2021-11-10 16:00:00', 'rm-404', 'usr-002'),
  ('bk-006', '2021-11-22 08:45:00', 'rm-505', 'usr-001'),
  ('bk-007', '2021-12-01 12:00:00', 'rm-202', 'usr-003');

-- booking_commercials: each row = one line item on a bill
INSERT INTO booking_commercials VALUES
  -- September booking bk-001
  ('bc-001', 'bk-001', 'bl-001', '2021-09-15 12:00:00', 'itm-a9e8-q8fu',  3),
  ('bc-002', 'bk-001', 'bl-001', '2021-09-15 12:00:00', 'itm-a07vh-aer8', 1),

  -- October booking bk-002
  ('bc-003', 'bk-002', 'bl-002', '2021-10-06 09:00:00', 'itm-b123-xy45',  2),
  ('bc-004', 'bk-002', 'bl-002', '2021-10-06 09:00:00', 'itm-d789-pq12',  3),
  ('bc-005', 'bk-002', 'bl-003', '2021-10-06 20:00:00', 'itm-c456-zw89',  5),

  -- October booking bk-003
  ('bc-006', 'bk-003', 'bl-004', '2021-10-19 10:00:00', 'itm-a9e8-q8fu',  10),
  ('bc-007', 'bk-003', 'bl-004', '2021-10-19 10:00:00', 'itm-w978-23u4',  4),
  ('bc-008', 'bk-003', 'bl-005', '2021-10-20 18:00:00', 'itm-d789-pq12',  2),

  -- November booking bk-004
  ('bc-009', 'bk-004', 'bl-006', '2021-11-03 11:00:00', 'itm-b123-xy45',  4),
  ('bc-010', 'bk-004', 'bl-006', '2021-11-03 11:00:00', 'itm-a07vh-aer8', 2),

  -- November booking bk-005
  ('bc-011', 'bk-005', 'bl-007', '2021-11-11 14:00:00', 'itm-d789-pq12',  5),
  ('bc-012', 'bk-005', 'bl-007', '2021-11-11 14:00:00', 'itm-c456-zw89',  3),

  -- November booking bk-006
  ('bc-013', 'bk-006', 'bl-008', '2021-11-23 09:00:00', 'itm-w978-23u4',  6),
  ('bc-014', 'bk-006', 'bl-008', '2021-11-23 09:00:00', 'itm-a9e8-q8fu',  8),

  -- December booking bk-007
  ('bc-015', 'bk-007', 'bl-009', '2021-12-02 15:00:00', 'itm-b123-xy45',  3),
  ('bc-016', 'bk-007', 'bl-009', '2021-12-02 15:00:00', 'itm-d789-pq12',  2);
