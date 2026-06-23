-- ============================================================
-- STORED PROCEDURES — Retail Analytics
-- ============================================================
USE retail_analytics;

DELIMITER $$

-- ─────────────────────────────────────────────
-- SP1: Get Monthly Revenue Report
-- ─────────────────────────────────────────────
CREATE PROCEDURE sp_monthly_revenue(IN p_year INT)
BEGIN
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m')           AS month,
        COUNT(DISTINCT o.order_id)                    AS total_orders,
        COUNT(DISTINCT o.customer_id)                 AS unique_customers,
        ROUND(SUM(oi.line_total), 2)                  AS gross_revenue,
        ROUND(SUM(oi.unit_cost * oi.quantity), 2)     AS total_cogs,
        ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS gross_profit,
        ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity)
              / NULLIF(SUM(oi.line_total), 0) * 100, 2) AS gross_margin_pct
    FROM fact_orders o
    JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE o.status NOT IN ('Cancelled','Returned')
      AND YEAR(o.order_date) = p_year
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
    ORDER BY month;
END$$

-- ─────────────────────────────────────────────
-- SP2: Customer Profile & Purchase History
-- ─────────────────────────────────────────────
CREATE PROCEDURE sp_customer_profile(IN p_customer_id INT)
BEGIN
    -- Basic Info
    SELECT c.*, r.region_name
    FROM dim_customers c
    JOIN dim_regions r ON c.region_id = r.region_id
    WHERE c.customer_id = p_customer_id;

    -- Purchase History
    SELECT
        o.order_id,
        DATE(o.order_date)       AS order_date,
        o.status,
        o.payment_method,
        ROUND(o.total_amount, 2) AS order_total,
        GROUP_CONCAT(p.product_name SEPARATOR ', ') AS products
    FROM fact_orders o
    JOIN fact_order_items oi ON o.order_id   = oi.order_id
    JOIN dim_products p      ON oi.product_id = p.product_id
    WHERE o.customer_id = p_customer_id
    GROUP BY o.order_id, o.order_date, o.status, o.payment_method, o.total_amount
    ORDER BY o.order_date DESC;

    -- CLV Summary
    SELECT
        COUNT(DISTINCT o.order_id)   AS total_orders,
        ROUND(SUM(oi.line_total), 2) AS lifetime_value,
        ROUND(AVG(o.total_amount), 2) AS avg_order_value,
        DATEDIFF(NOW(), MIN(o.order_date)) AS days_as_customer
    FROM fact_orders o
    JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = p_customer_id
      AND o.status NOT IN ('Cancelled','Returned');
END$$

-- ─────────────────────────────────────────────
-- SP3: Product Inventory Alert
-- ─────────────────────────────────────────────
CREATE PROCEDURE sp_inventory_alert(IN p_threshold INT)
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        p.sku,
        c.category_name,
        p.stock_qty,
        p.unit_price,
        CASE
            WHEN p.stock_qty = 0            THEN 'OUT OF STOCK'
            WHEN p.stock_qty <= p_threshold THEN 'LOW STOCK'
            ELSE 'OK'
        END AS stock_status
    FROM dim_products p
    JOIN dim_categories c ON p.category_id = c.category_id
    WHERE p.stock_qty <= p_threshold AND p.is_active = TRUE
    ORDER BY p.stock_qty ASC;
END$$

-- ─────────────────────────────────────────────
-- SP4: Sales Rep Leaderboard
-- ─────────────────────────────────────────────
CREATE PROCEDURE sp_rep_leaderboard(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        sr.full_name                                AS sales_rep,
        r.region_name,
        COUNT(DISTINCT o.order_id)                  AS orders_closed,
        ROUND(SUM(oi.line_total), 2)                AS revenue,
        ROUND(SUM(oi.line_total - oi.unit_cost * oi.quantity), 2) AS profit,
        RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS revenue_rank
    FROM dim_salesreps sr
    JOIN fact_orders o       ON sr.rep_id    = o.rep_id
    JOIN fact_order_items oi ON o.order_id   = oi.order_id
    JOIN dim_regions r       ON sr.region_id = r.region_id
    WHERE o.status NOT IN ('Cancelled','Returned')
      AND (p_year  IS NULL OR YEAR(o.order_date)  = p_year)
      AND (p_month IS NULL OR MONTH(o.order_date) = p_month)
    GROUP BY sr.rep_id, sr.full_name, r.region_name
    ORDER BY revenue DESC;
END$$

DELIMITER ;
