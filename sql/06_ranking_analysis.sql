-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 06_ranking_analysis.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Ranks products and customers by various performance
--   metrics to identify top performers and underperformers.
--   Uses both simple TOP N filtering and flexible window
--   functions for more advanced ranking scenarios.
-- ============================================================

-- ----------------------------------------
-- Product Rankings
-- ----------------------------------------

-- Top 5 revenue-generating products (simple approach)
SELECT TOP 5
    p.product_name,
    p.category,
    SUM(f.sales_amount)  AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;

-- Top 5 products using RANK() window function
-- More flexible — easy to change the cutoff without rewriting the query
SELECT
    product_name,
    category,
    total_revenue,
    revenue_rank
FROM (
    SELECT
        p.product_name,
        p.category,
        SUM(f.sales_amount)                              AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC)  AS revenue_rank
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    GROUP BY p.product_name, p.category
) ranked
WHERE revenue_rank <= 5;

-- Top 5 products ranked within each category
-- Shows the best seller in every category, not just overall
SELECT
    product_name,
    category,
    total_revenue,
    rank_in_category
FROM (
    SELECT
        p.product_name,
        p.category,
        SUM(f.sales_amount)                                                       AS total_revenue,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(f.sales_amount) DESC)   AS rank_in_category
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    WHERE p.category != ''
    GROUP BY p.product_name, p.category
) ranked
WHERE rank_in_category <= 5
ORDER BY category, rank_in_category;

-- Bottom 5 worst-performing products by revenue
SELECT TOP 5
    p.product_name,
    p.category,
    SUM(f.sales_amount)  AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.product_name, p.category
ORDER BY total_revenue ASC;

-- ----------------------------------------
-- Customer Rankings
-- ----------------------------------------

-- Top 10 highest-spending customers
SELECT TOP 10
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
    c.country,
    SUM(f.sales_amount)                      AS total_revenue,
    COUNT(DISTINCT f.order_number)           AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country
ORDER BY total_revenue DESC;

-- Bottom 3 customers with fewest orders placed
SELECT TOP 3
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
    c.country,
    COUNT(DISTINCT f.order_number)           AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country
ORDER BY total_orders ASC;
