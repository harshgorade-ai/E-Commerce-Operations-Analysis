# E-Commerce Operations & Portfolio Analytics

An end-to-end data analytics project leveraging the Olist Brazilian E-Commerce dataset. This project builds a robust data engineering and business intelligence pipeline to uncover operational insights across logistics performance and product portfolio concentration.

## 📊 Project Architecture & Files
This repository contains the full production pipeline organized across the following operational stages:
* `/Data_Pipelines/` : Two Pandas (`.ipynb`) notebooks executing horizontal relational merges, text translation, data standardization, and financial feature engineering.
* `/SQL_Scripts/` : Two SQL query files implementing aggregation logic and advanced Window Functions to run cumulative revenue tracking.
* `/Dashboards/` : The master Power BI (`.pbix`) application containing interactive executive reporting layers.
* `Dataset Source` : Publicly hosted historical transaction data from the [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

## 🚀 Key Strategic Insights

### 🚚 1. Logistics & Delivery Performance (Task 1)
* **The Bottleneck:** The data pipeline isolated a critical operational breakdown threshold. Shipping delays beyond 1-3 days trigger a binary drop in customer satisfaction, driving average review scores from a baseline of 4.1 stars down to a critical 2.5 stars.
* **The Metric:** Engineered a month-over-month dual-axis model tracking Order Volume against Cumulative Shipping Variance to flag structural delivery delays as the platform scaled.

### 📦 2. Product Portfolio Optimization & Pareto Concentration (Task 2)
* **The 80/20 Rule:** Implemented a cumulative running total window function in SQL to evaluate revenue concentration against the catalog footprint.
* **The Segmentation:** The analysis mathematically validated the Pareto Principle: **just 20.77% of product categories generate 79.23% of the total platform gross revenue ($15.84M)**. The remaining catalog was segmented as low-performing "Long-Tail Inventory" occupying warehouse overhead.

---

## 🎨 Dashboard Preview

### Executive Logistics Overview
![Logistics Dashboard] https://github.com/harshgorade-ai/E-Commerce-Operations-Analysis/blob/main/Screenshot%202026-06-22%20014256.png
### Product Portfolio Concentration (80/20 Pareto)
![Product Dashboard] https://github.com/harshgorade-ai/E-Commerce-Operations-Analysis/blob/main/Screenshot%202026-06-22%20014242.png

---

## 🛠️ Tech Stack & Skills Demonstrated
* **Data Engineering:** Python, Pandas (Data cleaning, handling missing data, type casting, relational left joins).
* **Advanced Database Analytics:** SQL (GROUP BY aggregations, Window Functions, Cumulative Running Totals, Conditional CASE WHEN Logic).
* **Business Intelligence:** Power BI (Multi-page report layout, KPI card design, Pareto line/column combos, matrix tables with conditional data bar formatting).
