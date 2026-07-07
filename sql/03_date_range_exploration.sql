-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 03_date_range_exploration.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Establishes the time boundaries of the dataset.
--   Before doing any trend or time-series analysis, it is
--   important to know exactly how far back the data goes
--   and what the most recent records look like.
-- ============================================================

-- ----------------------------------------
-- Sales Date Range
-- ----------------------------------------

-- What is the full date span covered by our sales data?
SELECT
    MIN(order_date)                                        AS earliest_order,
    MAX(order_date)                                        AS latest_order,
    DATEDIFF(MONTH,  MIN(order_date), MAX(order_date))     AS span_in_months,
    DATEDIFF(YEAR,   MIN(order_date), MAX(order_date))     AS span_in_years
FROM gold.fact_sales
WHERE order_date IS NOT NULL;

-- How many distinct years of sales data do we have?
SELECT DISTINCT
    YEAR(order_date) AS sales_year
FROM gold.fact_sales
WHERE order_date IS NOT NULL
ORDER BY sales_year;

-- ----------------------------------------
-- Shipping & Delivery Timeline
-- ----------------------------------------

-- On average, how many days does it take to ship an order?
SELECT
    AVG(DATEDIFF(DAY, order_date, shipping_date)) AS avg_days_to_ship,
    MIN(DATEDIFF(DAY, order_date, shipping_date)) AS min_days_to_ship,
    MAX(DATEDIFF(DAY, order_date, shipping_date)) AS max_days_to_ship
FROM gold.fact_sales
WHERE order_date IS NOT NULL
  AND shipping_date IS NOT NULL;

-- ----------------------------------------
-- Customer Age Range
-- ----------------------------------------

-- Who is the oldest and youngest customer in the database?
SELECT
    MIN(birthdate)                                      AS oldest_customer_dob,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE())           AS oldest_customer_age,
    MAX(birthdate)                                      AS youngest_customer_dob,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE())           AS youngest_customer_age,
    AVG(DATEDIFF(YEAR, birthdate, GETDATE()))           AS avg_customer_age
FROM gold.dim_customers
WHERE birthdate IS NOT NULL;

-- ----------------------------------------
-- Product Catalog Age
-- ----------------------------------------

-- How old is our oldest product in the catalog?
SELECT
    MIN(start_date)                             AS oldest_product_launch,
    MAX(start_date)                             AS newest_product_launch,
    DATEDIFF(YEAR, MIN(start_date), GETDATE())  AS catalog_age_years
FROM gold.dim_products
WHERE start_date IS NOT NULL;
