-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 05_magnitude_analysis.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Groups and aggregates data across key business dimensions
--   to understand how sales and customers are distributed.
--   Answers questions like: which country has the most customers,
--   which category drives the most revenue, and so on.
-- ============================================================

-- ----------------------------------------
-- Customer Distribution
-- ----------------------------------------

-- How many customers do we have per country?
SELECT
    country,
    COUNT(customer_key)  AS total_customers
FROM gold.dim_customers
WHERE country != 'n/a'
GROUP BY country
ORDER BY total_customers DESC;

-- Customer split by gender
SELECT
    gender,
    COUNT(customer_key)  AS total_customers
FROM gold.dim_customers
WHERE gender != 'n/a'
GROUP BY gender
ORDER BY total_customers DESC;

-- Customer split by marital status
SELECT
    marital_status,
    COUNT(customer_key)  AS total_customers
FROM gold.dim_customers
GROUP BY marital_status
ORDER BY total_customers DESC;

-- ----------------------------------------
-- Product Distribution
-- ----------------------------------------

-- How many products fall under each category?
SELECT
    category,
    COUNT(product_key)  AS total_products
FROM gold.dim_products
WHERE category != ''
GROUP BY category
ORDER BY total_products DESC;

-- What is the average product cost per category?
SELECT
    category,
    AVG(cost)  AS avg_cost,
    MIN(cost)  AS min_cost,
    MAX(cost)  AS max_cost
FROM gold.dim_products
WHERE category != ''
GROUP BY category
ORDER BY avg_cost DESC;

-- ----------------------------------------
-- Revenue Distribution
-- ----------------------------------------

-- Total revenue broken down by product category
SELECT
    p.category,
    SUM(f.sales_amount)  AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE p.category != ''
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Total revenue broken down by product subcategory
SELECT
    p.subcategory,
    SUM(f.sales_amount)  AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;

-- Total revenue generated per country
SELECT
    c.country,
    SUM(f.sales_amount)  AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country
ORDER BY total_revenue DESC;

-- Total items sold per country
SELECT
    c.country,
    SUM(f.quantity)  AS total_items_sold
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country
ORDER BY total_items_sold DESC;

-- Revenue generated per individual customer (top spenders)
SELECT
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
    c.country,
    SUM(f.sales_amount)                      AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country
ORDER BY total_revenue DESC;
