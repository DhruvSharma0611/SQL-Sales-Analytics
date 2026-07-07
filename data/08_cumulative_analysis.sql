-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 08_cumulative_analysis.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Calculates running totals and moving averages to show
--   how the business is accumulating over time.
--   Running totals reveal whether growth is consistent or
--   whether it came in sudden spikes.
-- ============================================================

-- ----------------------------------------
-- Running Total by Year
-- ----------------------------------------

-- Year-by-year sales with a running cumulative total alongside it
-- Makes it easy to see total business volume built up over time
SELECT
    order_year,
    yearly_revenue,
    SUM(yearly_revenue) OVER (ORDER BY order_year)   AS running_total_revenue,
    AVG(avg_price)      OVER (ORDER BY order_year)   AS moving_avg_price
FROM (
    SELECT
        DATETRUNC(year, order_date)   AS order_year,
        SUM(sales_amount)             AS yearly_revenue,
        AVG(price)                    AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) yearly_summary
ORDER BY order_year;

-- ----------------------------------------
-- Running Total by Month
-- ----------------------------------------

-- More granular monthly running total
-- Helpful for tracking progress toward annual revenue targets
SELECT
    order_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY order_month)  AS running_total_revenue,
    AVG(avg_price)       OVER (ORDER BY order_month)  AS moving_avg_price,
    SUM(monthly_orders)  OVER (ORDER BY order_month)  AS running_total_orders
FROM (
    SELECT
        DATETRUNC(month, order_date)          AS order_month,
        SUM(sales_amount)                     AS monthly_revenue,
        AVG(price)                            AS avg_price,
        COUNT(DISTINCT order_number)          AS monthly_orders
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) monthly_summary
ORDER BY order_month;

-- ----------------------------------------
-- Running Total by Customer Count
-- ----------------------------------------

-- How has the unique customer base accumulated over time?
SELECT
    order_year,
    new_customers_that_year,
    SUM(new_customers_that_year) OVER (ORDER BY order_year) AS cumulative_customers
FROM (
    SELECT
        YEAR(MIN(order_date))          AS order_year,
        COUNT(DISTINCT customer_key)   AS new_customers_that_year
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY customer_key
) first_orders
GROUP BY order_year, new_customers_that_year
ORDER BY order_year;
