-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 04_measures_exploration.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Calculates the core business KPIs in one place.
--   These high-level numbers give a quick health check
--   of the business before diving into deeper analysis.
-- ============================================================

-- ----------------------------------------
-- Individual KPIs
-- ----------------------------------------

-- Total revenue generated across all orders
SELECT SUM(sales_amount) AS total_revenue
FROM gold.fact_sales;

-- Total number of items sold
SELECT SUM(quantity) AS total_items_sold
FROM gold.fact_sales;

-- Average price per item sold
SELECT AVG(price) AS avg_item_price
FROM gold.fact_sales;

-- Total number of transactions (including duplicate order numbers)
SELECT COUNT(order_number) AS total_transactions
FROM gold.fact_sales;

-- Total number of unique orders placed
SELECT COUNT(DISTINCT order_number) AS total_unique_orders
FROM gold.fact_sales;

-- Total products in the catalog
SELECT COUNT(DISTINCT product_name) AS total_products
FROM gold.dim_products;

-- Total registered customers
SELECT COUNT(customer_key) AS total_registered_customers
FROM gold.dim_customers;

-- Total customers who have actually placed at least one order
SELECT COUNT(DISTINCT customer_key) AS total_active_customers
FROM gold.fact_sales;

-- Average order value (total revenue / unique orders)
SELECT
    SUM(sales_amount) / COUNT(DISTINCT order_number) AS avg_order_value
FROM gold.fact_sales;

-- ----------------------------------------
-- Combined KPI Summary Report
-- ----------------------------------------
-- All key metrics in a single result set — useful for
-- dashboards or executive summaries.
SELECT 'Total Revenue'          AS kpi, SUM(sales_amount)                              AS value FROM gold.fact_sales
UNION ALL
SELECT 'Total Items Sold',               SUM(quantity)                                          FROM gold.fact_sales
UNION ALL
SELECT 'Avg Item Price',                 AVG(price)                                             FROM gold.fact_sales
UNION ALL
SELECT 'Total Unique Orders',            COUNT(DISTINCT order_number)                           FROM gold.fact_sales
UNION ALL
SELECT 'Total Products',                 COUNT(DISTINCT product_name)                           FROM gold.dim_products
UNION ALL
SELECT 'Total Customers',                COUNT(customer_key)                                    FROM gold.dim_customers
UNION ALL
SELECT 'Active Customers',               COUNT(DISTINCT customer_key)                           FROM gold.fact_sales
UNION ALL
SELECT 'Avg Order Value',                SUM(sales_amount) / COUNT(DISTINCT order_number)       FROM gold.fact_sales;
