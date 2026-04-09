-- ============================================================
-- FILE: 04_Clinic_Queries.sql
-- PURPOSE: Answer all 5 questions for the Clinic Management System
-- Replace @target_year / @target_month with actual values when running
-- ============================================================

-- Set target year and month (change as needed)
SET @target_year  = 2021;
SET @target_month = 10;   -- used for Q4 and Q5


-- ─────────────────────────────────────────────────────────────
-- Q1: Find the revenue we got from each sales channel
--     in a given year
-- ─────────────────────────────────────────────────────────────
SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = @target_year
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────────────────────────
-- Q2: Find the top 10 most valuable customers for a given year
-- ─────────────────────────────────────────────────────────────
-- "Most valuable" = highest total spend
SELECT
    cs.uid,
    c.name            AS customer_name,
    SUM(cs.amount)    AS total_spend
FROM clinic_sales cs
JOIN customer c ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = @target_year
GROUP BY cs.uid, c.name
ORDER BY total_spend DESC
LIMIT 10;


-- ─────────────────────────────────────────────────────────────
-- Q3: Month-wise revenue, expense, profit and
--     status (Profitable / Not-Profitable) for a given year
-- ─────────────────────────────────────────────────────────────
-- APPROACH:
--   Aggregate revenue per month from clinic_sales.
--   Aggregate expense per month from expenses.
--   LEFT JOIN so months with revenue but no expense (and vice versa)
--   are still included.

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @target_year
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS expense
    FROM expenses
    WHERE YEAR(datetime) = @target_year
    GROUP BY MONTH(datetime)
)
SELECT
    COALESCE(r.month_num, e.month_num)          AS month_num,
    COALESCE(r.revenue, 0)                       AS revenue,
    COALESCE(e.expense, 0)                       AS expense,
    COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) >= 0
             THEN 'Profitable'
        ELSE 'Not-Profitable'
    END                                          AS status
FROM monthly_revenue  r
FULL OUTER JOIN monthly_expense e ON e.month_num = r.month_num
-- Note: MySQL does not support FULL OUTER JOIN natively.
-- For MySQL, replace the FULL OUTER JOIN block above with:
--
--   FROM monthly_revenue r
--   LEFT  JOIN monthly_expense e ON e.month_num = r.month_num
--   UNION
--   SELECT e.month_num,
--          COALESCE(r.revenue,0), COALESCE(e.expense,0),
--          COALESCE(r.revenue,0)-COALESCE(e.expense,0),
--          CASE WHEN COALESCE(r.revenue,0)-COALESCE(e.expense,0)>=0
--               THEN 'Profitable' ELSE 'Not-Profitable' END
--   FROM monthly_expense e
--   LEFT  JOIN monthly_revenue r ON r.month_num = e.month_num
--
ORDER BY month_num;


-- ─────────────────────────────────────────────────────────────
-- Q4: For each city, find the most profitable clinic
--     for a given month
-- ─────────────────────────────────────────────────────────────
WITH clinic_rev AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @target_year AND MONTH(datetime) = @target_month
    GROUP BY cid
),
clinic_exp AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = @target_year AND MONTH(datetime) = @target_month
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(r.revenue, 0)  AS revenue,
        COALESCE(e.expense, 0)  AS expense,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_rev r ON r.cid = cl.cid
    LEFT JOIN clinic_exp e ON e.cid = cl.cid
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT
    city,
    clinic_name       AS most_profitable_clinic,
    profit
FROM ranked
WHERE rnk = 1
ORDER BY city;


-- ─────────────────────────────────────────────────────────────
-- Q5: For each state, find the 2nd least profitable clinic
--     for a given month
-- ─────────────────────────────────────────────────────────────
WITH clinic_rev AS (
    SELECT cid, SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @target_year AND MONTH(datetime) = @target_month
    GROUP BY cid
),
clinic_exp AS (
    SELECT cid, SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = @target_year AND MONTH(datetime) = @target_month
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.state,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_rev r ON r.cid = cl.cid
    LEFT JOIN clinic_exp e ON e.cid = cl.cid
),
ranked AS (
    SELECT
        *,
        -- ASC rank: rank 1 = least profitable, rank 2 = 2nd least
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT
    state,
    clinic_name   AS second_least_profitable_clinic,
    profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
