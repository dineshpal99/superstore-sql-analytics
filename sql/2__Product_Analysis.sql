-- ============================================================
-- FILE: 2. Product Analysis.sql
-- PROJECT: Retail Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: Product performance, Pareto
-- ============================================================

-- ============================================================
 --  ** PRODUCT ANALYSIS
-- ============================================================

-- Q1. Top 10 most profitable products
SELECT TOP 10
    Product_Name,
    Sub_Category,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                AS margin_pct,
    COUNT(DISTINCT Order_ID)                    AS times_ordered,
    DENSE_RANK() OVER (ORDER BY SUM(Profit) DESC)
                                                AS profit_rank
FROM dbo.retail_sales
GROUP BY Product_Name, Sub_Category
ORDER BY profit DESC;
GO

-- Q2. Bottom 10 products destroying profit
SELECT TOP 10
    Product_Name,
    Sub_Category,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(AVG(Discount) * 100, 2)               AS avg_discount_pct,
    COUNT(DISTINCT Order_ID)                    AS times_ordered
FROM dbo.retail_sales
GROUP BY Product_Name, Sub_Category
ORDER BY profit ASC;
GO

-- Q3. Pareto — what % of products generate 80% of profit?
WITH product_profit AS (
    SELECT
        Product_ID,
        SUM(Profit)                             AS total_profit
    FROM dbo.retail_sales
    WHERE Profit > 0
    GROUP BY Product_ID
),
ranked AS (
    SELECT *,
        SUM(total_profit) OVER (
            ORDER BY total_profit DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 / SUM(total_profit) OVER ()   AS cumulative_pct,
        COUNT(*) OVER ()                        AS total_products
    FROM product_profit
)
SELECT
    COUNT(*)                                    AS products_for_80pct_profit,
    MAX(total_products)                         AS total_profitable_products,
    ROUND(COUNT(*) * 100.0 /
        MAX(total_products), 1)                 AS pct_of_products
FROM ranked
WHERE cumulative_pct <= 80;
GO