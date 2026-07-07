-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 10_data_segmentation.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Segments both products and customers into meaningful
--   business groups. Product segmentation is based on cost,
--   and customer segmentation is based on purchase history
--   and total spending — identifying VIP, Regular, and New
--   customer tiers for targeted business decisions.
-- ============================================================

-- ----------------------------------------
-- Product Segmentation by Cost
-- ----------------------------------------

-- How many products fall into each price tier?
WITH product_cost_segments AS (
    SELECT
        product_key,
        product_name,
        category,
        cost,
        CASE
            WHEN cost = 0           THEN 'Free / No Cost'
            WHEN cost < 100         THEN 'Budget (Under $100)'
            WHEN cost BETWEEN 100 AND 500  THEN 'Mid-Range ($100–$500)'
            WHEN cost BETWEEN 500 AND 1000 THEN 'Premium ($500–$1000)'
            ELSE 'Luxury (Above $1000)'
        END AS price_tier
    FROM gold.dim_products
)
SELECT
    price_tier,
    COUNT(product_key)  AS total_products
FROM product_cost_segments
GROUP BY price_tier
ORDER BY total_products DESC;

-- Category breakdown within each price tier
WITH product_cost_segments AS (
    SELECT
        product_key,
        category,
        cost,
        CASE
            WHEN cost = 0                  THEN 'Free / No Cost'
            WHEN cost < 100                THEN 'Budget (Under $100)'
            WHEN cost BETWEEN 100 AND 500  THEN 'Mid-Range ($100-$500)'
            WHEN cost BETWEEN 500 AND 1000 THEN 'Premium ($500-$1000)'
            ELSE 'Luxury (Above $1000)'
        END AS price_tier
    FROM gold.dim_products
    WHERE category != ''
)
SELECT
    price_tier,
    category,
    COUNT(product_key)  AS total_products
FROM product_cost_segments
GROUP BY price_tier, category
ORDER BY price_tier, total_products DESC;

-- ----------------------------------------
-- Customer Segmentation by Spending Behaviour
-- ----------------------------------------

-- Segment customers into VIP, Regular, or New based on:
--   VIP     : Active for 12+ months AND spent more than $5,000
--   Regular : Active for 12+ months AND spent $5,000 or less
--   New     : Active for less than 12 months
WITH customer_lifetime AS (
    SELECT
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name)   AS customer_name,
        c.country,
        SUM(f.sales_amount)                       AS total_spending,
        COUNT(DISTINCT f.order_number)            AS total_orders,
        MIN(f.order_date)                         AS first_order_date,
        MAX(f.order_date)                         AS last_order_date,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan_months
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name,
        c.country
)
SELECT
    customer_segment,
    COUNT(customer_key)   AS total_customers,
    AVG(total_spending)   AS avg_spending_per_customer,
    AVG(total_orders)     AS avg_orders_per_customer
FROM (
    SELECT
        customer_key,
        total_spending,
        total_orders,
        CASE
            WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_lifetime
) segmented
GROUP BY customer_segment
ORDER BY total_customers DESC;
