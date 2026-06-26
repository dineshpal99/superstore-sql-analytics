-- ============================================================
-- FILE: 00_setup.sql
-- PROJECT: Retail Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: Create table schema. Understand data health, nulls, and anomalies.
-- ============================================================

-- Step 1: Drop existing table if it exists
IF OBJECT_ID('dbo.retail_sales', 'U') IS NOT NULL
    DROP TABLE dbo.retail_sales;
GO

-- Step 2: Create table
CREATE TABLE dbo.retail_sales (
    Row_ID          INT,
    Order_ID        VARCHAR(25),
    Order_Date      DATE,
    Ship_Date       DATE,
    Ship_Mode       VARCHAR(30),
    Customer_ID     VARCHAR(20),
    Segment         VARCHAR(30),
    Country         VARCHAR(50),
    City            VARCHAR(100),
    State           VARCHAR(50),
    Region          VARCHAR(20),
    Product_ID      VARCHAR(20),
    Category        VARCHAR(30),
    Sub_Category    VARCHAR(30),
    Product_Name    VARCHAR(255),
    Sales           DECIMAL(10,4),
    Quantity        INT,
    Discount        DECIMAL(5,4),
    Profit          DECIMAL(10,4)
);
GO

-- Step 3: Load data
BULK INSERT dbo.retail_sales
FROM 'C:\Users\dines\OneDrive\Desktop\Interview Stuff\Final Files\github-sql-FINAL\clean_retail_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO

-- Step 4: Verify load
SELECT
    COUNT(*)                               AS total_rows,
    COUNT(DISTINCT Order_ID)               AS unique_orders,
    COUNT(DISTINCT Customer_ID)            AS unique_customers,
    COUNT(DISTINCT Product_ID)             AS unique_products,
    MIN(Order_Date)                        AS earliest_order,
    MAX(Order_Date)                        AS latest_order,
    ROUND(SUM(Sales), 2)                   AS total_revenue,
    ROUND(SUM(Profit), 2)                  AS total_profit
FROM dbo.retail_sales;
GO

-- ============= Data Quality Audit ===============================================

-- Section 1: Row counts and basic checks
SELECT 'Total rows'                                 AS check_name,
    COUNT(*)                                        AS value,
    'All order lines'                               AS notes
FROM dbo.retail_sales
UNION ALL
SELECT 'Null Customer_ID',
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END),
    'Cannot be used for customer analysis'
FROM dbo.retail_sales
UNION ALL
SELECT 'Null Product_Name',
    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END),
    'May affect product analysis'
FROM dbo.retail_sales
UNION ALL
SELECT 'Negative profit rows (real losses)',
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END),
    'Not errors -- loss-making orders'
FROM dbo.retail_sales
UNION ALL
SELECT 'Zero or negative sales',
    SUM(CASE WHEN Sales <= 0 THEN 1 ELSE 0 END),
    'Should be zero'
FROM dbo.retail_sales
UNION ALL
SELECT 'Discount out of range (>0.8)',
    SUM(CASE WHEN Discount > 0.8 THEN 1 ELSE 0 END),
    'Max expected discount is 80%'
FROM dbo.retail_sales
UNION ALL
SELECT 'Ship date before order date',
    SUM(CASE WHEN Ship_Date < Order_Date THEN 1 ELSE 0 END),
    'Should be zero -- data error if not'
FROM dbo.retail_sales
UNION ALL
SELECT 'Duplicate Row_IDs',
    COUNT(*) - COUNT(DISTINCT Row_ID),
    'Should be zero'
FROM dbo.retail_sales;
GO

-- Section 2: Min/max sanity check on numeric columns
SELECT
    MIN(Sales)          AS min_sales,
    MAX(Sales)          AS max_sales,
    MIN(Profit)         AS min_profit,
    MAX(Profit)         AS max_profit,
    MIN(Discount)       AS min_discount,
    MAX(Discount)       AS max_discount,
    MIN(Quantity)       AS min_quantity,
    MAX(Quantity)       AS max_quantity,
    MIN(Order_Date)     AS min_order_date,
    MAX(Order_Date)     AS max_order_date
FROM dbo.retail_sales;
GO

-- Section 3: Row count by year (checks data completeness)
SELECT
    YEAR(Order_Date)    AS [year],
    COUNT(*)            AS row_count,
    COUNT(DISTINCT Order_ID) AS unique_orders
FROM dbo.retail_sales
GROUP BY YEAR(Order_Date)
ORDER BY [year];
GO

-- Section 4: Top 10 states by row count (orientation check)
SELECT TOP 10
    State,
    Region,
    COUNT(*)            AS row_count,
    COUNT(DISTINCT Customer_ID) AS unique_customers
FROM dbo.retail_sales
GROUP BY State, Region
ORDER BY row_count DESC;
GO
