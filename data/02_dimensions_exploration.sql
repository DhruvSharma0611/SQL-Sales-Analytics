-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 02_dimensions_exploration.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Explores the dimension tables to understand the unique
--   values available for slicing and filtering data.
--   Covers customer geography, product hierarchy, and
--   other categorical breakdowns.
-- ============================================================

-- ----------------------------------------
-- Customer Dimensions
-- ----------------------------------------

-- Which countries do our customers come from?
SELECT DISTINCT
    country
FROM gold.dim_customers
WHERE country != 'n/a'
ORDER BY country;

-- What genders are recorded in the customer data?
SELECT DISTINCT
    gender
FROM gold.dim_customers
ORDER BY gender;

-- What marital statuses exist?
SELECT DISTINCT
    marital_status
FROM gold.dim_customers
ORDER BY marital_status;

-- ----------------------------------------
-- Product Dimensions
-- ----------------------------------------

-- Full product hierarchy: category > subcategory > product name
-- Useful for building drill-down reports
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
WHERE category IS NOT NULL
  AND category != ''
ORDER BY category, subcategory, product_name;

-- What top-level product categories exist?
SELECT DISTINCT
    category
FROM gold.dim_products
WHERE category != ''
ORDER BY category;

-- What product lines are available?
SELECT DISTINCT
    product_line
FROM gold.dim_products
WHERE product_line IS NOT NULL
ORDER BY product_line;

-- Which products require maintenance?
SELECT DISTINCT
    maintenance,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY maintenance
ORDER BY total_products DESC;
