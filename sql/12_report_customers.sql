-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 12_report_customers.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Builds a comprehensive customer-level report as a reusable
--   SQL View. Consolidates transaction history, demographics,
--   and behavioural metrics into a single analytical layer.
--
-- Key outputs per customer:
--   - Age and age group
--   - Customer segment (VIP / Regular / New)
--   - Total orders, revenue, quantity, and products purchased
--   - Recency (months since last order)
--   - Average order value and average monthly spend
-- ============================================================

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

-- Step 1: Pull raw transaction + customer data
WITH base_data AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
        c.country,
        c.gender,
        DATEDIFF(YEAR, c.birthdate, GETDATE())      AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

-- Step 2: Aggregate metrics at the customer level
customer_summary AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        country,
        gender,
        age,
        COUNT(DISTINCT order_number)            AS total_orders,
        SUM(sales_amount)                       AS total_revenue,
        SUM(quantity)                           AS total_items_bought,
        COUNT(DISTINCT product_key)             AS unique_products,
        MAX(order_date)                         AS last_order_date,
        MIN(order_date)                         AS first_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
    FROM base_data
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        country,
        gender,
        age
)

-- Step 3: Final report with segments and KPIs
SELECT
    customer_key,
    customer_number,
    customer_name,
    country,
    gender,
    age,

    -- Age group bucket
    CASE
        WHEN age < 20              THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE '50 and above'
    END AS age_group,

    -- Customer tier based on history and spending
    CASE
        WHEN lifespan_months >= 12 AND total_revenue > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_revenue <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    first_order_date,
    last_order_date,
    lifespan_months,

    -- Recency: months since last purchase
    DATEDIFF(MONTH, last_order_date, GETDATE())  AS recency_months,

    total_orders,
    total_revenue,
    total_items_bought,
    unique_products,

    -- Average revenue per order
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_revenue / total_orders
    END AS avg_order_value,

    -- Average monthly spend over the customer's active lifespan
    CASE
        WHEN lifespan_months = 0 THEN total_revenue
        ELSE total_revenue / lifespan_months
    END AS avg_monthly_spend

FROM customer_summary;
GO
