-- ============================================================
-- FILE: 02_Hotel_Queries.sql
-- PURPOSE: Answer all 5 questions for the Hotel Management System
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- Q1: For every user in the system, get the user_id and
--     the last booked room_no
-- ─────────────────────────────────────────────────────────────
-- APPROACH: Join users with bookings. For each user, find the
-- booking with the MAX booking_date using a subquery or window function.

SELECT
    u.user_id,
    u.name,
    b.room_no   AS last_booked_room
FROM users u
JOIN bookings b
  ON b.user_id      = u.user_id
  AND b.booking_date = (
        -- Get the latest booking date for this specific user
        SELECT MAX(b2.booking_date)
        FROM   bookings b2
        WHERE  b2.user_id = u.user_id
  );


-- ─────────────────────────────────────────────────────────────
-- Q2: Get booking_id and total billing amount of every booking
--     created in November 2021
-- ─────────────────────────────────────────────────────────────
-- APPROACH: Filter bookings by year=2021, month=11, then join
-- booking_commercials + items to compute quantity * rate per line,
-- and SUM per booking.

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON bc.booking_id = b.booking_id
JOIN items               i  ON i.item_id     = bc.item_id
WHERE YEAR(b.booking_date)  = 2021
  AND MONTH(b.booking_date) = 11          -- November
GROUP BY b.booking_id;


-- ─────────────────────────────────────────────────────────────
-- Q3: Get bill_id and bill amount of all bills raised in
--     October 2021 having bill amount > 1000
-- ─────────────────────────────────────────────────────────────
-- APPROACH: Group by bill_id (bills can span multiple line items).
-- Filter by October 2021 using WHERE on bill_date.
-- Use HAVING to keep only bills whose total exceeds 1000.

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10            -- October
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- ─────────────────────────────────────────────────────────────
-- Q4: Determine the most ordered AND least ordered item
--     of each month of year 2021
-- ─────────────────────────────────────────────────────────────
-- APPROACH:
--   Step 1 – Aggregate total quantity ordered per item per month.
--   Step 2 – Rank items within each month: ASC rank = least, DESC rank = most.
--   Step 3 – Filter for rank = 1 in both directions.

WITH monthly_item_totals AS (
    -- Total quantity per item per month
    SELECT
        MONTH(bc.bill_date)             AS order_month,
        bc.item_id,
        i.item_name,
        SUM(bc.item_quantity)           AS total_qty
    FROM booking_commercials bc
    JOIN items i ON i.item_id = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bc.item_id, i.item_name
),
ranked AS (
    SELECT
        order_month,
        item_name,
        total_qty,
        -- Rank 1 = most ordered for this month
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty DESC) AS rank_most,
        -- Rank 1 = least ordered for this month
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty ASC)  AS rank_least
    FROM monthly_item_totals
)
SELECT
    order_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
GROUP BY order_month
ORDER BY order_month;


-- ─────────────────────────────────────────────────────────────
-- Q5: Find customers with the 2nd highest bill value
--     of each month of year 2021
-- ─────────────────────────────────────────────────────────────
-- APPROACH:
--   Step 1 – Calculate total bill amount per (user, month) pair.
--   Step 2 – Rank users within each month by their total bill (DESC).
--   Step 3 – Keep only rank = 2.

WITH user_monthly_spend AS (
    -- Total amount spent per user per month via booking → commercials → items
    SELECT
        MONTH(bc.bill_date)              AS bill_month,
        b.user_id,
        u.name                           AS customer_name,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON b.booking_id = bc.booking_id
    JOIN users    u ON u.user_id    = b.user_id
    JOIN items    i ON i.item_id    = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, u.name
),
ranked_users AS (
    SELECT
        bill_month,
        customer_name,
        total_bill,
        -- DENSE_RANK ensures we still get rank 2 even if two users tie at rank 1
        DENSE_RANK() OVER (PARTITION BY bill_month ORDER BY total_bill DESC) AS rnk
    FROM user_monthly_spend
)
SELECT
    bill_month,
    customer_name,
    total_bill AS second_highest_bill
FROM ranked_users
WHERE rnk = 2
ORDER BY bill_month;
