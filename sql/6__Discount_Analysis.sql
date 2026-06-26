-- ============================================================
-- FILE: 6. Discount Analysis.sql
-- PROJECT: Retail Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: discount impact
-- ============================================================

-- ============================================================
-- ** DISCOUNT IMPACT ANALYSIS
-- ============================================================

-- Profit margin by discount band
SELECT
    CASE
        WHEN Discount = 0           THEN '0% (No discount)'
        WHEN Discount <= 0.10       THEN '1-10%'
        WHEN Discount <= 0.20       THEN '11-20%'
        WHEN Discount <= 0.30       THEN '21-30%'
        WHEN Discount <= 0.40       THEN '31-40%'
        ELSE '40%+'
    END                                         AS discount_band,
    COUNT(*)                                    AS order_lines,
    ROUND(SUM(Sales), 2)                        AS revenue,
    ROUND(SUM(Profit), 2)                       AS profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                AS margin_pct,
    ROUND(AVG(Discount) * 100, 2)               AS avg_discount_pct,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_making_lines
FROM dbo.retail_sales
GROUP BY
    CASE
        WHEN Discount = 0           THEN '0% (No discount)'
        WHEN Discount <= 0.10       THEN '1-10%'
        WHEN Discount <= 0.20       THEN '11-20%'
        WHEN Discount <= 0.30       THEN '21-30%'
        WHEN Discount <= 0.40       THEN '31-40%'
        ELSE '40%+'
    END
ORDER BY MIN(Discount);
GO

-- Sub-category discount vs margin correlation
SELECT
    Sub_Category,
    ROUND(AVG(Discount) * 100, 2)               AS avg_discount_pct,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2)
                                                AS margin_pct,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    COUNT(CASE WHEN Profit < 0 THEN 1 END)      AS loss_lines
FROM dbo.retail_sales
GROUP BY Sub_Category
ORDER BY avg_discount_pct DESC;
GO