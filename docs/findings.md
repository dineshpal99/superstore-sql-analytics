# Key Findings — Retail Sales Analytics

All numbers verified from actual SQL Server query results.

---

## Setup & Data Quality (File 0)

- **9,994 rows** loaded successfully — all quality checks passed
- **1,871 rows** have negative profit (18.7% of all order lines) — real losses, not errors
- Data spans **2014-01-03 to 2017-12-30** — 4 complete years
- Max sales value: **$22,638.48** | Min profit: **-$6,599.98**
- California has the most rows (2,001) and unique customers (577)

---

## Overview KPIs (File 1)

- Total revenue: **$2,297,200.86**
- Total profit: **$286,397.02**
- Overall margin: **12.47%**
- Technology has the highest margin: **17.40%**
- Furniture has the lowest margin: **2.49%** — Tables, Bookcases, Supplies are loss-making
- Home Office segment has the best margin: **14.03%**
- Revenue grew from **$484,247** (2014) to **$733,215** (2017) — +51.5% over 4 years

---

## Product Analysis (File 2)

- **Top product:** Canon imageCLASS 2200 Advanced Copier — $25,199.93 profit
- **Worst product:** Cubify CubeX 3D Printer Double Head Print — -$8,879.97 loss (53% avg discount)
- **Pareto finding:** Only **21.7% of products** (392 of 1,803) generate 80% of all profit
- 3D printers and certain Machines sub-category products consistently loss-making

---

## Regional Analysis (File 3)

- **Best region:** West — $725,457.82 revenue, 14.94% margin
- **Worst region:** Central — only 7.92% margin
- **10 states** have negative total profit
- **Texas** is the worst state: -$25,729.36 loss, 37.02% avg discount
- Central/Furniture category has **negative profit (-$2,871.05)** — only negative cell in the matrix
- California and New York are the strongest states by both revenue and profit

---

## RFM Analysis (File 4)

- **Champion segment:** 223 customers — 18.3% of total revenue ($421,194)
- **At Risk segment:** 173 customers — $402,701 in revenue at risk of churn
- **Lapsed/Others:** Largest group (286 customers) — 47.6% of revenue
- **New Customers:** Only 25 customers — 5% of revenue (growth opportunity)
- RFM scoring uses NTILE(4) quartiles — score 4 = best for all three dimensions

---

## Growth Analysis (File 5)

- MoM growth is highly volatile — ranges from -75.3% to +224%
- The **rolling 3-month average** smooths noise and shows consistent
  underlying growth trend
- Cumulative revenue reached **$2,297,200.86** by Dec 2017
- Strong Q4 seasonal peaks visible every year (September/November spikes)

---

## Discount Analysis (File 6)

- **0% discount:** 29.51% margin — $320,987.60 profit ✅
- **11-20% discount:** 11.58% margin — still profitable
- **21-30% discount:** -10.05% margin — LOSS-MAKING ❌
- **40%+ discount:** -77.40% margin — destroys $99,558.59 in profit ❌
- **Binders** has the highest avg discount (37.23%) of any sub-category
- Clear threshold: **above 20% discount = consistent losses**

---

## Loss Analysis (File 7)

- **18.7% of all order lines** are loss-making (1,871 of 9,994)
- Total loss amount: **-$156,131.29**
- **Binders** has the most loss lines (613) with 73.8% avg discount on those orders
- **5 sub-categories have zero loss lines:** Paper, Copiers, Labels, Art, Envelopes
- These zero-loss sub-categories are the benchmark for a healthy discount policy

---

## Shipping Analysis (File 8)

- **Standard Class** handles 59.1% of all revenue but has the lowest margin (12.08%)
- **First Class** has the highest margin: **13.93%**
- **Same Day** delivery averages 0 ship days — processes same calendar day
- All four shipping modes have similar margins (12–14%) — shipping mode is
  not a significant driver of profitability differences

---

## Interview Story (Top Finding)

> "The most valuable insight from this project came from combining two analyses.
> The discount analysis showed that orders above 20% discount are consistently
> loss-making. The loss analysis confirmed that Binders had 613 loss-making
> order lines with an average discount of 73.8% on those specific orders.
> Meanwhile, Copiers — which has a 37.2% profit margin and zero loss lines —
> has an average discount of only 16.18%. The data shows a direct, measurable
> relationship: discipline in discounting directly drives profitability.
> My recommendation would be to cap all discounts at 20% across the board,
> and specifically review the Binders, Tables, and Machines pricing strategies
> where excessive discounting is destroying the most value."

---

*All findings verified from SQL Server query results*
