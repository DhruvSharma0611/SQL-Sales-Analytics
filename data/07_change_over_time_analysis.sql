-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 07_change_over_time_analysis.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Tracks how key sales metrics evolve over time.
--   Looks at trends by year, by month, and by year-month
--   combination to identify seasonality and growth patterns.
--   Three different date-grouping techniques are demonstrated.
-- ============================================================

-- ----------------------------------------
-- Yearly Trend
-- ----------------------------------------

-- How did total revenue, customers, and quantity change year by year?
SELECT
    YEAR(order_date)                 AS order_year,
    SUM(sales_amount)                AS total_revenue,
    COUNT(DISTINCT customer_key)     AS unique_customers,
    SUM(quantity)                    AS total_items_sold,
    COUNT(DISTINCT order_number)     AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- ----------------------------------------
-- Monthly Trend (Year + Month breakdown)
-- ----------------------------------------

-- Granular month-by-month view to spot seasonal patterns
SELECT
    YEAR(order_date)                 AS order_year,
    MONTH(order_date)                AS order_month,
    SUM(sales_amount)                AS total_revenue,
    COUNT(DISTINCT customer_key)     AS unique_customers,
    SUM(quantity)                    AS total_items_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- ----------------------------------------
-- Using DATETRUNC for clean date grouping
-- ----------------------------------------

-- Groups by the first day of each month — clean for charts
SELECT
    DATETRUNC(month, order_date)     AS month_start,
    SUM(sales_amount)                AS total_revenue,
    COUNT(DISTINCT customer_key)     AS unique_customers,
    SUM(quantity)                    AS total_items_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY month_start;

-- ----------------------------------------
-- Using FORMAT for readable date labels
-- ----------------------------------------

-- Returns labels like '2013-Jan' — great for displaying in reports
SELECT
    FORMAT(order_date, 'yyyy-MMM')   AS month_label,
    SUM(sales_amount)                AS total_revenue,
    COUNT(DISTINCT customer_key)     AS unique_customers,
    SUM(quantity)                    AS total_items_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY MIN(order_date);

-- ----------------------------------------
-- Quarter-level trend
-- ----------------------------------------

-- Revenue grouped by quarter — useful for quarterly business reviews
SELECT
    YEAR(order_date)                                AS order_year,
    DATEPART(QUARTER, order_date)                   AS order_quarter,
    SUM(sales_amount)                               AS total_revenue,
    COUNT(DISTINCT order_number)                    AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date)
ORDER BY order_year, order_quarter;
