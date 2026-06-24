-- ============================================================
-- FILE: 01_overview.sql
-- PROJECT: Superstore Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: Overall KPIs — Revenue, Profit, Margin, Orders
-- ============================================================

-- Q1. Executive KPI Summary
SELECT
    COUNT(DISTINCT Order_ID)                        AS total_orders,
    COUNT(DISTINCT Customer_ID)                     AS unique_customers,
    COUNT(DISTINCT Product_ID)                      AS unique_products,
    ROUND(SUM(Sales), 2)                            AS total_revenue,
    ROUND(SUM(Profit), 2)                           AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                    AS profit_margin_pct,
    ROUND(SUM(Sales) / NULLIF(COUNT(DISTINCT Order_ID), 0), 2)
                                                    AS avg_order_value,
    SUM(Quantity)                                   AS total_units_sold
FROM dbo.superstore;
GO

-- Q2. Performance by Category
SELECT
    Category,
    COUNT(DISTINCT Order_ID)                        AS orders,
    ROUND(SUM(Sales), 2)                            AS revenue,
    ROUND(SUM(Profit), 2)                           AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                    AS profit_margin_pct,
    ROUND(SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER (), 2)                 AS revenue_share_pct,
    ROUND(AVG(Discount) * 100, 2)                   AS avg_discount_pct
FROM dbo.superstore
GROUP BY Category
ORDER BY revenue DESC;
GO

-- Q3. Performance by Segment
SELECT
    Segment,
    COUNT(DISTINCT Customer_ID)                     AS customers,
    COUNT(DISTINCT Order_ID)                        AS orders,
    ROUND(SUM(Sales), 2)                            AS revenue,
    ROUND(SUM(Profit), 2)                           AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                    AS margin_pct,
    ROUND(SUM(Sales) / NULLIF(COUNT(DISTINCT Customer_ID), 0), 2)
                                                    AS revenue_per_customer,
    ROUND(SUM(Sales) / NULLIF(COUNT(DISTINCT Order_ID), 0), 2)
                                                    AS avg_order_value
FROM dbo.superstore
GROUP BY Segment
ORDER BY revenue DESC;
GO

-- Q4. Yearly Performance Summary
SELECT
    YEAR(Order_Date)                                AS [year],
    COUNT(DISTINCT Order_ID)                        AS orders,
    COUNT(DISTINCT Customer_ID)                     AS customers,
    ROUND(SUM(Sales), 2)                            AS revenue,
    ROUND(SUM(Profit), 2)                           AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                    AS margin_pct,
    SUM(Quantity)                                   AS units_sold
FROM dbo.superstore
GROUP BY YEAR(Order_Date)
ORDER BY [year];
GO

-- Q5. Sub-category Profitability Ranking
SELECT
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)                            AS revenue,
    ROUND(SUM(Profit), 2)                           AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                    AS margin_pct,
    RANK() OVER (ORDER BY SUM(Profit) DESC)         AS profit_rank,
    CASE
        WHEN SUM(Profit) < 0                        THEN 'Loss-Making'
        WHEN SUM(Profit) / NULLIF(SUM(Sales),0) < 0.05 THEN 'Low Margin'
        WHEN SUM(Profit) / NULLIF(SUM(Sales),0) < 0.20 THEN 'Medium Margin'
        ELSE 'High Margin'
    END                                             AS margin_category
FROM dbo.superstore
GROUP BY Category, Sub_Category
ORDER BY profit DESC;
GO
