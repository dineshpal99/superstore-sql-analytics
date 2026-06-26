-- ============================================================
-- FILE: 5. Growth Analysis.sql
-- PROJECT: Retail Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: MoM growth
-- ============================================================

-- ============================================================
-- ** MONTH-OVER-MONTH GROWTH ANALYSIS
-- ============================================================

WITH monthly AS (
    SELECT
        DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1)
                                                AS [month],
        ROUND(SUM(Sales), 2)                    AS revenue,
        ROUND(SUM(Profit), 2)                   AS profit,
        COUNT(DISTINCT Order_ID)                AS orders
    FROM dbo.retail_sales
    GROUP BY DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1)
)
SELECT
    [month],
    revenue,
    LAG(revenue) OVER (ORDER BY [month])        AS prev_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY [month])) * 100.0
        / NULLIF(LAG(revenue) OVER (ORDER BY [month]), 0)
    , 1)                                        AS mom_growth_pct,
    profit,
    ROUND(SUM(revenue) OVER (
        ORDER BY [month]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                       AS cumulative_revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY [month]
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                                       AS rolling_3m_avg
FROM monthly
ORDER BY [month];
GO
