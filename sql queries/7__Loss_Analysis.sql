-- ============================================================
-- FILE: 7. Loss Analysis.sql
-- PROJECT: Superstore Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: Loss analysis
-- ============================================================

-- ============================================================
-- PART 4: LOSS-MAKING ORDERS ANALYSIS
-- ============================================================

-- Summary: what % of orders are loss-making?
SELECT
    COUNT(CASE WHEN Profit < 0 THEN 1 END)      AS loss_order_lines,
    COUNT(*)                                     AS total_order_lines,
    ROUND(COUNT(CASE WHEN Profit < 0 THEN 1 END) * 100.0 /
        COUNT(*), 1)                             AS loss_pct,
    ROUND(SUM(CASE WHEN Profit < 0
        THEN Profit ELSE 0 END), 2)              AS total_loss_amount
FROM dbo.superstore;
GO

-- Top loss-making sub-categories
SELECT
    Sub_Category,
    COUNT(CASE WHEN Profit < 0 THEN 1 END)      AS loss_lines,
    ROUND(SUM(CASE WHEN Profit < 0
        THEN Profit ELSE 0 END), 2)              AS total_loss,
    ROUND(AVG(CASE WHEN Profit < 0
        THEN Discount END) * 100, 2)             AS avg_discount_on_loss
FROM dbo.superstore
GROUP BY Sub_Category
ORDER BY total_loss ASC;
GO