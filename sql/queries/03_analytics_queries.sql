-- ============================================================
-- BUSINESS ANALYTICS QUERIES — Retail Analytics
-- ============================================================
USE retail_analytics;

-- ─────────────────────────────────────────────
-- Q1: Monthly Revenue & Profit Summary
-- ─────────────────────────────────────────────
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')          AS month,
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    COUNT(DISTINCT o.customer_id)                AS unique_customers,
    ROUND(SUM(oi.line_total), 2)                 AS gross_revenue,
    ROUND(SUM(oi.unit_cost * oi.quantity), 2)    AS total_cogs,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS gross_profit,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity)
          / NULLIF(SUM(oi.line_total), 0) * 100, 2)           AS gross_margin_pct
FROM fact_orders o
JOIN fact_order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- ─────────────────────────────────────────────
-- Q2: Top 10 Products by Revenue
-- ─────────────────────────────────────────────
SELECT
    p.product_name,
    c.category_name,
    SUM(oi.quantity)                                         AS units_sold,
    ROUND(SUM(oi.line_total), 2)                             AS total_revenue,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS gross_profit,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity)
          / NULLIF(SUM(oi.line_total), 0) * 100, 2)          AS margin_pct
FROM fact_order_items oi
JOIN dim_products p    ON oi.product_id = p.product_id
JOIN dim_categories c  ON p.category_id = c.category_id
JOIN fact_orders o     ON oi.order_id   = o.order_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- ─────────────────────────────────────────────
-- Q3: Customer Lifetime Value (CLV)
-- ─────────────────────────────────────────────
SELECT
    c.customer_id,
    c.full_name,
    c.customer_segment,
    r.region_name,
    COUNT(DISTINCT o.order_id)                 AS total_orders,
    ROUND(SUM(oi.line_total), 2)               AS lifetime_value,
    ROUND(AVG(oi.line_total), 2)               AS avg_order_value,
    MIN(DATE(o.order_date))                    AS first_order_date,
    MAX(DATE(o.order_date))                    AS last_order_date,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_lifespan_days
FROM dim_customers c
JOIN fact_orders o       ON c.customer_id = o.customer_id
JOIN fact_order_items oi ON o.order_id    = oi.order_id
JOIN dim_regions r       ON c.region_id   = r.region_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY c.customer_id, c.full_name, c.customer_segment, r.region_name
ORDER BY lifetime_value DESC;

-- ─────────────────────────────────────────────
-- Q4: Sales by Region
-- ─────────────────────────────────────────────
SELECT
    r.region_name,
    COUNT(DISTINCT o.order_id)                 AS total_orders,
    ROUND(SUM(oi.line_total), 2)               AS total_revenue,
    ROUND(AVG(o.total_amount), 2)              AS avg_order_value,
    COUNT(DISTINCT o.customer_id)              AS unique_customers
FROM dim_regions r
JOIN fact_orders o       ON r.region_id  = o.region_id
JOIN fact_order_items oi ON o.order_id   = oi.order_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY r.region_id, r.region_name
ORDER BY total_revenue DESC;

-- ─────────────────────────────────────────────
-- Q5: Sales Rep Performance
-- ─────────────────────────────────────────────
SELECT
    sr.full_name                               AS sales_rep,
    r.region_name,
    COUNT(DISTINCT o.order_id)                 AS deals_closed,
    COUNT(DISTINCT o.customer_id)              AS customers_served,
    ROUND(SUM(oi.line_total), 2)               AS total_revenue,
    ROUND(AVG(o.total_amount), 2)              AS avg_deal_size,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS gross_profit_generated
FROM dim_salesreps sr
JOIN fact_orders o       ON sr.rep_id   = o.rep_id
JOIN fact_order_items oi ON o.order_id  = oi.order_id
JOIN dim_regions r       ON sr.region_id = r.region_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY sr.rep_id, sr.full_name, r.region_name
ORDER BY total_revenue DESC;

-- ─────────────────────────────────────────────
-- Q6: Category Performance
-- ─────────────────────────────────────────────
SELECT
    COALESCE(parent.category_name, c.category_name) AS parent_category,
    c.category_name                                  AS sub_category,
    SUM(oi.quantity)                                 AS units_sold,
    ROUND(SUM(oi.line_total), 2)                     AS revenue,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS profit,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity)
          / NULLIF(SUM(oi.line_total), 0) * 100, 2)  AS margin_pct
FROM fact_order_items oi
JOIN dim_products p   ON oi.product_id = p.product_id
JOIN dim_categories c ON p.category_id = c.category_id
LEFT JOIN dim_categories parent ON c.parent_id = parent.category_id
JOIN fact_orders o    ON oi.order_id = o.order_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY parent_category, c.category_id, c.category_name
ORDER BY revenue DESC;

-- ─────────────────────────────────────────────
-- Q7: Payment Method Distribution
-- ─────────────────────────────────────────────
SELECT
    payment_method,
    COUNT(*)                                   AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_orders,
    ROUND(SUM(total_amount), 2)                AS total_revenue
FROM fact_orders
WHERE status NOT IN ('Cancelled','Returned')
GROUP BY payment_method
ORDER BY order_count DESC;

-- ─────────────────────────────────────────────
-- Q8: Return Rate Analysis
-- ─────────────────────────────────────────────
SELECT
    p.product_name,
    COUNT(DISTINCT oi.order_id)                AS total_orders,
    COUNT(DISTINCT rt.return_id)               AS total_returns,
    ROUND(COUNT(DISTINCT rt.return_id) * 100.0
          / NULLIF(COUNT(DISTINCT oi.order_id), 0), 2) AS return_rate_pct,
    ROUND(SUM(rt.refund_amount), 2)            AS total_refunds
FROM dim_products p
LEFT JOIN fact_order_items oi ON p.product_id = oi.product_id
LEFT JOIN fact_returns rt     ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name
HAVING total_returns > 0
ORDER BY return_rate_pct DESC;

-- ─────────────────────────────────────────────
-- Q9: Year-over-Year Growth
-- ─────────────────────────────────────────────
SELECT
    YEAR(o.order_date)                         AS year,
    ROUND(SUM(oi.line_total), 2)               AS revenue,
    COUNT(DISTINCT o.order_id)                 AS orders,
    ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS profit,
    LAG(ROUND(SUM(oi.line_total), 2)) OVER (ORDER BY YEAR(o.order_date)) AS prev_year_revenue,
    ROUND((SUM(oi.line_total)
          - LAG(SUM(oi.line_total)) OVER (ORDER BY YEAR(o.order_date)))
          / NULLIF(LAG(SUM(oi.line_total)) OVER (ORDER BY YEAR(o.order_date)), 0) * 100, 2) AS yoy_growth_pct
FROM fact_orders o
JOIN fact_order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY YEAR(o.order_date)
ORDER BY year;

-- ─────────────────────────────────────────────
-- Q10: Customer Segmentation RFM Score
-- ─────────────────────────────────────────────
SELECT
    c.customer_id,
    c.full_name,
    c.customer_segment,
    DATEDIFF('2024-12-31', MAX(o.order_date))  AS recency_days,
    COUNT(DISTINCT o.order_id)                 AS frequency,
    ROUND(SUM(oi.line_total), 2)               AS monetary
FROM dim_customers c
JOIN fact_orders o       ON c.customer_id = o.customer_id
JOIN fact_order_items oi ON o.order_id    = oi.order_id
WHERE o.status NOT IN ('Cancelled','Returned')
GROUP BY c.customer_id, c.full_name, c.customer_segment
ORDER BY monetary DESC;
