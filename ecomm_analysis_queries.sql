-- ============================================================
-- APAC E-commerce Strategy & Operations Analysis
-- SQL Queries — Data Extraction, Validation & Business Metrics
-- Author: Kalaivani Mathivanan
-- ============================================================

-- ── DATA VALIDATION ───────────────────────────────────────────────────────

-- 1. Row count & null check
SELECT
    COUNT(*)                                        AS total_orders,
    COUNT(DISTINCT country)                         AS markets,
    COUNT(DISTINCT category)                        AS categories,
    MIN(order_date)                                 AS date_from,
    MAX(order_date)                                 AS date_to,
    SUM(CASE WHEN revenue_usd IS NULL THEN 1 END)   AS null_revenue,
    SUM(CASE WHEN country IS NULL THEN 1 END)       AS null_country
FROM orders;

-- 2. Logical consistency — revenue must equal unit_price * quantity
SELECT COUNT(*) AS inconsistent_rows
FROM orders
WHERE ABS(revenue_usd - (unit_price_usd * quantity)) > 0.05;


-- ── REVENUE & VOLUME METRICS ──────────────────────────────────────────────

-- 3. Monthly GMV and order volume trend
SELECT
    month,
    COUNT(order_id)                         AS total_orders,
    ROUND(SUM(revenue_usd), 0)              AS gmv_usd,
    ROUND(AVG(revenue_usd), 2)              AS avg_order_value,
    SUM(returned)                           AS returns,
    ROUND(SUM(returned)*100.0/COUNT(*), 1)  AS return_rate_pct
FROM orders
GROUP BY month
ORDER BY month;

-- 4. Revenue by market — ranked
SELECT
    country,
    COUNT(order_id)                                             AS orders,
    ROUND(SUM(revenue_usd), 0)                                 AS total_revenue_usd,
    ROUND(AVG(revenue_usd), 2)                                 AS aov_usd,
    ROUND(SUM(revenue_usd)*100.0 / SUM(SUM(revenue_usd)) OVER (), 1) AS revenue_share_pct,
    SUM(returned)                                               AS returns,
    ROUND(SUM(returned)*100.0 / COUNT(*), 1)                   AS return_rate_pct,
    ROUND(AVG(delivery_days), 1)                               AS avg_delivery_days
FROM orders
GROUP BY country
ORDER BY total_revenue_usd DESC;

-- 5. Category performance
SELECT
    category,
    COUNT(order_id)                                              AS orders,
    ROUND(SUM(revenue_usd), 0)                                  AS total_revenue_usd,
    ROUND(AVG(revenue_usd), 2)                                  AS aov_usd,
    ROUND(SUM(revenue_usd)*100.0 / SUM(SUM(revenue_usd)) OVER (), 1) AS revenue_share_pct,
    ROUND(SUM(returned)*100.0 / COUNT(*), 1)                    AS return_rate_pct
FROM orders
GROUP BY category
ORDER BY total_revenue_usd DESC;


-- ── OPERATIONAL KPIs ──────────────────────────────────────────────────────

-- 6. Fulfillment SLA by market (flag markets exceeding 4-day target)
SELECT
    country,
    ROUND(AVG(delivery_days), 1)                        AS avg_delivery_days,
    MAX(delivery_days)                                   AS max_delivery_days,
    SUM(CASE WHEN delivery_days > 4 THEN 1 ELSE 0 END)  AS orders_breaching_sla,
    ROUND(SUM(CASE WHEN delivery_days > 4 THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS sla_breach_pct,
    CASE WHEN AVG(delivery_days) > 4 THEN 'ACTION REQUIRED' ELSE 'ON TRACK' END AS sla_status
FROM orders
GROUP BY country
ORDER BY avg_delivery_days DESC;

-- 7. Channel performance — revenue and repeat customer rate
SELECT
    channel,
    COUNT(order_id)                                             AS orders,
    ROUND(SUM(revenue_usd), 0)                                  AS revenue_usd,
    ROUND(AVG(revenue_usd), 2)                                  AS aov_usd,
    ROUND(SUM(is_repeat_customer)*100.0/COUNT(*), 1)            AS repeat_customer_pct
FROM orders
GROUP BY channel
ORDER BY revenue_usd DESC;

-- 8. Payment method adoption by market
SELECT
    country,
    payment_method,
    COUNT(*)                                                     AS orders,
    ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER (PARTITION BY country), 1) AS share_pct
FROM orders
GROUP BY country, payment_method
ORDER BY country, share_pct DESC;


-- ── GTM OPPORTUNITY ANALYSIS ──────────────────────────────────────────────

-- 9. Quarterly growth by market — identify acceleration
SELECT
    country,
    quarter,
    ROUND(SUM(revenue_usd), 0)             AS quarterly_gmv,
    COUNT(order_id)                         AS orders,
    ROUND(AVG(revenue_usd), 2)             AS aov
FROM orders
GROUP BY country, quarter
ORDER BY country, quarter;

-- 10. High-value customer segments (repeat + high AOV)
SELECT
    country,
    category,
    is_repeat_customer,
    COUNT(order_id)                         AS orders,
    ROUND(AVG(revenue_usd), 2)             AS avg_revenue,
    ROUND(SUM(revenue_usd), 0)             AS total_revenue
FROM orders
WHERE is_repeat_customer = 1
GROUP BY country, category, is_repeat_customer
HAVING COUNT(order_id) >= 10
ORDER BY total_revenue DESC
LIMIT 15;

-- 11. Social commerce traction — emerging channel analysis
SELECT
    country,
    ROUND(SUM(CASE WHEN channel='Social Commerce' THEN revenue_usd ELSE 0 END)*100.0/SUM(revenue_usd), 1) AS social_commerce_pct,
    ROUND(SUM(CASE WHEN channel='Social Commerce' THEN revenue_usd ELSE 0 END), 0) AS social_revenue_usd,
    ROUND(AVG(CASE WHEN channel='Social Commerce' THEN revenue_usd END), 2) AS social_aov
FROM orders
GROUP BY country
ORDER BY social_commerce_pct DESC;
