-- ============================================================
-- Project  : Sales Data Warehouse Analytics
-- Script   : 00_init_database.sql
-- Author   : Dhruv Sharma
-- LinkedIn : https://www.linkedin.com/in/dhruv-sharma-006939289/
-- GitHub   : https://github.com/DhruvSharma0611
-- ============================================================
-- Description:
--   Sets up the DataWarehouseAnalytics database from scratch.
--   Drops and recreates the DB if it already exists, creates
--   the 'gold' schema, defines all three tables, and loads
--   data from local CSV files using BULK INSERT.
--
-- WARNING:
--   Running this script will permanently delete any existing
--   DataWarehouseAnalytics database. Make sure you have a
--   backup before proceeding.
--
-- NOTE:
--   Update the three file paths in the BULK INSERT blocks
--   below to match the location of your CSV files.
-- ============================================================

USE master;
GO

-- Drop existing database if it exists and start fresh
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
    PRINT 'Existing DataWarehouseAnalytics database dropped.';
END;
GO

CREATE DATABASE DataWarehouseAnalytics;
PRINT 'DataWarehouseAnalytics database created successfully.';
GO

USE DataWarehouseAnalytics;
GO

-- Create gold schema to hold all business-ready tables
CREATE SCHEMA gold;
GO
PRINT 'Schema [gold] created.';
GO

-- ============================================================
-- Table: gold.dim_customers
-- Stores customer demographic and profile information
-- ============================================================
CREATE TABLE gold.dim_customers (
    customer_key      INT,
    customer_id       INT,
    customer_number   NVARCHAR(50),
    first_name        NVARCHAR(50),
    last_name         NVARCHAR(50),
    country           NVARCHAR(50),
    marital_status    NVARCHAR(50),
    gender            NVARCHAR(50),
    birthdate         DATE,
    create_date       DATE
);
GO

-- ============================================================
-- Table: gold.dim_products
-- Stores product catalog with categories and pricing
-- ============================================================
CREATE TABLE gold.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  NVARCHAR(50),
    product_name    NVARCHAR(50),
    category_id     NVARCHAR(50),
    category        NVARCHAR(50),
    subcategory     NVARCHAR(50),
    maintenance     NVARCHAR(50),
    cost            INT,
    product_line    NVARCHAR(50),
    start_date      DATE
);
GO

-- ============================================================
-- Table: gold.fact_sales
-- Central fact table capturing all sales transactions
-- ============================================================
CREATE TABLE gold.fact_sales (
    order_number    NVARCHAR(50),
    product_key     INT,
    customer_key    INT,
    order_date      DATE,
    shipping_date   DATE,
    due_date        DATE,
    sales_amount    INT,
    quantity        TINYINT,
    price           INT
);
GO

PRINT 'All three tables created successfully.';
GO

-- ============================================================
-- Load Data: gold.dim_customers
-- UPDATE the path below to match your local CSV location
-- ============================================================
TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\sql\datasets\csv-files\gold.dim_customers.csv'
WITH (
    FIRSTROW       = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
PRINT 'Data loaded into gold.dim_customers.';
GO

-- ============================================================
-- Load Data: gold.dim_products
-- ============================================================
TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\sql\datasets\csv-files\gold.dim_products.csv'
WITH (
    FIRSTROW       = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
PRINT 'Data loaded into gold.dim_products.';
GO

-- ============================================================
-- Load Data: gold.fact_sales
-- ============================================================
TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\sql\datasets\csv-files\gold.fact_sales.csv'
WITH (
    FIRSTROW       = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
PRINT 'Data loaded into gold.fact_sales.';
GO

PRINT '============================================================';
PRINT 'Database setup complete. All tables created and data loaded.';
PRINT '============================================================';
