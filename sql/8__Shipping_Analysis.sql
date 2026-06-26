-- ============================================================
-- FILE: 8. Shipping Analysis.sql
-- PROJECT: Retail Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: Shipping performance
-- ============================================================

-- ============================================================
-- ** SHIPPING MODE ANALYSIS
-- ============================================================

SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID)                    AS orders,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                AS margin_pct,
    ROUND(AVG(CAST(DATEDIFF(DAY, Order_Date, Ship_Date)
        AS FLOAT)), 1)                           AS avg_ship_days,
    ROUND(SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER (), 1)             AS revenue_share_pct
FROM dbo.retail_sales
GROUP BY Ship_Mode
ORDER BY revenue DESC;
GO
