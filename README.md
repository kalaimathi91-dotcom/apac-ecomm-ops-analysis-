# APAC E-commerce Strategy & Operations Analysis — 2024

**Author:** Kalaivani Mathivanan  
**Tools:** Python · SQL (SQLite) · Jupyter Notebook · Tableau  
**Dataset:** 15,000 orders across 6 APAC markets (Jan–Dec 2024)  

---

## Business Objective

Analyse APAC e-commerce performance across revenue, operations, and channel metrics to surface data-driven GTM recommendations for H1 2025 — simulating the cross-functional analytics work of a Strategy & Operations analyst.

---

## Business Questions Answered

| # | Question | Section |
|---|---|---|
| 1 | Which APAC markets drive the most revenue - and which have growth potential? | Revenue & Market Analysis |
| 2 | Which categories have high return rates eating into margin? | Category Performance |
| 3 | Which markets are breaching fulfillment SLA targets? | Operational KPIs |
| 4 | Is Social Commerce an emerging channel worth investing in? | Channel Analysis |
| 5 | Where should GTM investment focus in H1 2025? | Executive Summary |

---

## Project Structure

```
├── data/
│   └── apac_ecommerce_orders.csv        # 15,000 orders — 6 markets, 7 categories
│
├── sql/
│   └── ecomm_analysis_queries.sql       # 11 SQL queries: validation, revenue, ops, GTM
│
├── notebooks/
│   └── apac_ecomm_ops_analysis.ipynb   # Full analysis — SQL + Python + dashboard
│
└── outputs/
    ├── ecomm_ops_dashboard.png          # 6-panel visual dashboard
    └── ecomm_tableau_ready.csv          # Flat file for Tableau
```

---

## Key Findings

### 📦 Revenue
- **Indonesia** leads with $355K GMV (29.5% share) — highest order volume and fast growing
- **Singapore** has the highest AOV ($82 avg) — premium segment opportunity
- **Philippines & Vietnam** show strongest Q4 momentum — acceleration markets

### 🔁 Operations
- **Philippines & Indonesia breaching 4-day SLA** — 79.3% and 49.7% of orders delayed
- **Fashion return rate of 14%** is highest across categories — size/fit friction identified
- **Electronics** drives highest revenue per order but also has returns — quality assurance gap

### 📱 Channel
- **App drives 55% of revenue** and the highest repeat customer rate — loyalty investment pays off
- **Social Commerce** is the fastest-growing channel across Vietnam and Philippines — influencer-led purchasing is real and growing
- **Web channel** maintains a strong $87 AOV — desktop-first users skew higher value

### 🎯 GTM Recommendations (H1 2025)
1. **Philippines** — fix logistics SLA (partner review); double down on Social Commerce (highest penetration 16%)
2. **Vietnam** — scale Social Commerce-first GTM playbook; strong repeat customers signal loyalty programme ROI
3. **Singapore** — BNPL and premium Electronics bundles to lift AOV further
4. **Fashion (all markets)** — virtual try-on or size recommendation tool to reduce 14% return rate

---

## SQL Highlights

```sql
-- Fulfillment SLA breach rate by market
SELECT country,
       ROUND(AVG(delivery_days), 1) AS avg_delivery_days,
       ROUND(SUM(CASE WHEN delivery_days > 4 THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS sla_breach_pct,
       CASE WHEN AVG(delivery_days) > 4 THEN 'ACTION REQUIRED' ELSE 'ON TRACK' END AS sla_status
FROM orders
GROUP BY country
ORDER BY avg_delivery_days DESC;
```

```sql
-- Social commerce revenue penetration by market
SELECT country,
       ROUND(SUM(CASE WHEN channel='Social Commerce' THEN revenue_usd ELSE 0 END)*100.0
             / SUM(revenue_usd), 1) AS social_commerce_pct
FROM orders
GROUP BY country ORDER BY social_commerce_pct DESC;
```

---

## Dashboard

![APAC E-commerce Ops Dashboard](outputs/ecomm_ops_dashboard.png)

---

## How to Run

```bash
pip install pandas matplotlib seaborn notebook
jupyter notebook notebooks/apac_ecomm_ops_analysis.ipynb
```

---

## Connect
**GitHub:** [github.com/kalaimathi91-dotcom](https://github.com/kalaimathi91-dotcom)  
**LinkedIn:** [linkedin.com/in/kalaivani-mathivanan](https://linkedin.com/in/kalaivani-mathivanan)
