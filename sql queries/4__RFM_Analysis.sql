-- ============================================================
-- FILE: 4. RFM Analysis.sql
-- PROJECT: Superstore Sales Analytics
-- DATABASE: Microsoft SQL Server (T-SQL)
-- PURPOSE: RFM segmentation
-- ============================================================

-- ============================================================
-- ** CUSTOMER RFM SEGMENTATION
-- ============================================================

WITH rfm_raw AS (
    SELECT
        Customer_ID,
        Segment,
        DATEDIFF(DAY, MAX(Order_Date),
            MAX(MAX(Order_Date)) OVER ())       AS recency_days,
        COUNT(DISTINCT Order_ID)                AS frequency,
        ROUND(SUM(Sales), 2)                    AS monetary
    FROM dbo.superstore
    GROUP BY Customer_ID, Segment
),
rfm_scored AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY recency_days ASC)   AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC)     AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC)      AS m_score
    FROM rfm_raw
),
rfm_segmented AS (
    SELECT *,
        r_score + f_score + m_score             AS rfm_total,
        CASE
            WHEN r_score >= 3 AND f_score >= 3  THEN 'Champion'
            WHEN r_score >= 3 AND f_score >= 2  THEN 'Loyal'
            WHEN r_score = 4  AND f_score <= 2  THEN 'New Customer'
            WHEN r_score <= 2 AND f_score >= 3  THEN 'At Risk'
            WHEN r_score <= 2 AND f_score <= 2  THEN 'Lapsed'
            ELSE 'Needs Attention'
        END                                     AS rfm_segment
    FROM rfm_scored
)
SELECT
    Customer_ID, Segment,
    recency_days, frequency, monetary,
    r_score, f_score, m_score,
    rfm_total, rfm_segment
FROM rfm_segmented
ORDER BY rfm_total DESC;
GO

-- RFM Segment Summary
WITH rfm_raw AS (
    SELECT
        Customer_ID,
        DATEDIFF(DAY, MAX(Order_Date),
            MAX(MAX(Order_Date)) OVER ())       AS recency_days,
        COUNT(DISTINCT Order_ID)                AS frequency,
        SUM(Sales)                              AS monetary
    FROM dbo.superstore
    GROUP BY Customer_ID
),
rfm_scored AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY recency_days ASC)   AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC)     AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC)      AS m_score
    FROM rfm_raw
),
rfm_seg AS (
    SELECT *,
        CASE
            WHEN r_score >= 3 AND f_score >= 3  THEN 'Champion'
            WHEN r_score >= 3 AND f_score >= 2  THEN 'Loyal'
            WHEN r_score = 4  AND f_score <= 2  THEN 'New Customer'
            WHEN r_score <= 2 AND f_score >= 3  THEN 'At Risk'
            ELSE 'Lapsed / Others'
        END                                     AS rfm_segment
    FROM rfm_scored
)
SELECT
    rfm_segment,
    COUNT(*)                                    AS customers,
    ROUND(AVG(monetary), 2)                     AS avg_revenue,
    ROUND(SUM(monetary), 2)                     AS total_revenue,
    ROUND(SUM(monetary) * 100.0 /
        SUM(SUM(monetary)) OVER (), 1)          AS revenue_share_pct
FROM rfm_seg
GROUP BY rfm_segment
ORDER BY total_revenue DESC;
GO