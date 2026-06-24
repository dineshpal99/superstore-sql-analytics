# Data Dictionary — Superstore Sales Analytics

## Source: Sample Superstore (Kaggle)

**Period:** January 2014 – December 2017
**Rows:** 9,994
**Columns:** 19
**Geography:** United States only
**Granularity:** One row per product line within an order

---

## Table: dbo.superstore

| Column | SQL Type | Description | Notes |
|--------|----------|-------------|-------|
| Row_ID | INT | Sequential row number | Not used in analysis |
| Order_ID | VARCHAR(25) | Unique order identifier | One order can have multiple rows |
| Order_Date | DATE | Date order was placed | Range: 2014-01-03 to 2017-12-30 |
| Ship_Date | DATE | Date order was shipped | Always >= Order_Date |
| Ship_Mode | VARCHAR(30) | Delivery type | First Class / Second Class / Same Day / Standard Class |
| Customer_ID | VARCHAR(20) | Unique customer identifier | 793 unique customers |
| Segment | VARCHAR(30) | Customer type | Consumer / Corporate / Home Office |
| Country | VARCHAR(50) | Country | All USA |
| City | VARCHAR(100) | Customer city | 531 unique cities |
| State | VARCHAR(50) | Customer state | 49 states |
| Region | VARCHAR(20) | US region | East / West / Central / South |
| Product_ID | VARCHAR(20) | Product identifier | 1,862 unique products |
| Category | VARCHAR(30) | Product category | Technology / Furniture / Office Supplies |
| Sub_Category | VARCHAR(30) | Product sub-type | 17 sub-categories |
| Product_Name | VARCHAR(255) | Full product description | Commas removed for SQL compatibility |
| Sales | DECIMAL(10,4) | Revenue in USD | Line-level revenue |
| Quantity | INT | Units ordered | Range: 1–14 |
| Discount | DECIMAL(5,4) | Discount fraction | 0 = no discount, 0.8 = 80% discount |
| Profit | DECIMAL(10,4) | Profit in USD | Can be negative (loss-making order) |

---

## Business Rules

| Rule | Definition |
|------|------------|
| Loss-making order line | Profit < 0 |
| Loss-making customer | SUM(Profit) < 0 across all their orders |
| Profit Margin % | SUM(Profit) / SUM(Sales) * 100 |
| Revenue per customer | SUM(Sales) / COUNT(DISTINCT Customer_ID) |
| MoM Growth % | (Current Month Revenue - Prior Month Revenue) / Prior Month Revenue * 100 |
| Ship Days | DATEDIFF(DAY, Order_Date, Ship_Date) |
| RFM Recency | DATEDIFF(DAY, MAX(Order_Date), dataset MAX date) — lower = more recent |

---

## Data Quality Results (from 0. Setup and Data Quality Audit.sql)

| Check | Result | Status |
|-------|--------|--------|
| Null Customer_ID | 0 | ✅ Clean |
| Null Product_Name | 0 | ✅ Clean |
| Negative profit rows | 1,871 | ✅ Real losses |
| Zero or negative sales | 0 | ✅ Clean |
| Discount > 0.8 | 0 | ✅ Clean |
| Ship date before order date | 0 | ✅ Clean |
| Duplicate Row_IDs | 0 | ✅ Clean |

---

## Pre-Processing Applied

Before loading into SQL Server, the following cleaning was applied
using `clean_superstore.py`:

1. **Date standardisation** — `Order_Date` and `Ship_Date` converted
   from mixed formats (MM/DD/YYYY with slashes, MM-DD-YYYY with dashes)
   to consistent `YYYY-MM-DD` format
2. **Product name commas removed** — commas inside product names replaced
   with ` -` to prevent CSV parsing errors in BULK INSERT
3. **Double quotes removed** — quote characters (e.g. `72"H`) removed
   from product names for BULK INSERT compatibility

