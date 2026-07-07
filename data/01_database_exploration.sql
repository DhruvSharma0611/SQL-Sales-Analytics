-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 01_database_exploration.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   First step after setting up the database — understanding
--   what tables exist, what schemas they belong to, and what
--   columns and data types each table contains.
--   This lays the foundation for all analysis that follows.
-- ============================================================

-- ----------------------------------------
-- Step 1: List all tables in the database
-- ----------------------------------------
-- Shows every table across all schemas so we know
-- exactly what we are working with before writing any queries.
SELECT
    TABLE_CATALOG  AS database_name,
    TABLE_SCHEMA   AS schema_name,
    TABLE_NAME     AS table_name,
    TABLE_TYPE     AS table_type
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- ----------------------------------------
-- Step 2: Inspect columns in dim_customers
-- ----------------------------------------
-- Understanding the structure of the customers dimension table:
-- column names, data types, nullability, and string lengths.
SELECT
    COLUMN_NAME             AS column_name,
    DATA_TYPE               AS data_type,
    IS_NULLABLE             AS is_nullable,
    CHARACTER_MAXIMUM_LENGTH AS max_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
ORDER BY ORDINAL_POSITION;

-- ----------------------------------------
-- Step 3: Inspect columns in dim_products
-- ----------------------------------------
SELECT
    COLUMN_NAME             AS column_name,
    DATA_TYPE               AS data_type,
    IS_NULLABLE             AS is_nullable,
    CHARACTER_MAXIMUM_LENGTH AS max_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
ORDER BY ORDINAL_POSITION;

-- ----------------------------------------
-- Step 4: Inspect columns in fact_sales
-- ----------------------------------------
SELECT
    COLUMN_NAME             AS column_name,
    DATA_TYPE               AS data_type,
    IS_NULLABLE             AS is_nullable,
    CHARACTER_MAXIMUM_LENGTH AS max_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
ORDER BY ORDINAL_POSITION;

-- ----------------------------------------
-- Step 5: Quick row count across all tables
-- ----------------------------------------
-- A fast sanity check to confirm data loaded correctly.
SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count FROM gold.dim_customers
UNION ALL
SELECT 'dim_products',                COUNT(*)              FROM gold.dim_products
UNION ALL
SELECT 'fact_sales',                  COUNT(*)              FROM gold.fact_sales;
