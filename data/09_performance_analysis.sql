-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 09_performance_analysis.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Measures year-over-year performance for products and
--   compares each year's sales against the product's own
--   historical average. Helps identify products that are
--   growing, declining, or staying flat over time.
-- ============================================================

-- ----------------------------------------
-- Year-over-Year Product Performance
-- ----------------------------------------

-- For each product and year:
--   1. Shows sales for current year
--   2. Compares against the product's all-time average
--   3. Compares against the previous year (YoY change)
WITH product_sales_by_year AS (
    SELECT
        YEAR(f.order_date)   AS order_year,
        p.product_name,
        p.category,
        SUM(f.sales_amount)  AS current_year_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name,
        p.category
)
SELECT
    order_year,
    product_name,
    category,
    current_year_sales,

    -- Benchmark: average sales across all years for this product
    AVG(current_year_sales) OVER (PARTITION BY product_name)   AS avg_annual_sales,

    -- Difference from average
    current_year_sales
        - AVG(current_year_sales) OVER (PARTITION BY product_name)  AS diff_from_avg,

    -- Flag whether this year is above or below the product's average
    CASE
        WHEN current_year_sales > AVG(current_year_sales) OVER (PARTITION BY product_name) THEN 'Above Average'
        WHEN current_year_sales < AVG(current_year_sales) OVER (PARTITION BY product_name) THEN 'Below Average'
        ELSE 'At Average'
    END AS vs_avg_flag,

    -- Previous year's sales using LAG
    LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY order_year)  AS prev_year_sales,

    -- Year-over-year change in absolute terms
    current_year_sales
        - LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY order_year)  AS yoy_change,

    -- Direction of year-over-year movement
    CASE
        WHEN current_year_sales > LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY order_year) THEN 'Growth'
        WHEN current_year_sales < LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY order_year) THEN 'Decline'
        ELSE 'No Change'
    END AS yoy_trend

FROM product_sales_by_year
ORDER BY product_name, order_year;

-- ----------------------------------------
-- Category-level Year-over-Year Performance
-- ----------------------------------------

-- Same concept aggregated at category level for a higher-level view
WITH category_sales_by_year AS (
    SELECT
        YEAR(f.order_date)   AS order_year,
        p.category,
        SUM(f.sales_amount)  AS current_year_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
      AND p.category != ''
    GROUP BY YEAR(f.order_date), p.category
)
SELECT
    order_year,
    category,
    current_year_sales,
    LAG(current_year_sales) OVER (PARTITION BY category ORDER BY order_year)  AS prev_year_sales,
    current_year_sales
        - LAG(current_year_sales) OVER (PARTITION BY category ORDER BY order_year)  AS yoy_change,
    CASE
        WHEN current_year_sales > LAG(current_year_sales) OVER (PARTITION BY category ORDER BY order_year) THEN 'Growth'
        WHEN current_year_sales < LAG(current_year_sales) OVER (PARTITION BY category ORDER BY order_year) THEN 'Decline'
        ELSE 'No Change'
    END AS yoy_trend
FROM category_sales_by_year
ORDER BY category, order_year;
