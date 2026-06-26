-- ============================================================
-- FILE: 3. Regional Analysis.sql
-- PROJECT: Retail Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: Regional breakdown
-- NOTE: No Postal Code in this dataset — geography uses
--       City and State columns only
-- ============================================================

-- ============================================================
-- ** REGIONAL ANALYSIS
-- ============================================================

-- Q1. Revenue and profit by region
SELECT
    Region,
    COUNT(DISTINCT Customer_ID)                 AS customers,
    COUNT(DISTINCT Order_ID)                    AS orders,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                AS margin_pct,
    ROUND(SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER (), 1)             AS revenue_share_pct,
    RANK() OVER (ORDER BY SUM(Profit) DESC)     AS profit_rank
FROM dbo.retail_sales
GROUP BY Region
ORDER BY profit DESC;
GO

-- Q2. Top 10 states by revenue with profit margin
SELECT TOP 10
    State,
    Region,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                AS margin_pct,
    COUNT(DISTINCT Order_ID)                    AS orders,
    RANK() OVER (ORDER BY SUM(Sales) DESC)      AS revenue_rank
FROM dbo.retail_sales
GROUP BY State, Region
ORDER BY revenue DESC;
GO

-- Q3. States with NEGATIVE profit (problem markets)
SELECT
    State,
    Region,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(AVG(Discount) * 100, 2)               AS avg_discount_pct,
    COUNT(DISTINCT Order_ID)                    AS orders
FROM dbo.retail_sales
GROUP BY State, Region
HAVING SUM(Profit) < 0
ORDER BY profit ASC;
GO

-- Q4. Category performance by region (CASE WHEN pivot)
SELECT
    Region,
    ROUND(SUM(CASE WHEN Category = 'Technology'
        THEN Sales ELSE 0 END), 2)              AS technology_revenue,
    ROUND(SUM(CASE WHEN Category = 'Furniture'
        THEN Sales ELSE 0 END), 2)              AS furniture_revenue,
    ROUND(SUM(CASE WHEN Category = 'Office Supplies'
        THEN Sales ELSE 0 END), 2)              AS office_supplies_revenue,
    ROUND(SUM(CASE WHEN Category = 'Technology'
        THEN Profit ELSE 0 END), 2)             AS technology_profit,
    ROUND(SUM(CASE WHEN Category = 'Furniture'
        THEN Profit ELSE 0 END), 2)             AS furniture_profit,
    ROUND(SUM(CASE WHEN Category = 'Office Supplies'
        THEN Profit ELSE 0 END), 2)             AS office_supplies_profit
FROM dbo.retail_sales
GROUP BY Region
ORDER BY Region;
GO

-- Q5. Native T-SQL PIVOT — same result as Q4, different syntax
SELECT
    Region,
    [Technology]        AS technology_revenue,
    [Furniture]         AS furniture_revenue,
    [Office Supplies]   AS office_supplies_revenue
FROM (
    SELECT Region, Category, Sales
    FROM dbo.retail_sales
) AS src
PIVOT (
    SUM(Sales)
    FOR Category IN ([Technology], [Furniture], [Office Supplies])
) AS pvt
ORDER BY Region;
GO
