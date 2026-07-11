# E-Commerce Operations & Retention Analysis

**Does operational failure explain why 97% of customers never come back?**

An end-to-end analytics project on the Olist Brazilian e-commerce dataset, tracing a single question across four dimensions of the business: where the revenue comes from, where delivery breaks down, what that costs in customer retention, and who is responsible for it.

[View the live dashboard](#) · [Read the full write-up below](#key-findings)

---

## Table of contents

- [Problem statement](#problem-statement)
- [Key findings](#key-findings)
- [Dashboard](#dashboard)
- [Dataset](#dataset)
- [Methodology](#methodology)
- [Repository structure](#repository-structure)
- [Tech stack](#tech-stack)
- [How to reproduce this](#how-to-reproduce-this)
- [Recommendations](#recommendations)
- [Future work](#future-work)
- [Contact](#contact)

---

## Problem statement

Olist's marketplace revenue is highly concentrated in a small set of product categories, and delivery delays are causing measurable satisfaction drops. This project investigates whether those two facts compound into a retention risk — i.e., whether the platform's growth is entirely dependent on acquiring new customers because operational failures are quietly killing repeat business. The goal is to identify which sellers and regions are driving the delays, and to quantify the revenue at risk when dissatisfied customers don't come back.

This isn't four unrelated charts. It's one argument, built in four parts:

| # | Question | Page |
|---|---|---|
| 1 | Where does the revenue actually come from? | Product Portfolio |
| 2 | Where does the operational experience fail? | Shipping Performance |
| 3 | What does that failure cost in repeat business? | Customer Retention |
| 4 | Who — which sellers, which regions — is responsible? | Seller & Regional Risk |

---

## Key findings

> **Late deliveries cut repeat purchases nearly in half — turning a $15.84M revenue base into a retention problem the platform hasn't fixed yet.**

- **Revenue is concentrated, not diversified.** ~21% of product categories drive ~79% of the platform's **$15.84M** in gross revenue — the long tail of remaining categories contributes disproportionately little.
- **Delivery delays are a measurable minority — but a costly one.** **6.57%** of orders arrive late, and average review score drops sharply as delay increases (from **4.09** on-time down to roughly half that for orders 7+ days late).
- **Retention is Olist's real bottleneck.** Only **3.12%** of the ~96K customer base ever makes a second purchase — and that rate is materially lower for customers whose first order arrived late.
- **The delay problem is not platform-wide — it's concentrated.** A small subset of sellers and specific seller-state → customer-state shipping lanes account for a disproportionate share of late deliveries, making this a fixable, targeted problem rather than a systemic one.

*(See [Methodology](#methodology) for how each figure was derived, and the SQL/notebooks in `/sql` and `/notebooks` to reproduce them.)*

---

## Dashboard

A 5-page Power BI report: a home/navigation page plus one page per finding above.

| Page | Focus |
|---|---|
| **Home** | Headline KPIs across all four analyses, key finding, navigation |
| **Revenue Concentration** | Product-category Pareto analysis, revenue segments, AOV |
| **Shipping Performance** | Delivery delay buckets, review score impact, satisfaction breakdown |
| **Customer Retention** | Repeat purchase rate by cohort, delivery experience, category |
| **Seller & Regional Risk** | Seller-level delay Pareto, seller revenue-vs-risk, state-pair delay heatmap |

*(Screenshots: add exported PNGs of each page to `/docs/images` and reference them here, e.g. `![Home page](docs/images/home.png)`)*

---

## Dataset

[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — ~100K orders placed on the Olist marketplace between 2016 and 2018, covering order status, pricing, payment, freight performance, customer location, product attributes, and post-purchase reviews.

Key tables used:
- `orders`, `order_items`, `order_payments`, `order_reviews`
- `customers` — note: `customer_id` is per-order; `customer_unique_id` identifies the actual person and is what the retention analysis is built on
- `products`, `product_category_name_translation`
- `sellers`, `geolocation`

---

## Methodology

**1. Revenue concentration (Pareto analysis)**
SQL window functions (`SUM() OVER`, running cumulative %) rank product categories by gross revenue and compute cumulative revenue share, confirming an 80/20-style concentration pattern.

**2. Shipping variance & delivery performance**
Orders are bucketed into delay tiers (On Time/Early, 1–3 Days Late, 4–7 Days Late, 7+ Days Late) by comparing actual vs. estimated delivery date. Average review score and satisfaction distribution are compared across buckets to quantify the operational-to-experience link.

**3. Customer retention (cohort analysis)**
`ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp)` flags first vs. repeat orders per customer. Repeat-purchase rate is then segmented by the first order's review score and delivery-delay bucket to test whether early experience predicts return behavior.

**4. Seller & regional risk**
Late-delivery rate is aggregated by `seller_id` and by seller-state → customer-state pairs, then cross-referenced against seller revenue contribution — separating sellers who are both high-risk and high-revenue (priority to fix) from low-volume outliers.

---

## Repository structure

```
├── sql/
│   ├── 01_revenue_pareto.sql
│   ├── 02_shipping_variance.sql
│   ├── 03_repeat_purchase_cohort.sql
│   └── 04_seller_regional_risk.sql
├── notebooks/
│   ├── 01_data_pipeline.ipynb
│   ├── 02_revenue_pareto.ipynb
│   ├── 03_shipping_variance.ipynb
│   ├── 04_retention_analysis.ipynb
│   └── 05_seller_regional_analysis.ipynb
├── dashboard/
│   └── Ecommerce_Operations_Analysis.pbix
├── docs/
│   └── images/
│       ├── home.png
│       ├── revenue.png
│       ├── shipping.png
│       ├── retention.png
│       └── seller_risk.png
├── requirements.txt
├── LICENSE
└── README.md
```

---

## Tech stack

- **Python** (Pandas) — data cleaning, joins, cohort construction
- **SQL** — aggregation, window functions, CASE-based bucketing
- **Power BI** — dashboard layer, DAX measures, interactive navigation

---

## How to reproduce this

```bash
# clone the repo
git clone https://github.com/harshgorade-ai/E-Commerce-Operations-Analysis.git
cd E-Commerce-Operations-Analysis

# set up environment
pip install -r requirements.txt

# download the dataset from Kaggle and place CSVs in /data (gitignored)
# then run notebooks in order, 01 through 05

# open dashboard/Ecommerce_Operations_Analysis.pbix in Power BI Desktop
# to explore the interactive report
```

---

## Recommendations

This analysis shows that Olist's revenue depends on a narrow set of product categories and, critically, that operational failures — not product or pricing issues — are among the biggest threats to repeat business. With only 3.12% of customers returning and delivery delay strongly correlated with dissatisfaction, three actions follow directly from the data:

1. **Target the seller/lane concentration first.** A small number of sellers and shipping lanes drive a disproportionate share of delays — fixing these has outsized impact relative to a platform-wide intervention.
2. **Treat first-order delivery as a retention-critical event.** Since first-order experience predicts return behavior, prioritizing on-time delivery for first-time customers specifically (vs. treating all orders equally) may be higher-leverage than an across-the-board logistics investment.
3. **Monitor the core-revenue categories' delivery performance separately.** Delay in the ~21% of categories driving ~79% of revenue carries more retention risk per late order than delay in long-tail categories.

---

## Future work

- Incorporate payment method and installment data to test whether payment friction compounds the retention effect
- Build a seller scorecard combining delay rate, revenue contribution, and review score into a single risk index
- Extend the cohort analysis to a full survival/retention curve (time-to-second-purchase) rather than a binary repeat/no-repeat split

---

## Contact

**Harsh Gorade**
[GitHub](https://github.com/harshgorade-ai) · [LinkedIn](#) · [Email](#)

If you found this useful or have feedback, feel free to open an issue or reach out directly.
