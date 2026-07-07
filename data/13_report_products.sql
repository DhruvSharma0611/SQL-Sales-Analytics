-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 13_report_products.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Builds a comprehensive product-level report as a reusable
--   SQL View. Aggregates sales history per product and
--   classifies each into performance tiers.
--
-- Key outputs per product:
--   - Category, subcategory, and cost
--   - Performance tier (High-Performer / Mid-Range / Low-Performer)
--   - Total orders, revenue, quantity, and unique customers
--   - Recency (months since last sale)
--   - Average order revenue and average monthly revenue
-- ============================================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

-- Step 1: Pull raw sales data joined with product info
WITH base_data AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

-- Step 2: Aggregate at the product level
product_summary AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        MIN(order_date)                                                AS first_sale_date,
        MAX(order_date)                                                AS last_sale_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date))              AS lifespan_months,
        COUNT(DISTINCT order_number)                                   AS total_orders,
        COUNT(DISTINCT customer_key)                                   AS unique_customers,
        SUM(sales_amount)                                              AS total_revenue,
        SUM(quantity)                                                  AS total_items_sold,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_unit_price
    FROM base_data
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- Step 3: Final report with performance tiers and KPIs
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    first_sale_date,
    last_sale_date,
    lifespan_months,

    -- Months since this product last had a sale
    DATEDIFF(MONTH, last_sale_date, GETDATE())   AS recency_months,

    -- Performance classification based on total revenue
    CASE
        WHEN total_revenue > 50000  THEN 'High-Performer'
        WHEN total_revenue >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS performance_tier,

    total_orders,
    unique_customers,
    total_revenue,
    total_items_sold,
    avg_unit_price,

    -- Average revenue generated per order
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_revenue / total_orders
    END AS avg_order_revenue,

    -- Average monthly revenue over the product's active lifespan
    CASE
        WHEN lifespan_months = 0 THEN total_revenue
        ELSE total_revenue / lifespan_months
    END AS avg_monthly_revenue

FROM product_summary;
GO
