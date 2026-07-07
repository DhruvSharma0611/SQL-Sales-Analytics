-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 11_part_to_whole_analysis.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Measures each segment's contribution to the overall total.
--   Useful for understanding which categories, countries, or
--   customer groups are driving the majority of the business.
--   Results can feed directly into pie/donut chart visuals.
-- ============================================================

-- ----------------------------------------
-- Revenue Share by Product Category
-- ----------------------------------------

-- What percentage of total revenue does each category contribute?
WITH rev_by_category AS (
    SELECT
        p.category,
        SUM(f.sales_amount)  AS category_revenue
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    WHERE p.category != ''
    GROUP BY p.category
)
SELECT
    category,
    category_revenue,
    SUM(category_revenue) OVER ()                                                    AS overall_revenue,
    ROUND(CAST(category_revenue AS FLOAT) / SUM(category_revenue) OVER () * 100, 2) AS pct_of_total
FROM rev_by_category
ORDER BY category_revenue DESC;

-- ----------------------------------------
-- Revenue Share by Country
-- ----------------------------------------

-- Which country contributes the most to overall sales?
WITH country_revenue AS (
    SELECT
        c.country,
        SUM(f.sales_amount)  AS country_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
    WHERE c.country != 'n/a'
    GROUP BY c.country
)
SELECT
    country,
    country_sales,
    SUM(country_sales) OVER ()                                               AS total_revenue,
    ROUND(CAST(country_sales AS FLOAT) / SUM(country_sales) OVER () * 100, 2)   AS pct_of_total
FROM country_revenue
ORDER BY country_sales DESC;

-- ----------------------------------------
-- Revenue Share by Product Line
-- ----------------------------------------

-- How does each product line compare to overall revenue?
WITH line_revenue AS (
    SELECT
        p.product_line,
        SUM(f.sales_amount)  AS line_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    WHERE p.product_line IS NOT NULL
    GROUP BY p.product_line
)
SELECT
    product_line,
    line_sales,
    SUM(line_sales) OVER ()                                              AS total_revenue,
    ROUND(CAST(line_sales AS FLOAT) / SUM(line_sales) OVER () * 100, 2) AS pct_of_total
FROM line_revenue
ORDER BY line_sales DESC;

-- ----------------------------------------
-- Order Volume Share by Gender
-- ----------------------------------------

-- Are male or female customers placing more orders?
WITH gender_orders AS (
    SELECT
        c.gender,
        COUNT(DISTINCT f.order_number)  AS total_orders
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
    WHERE c.gender != 'n/a'
    GROUP BY c.gender
)
SELECT
    gender,
    total_orders,
    SUM(total_orders) OVER ()                                                AS overall_orders,
    ROUND(CAST(total_orders AS FLOAT) / SUM(total_orders) OVER () * 100, 2) AS pct_of_total
FROM gender_orders
ORDER BY total_orders DESC;
