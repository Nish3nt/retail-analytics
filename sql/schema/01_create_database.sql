-- ============================================================
-- RETAIL ANALYTICS DATABASE
-- Project: End-to-End Retail Sales Analytics System
-- Author:  Data Science Portfolio Project
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

-- ─────────────────────────────────────────────
-- DIMENSION TABLES
-- ─────────────────────────────────────────────

CREATE TABLE dim_regions (
    region_id     INT AUTO_INCREMENT PRIMARY KEY,
    region_name   VARCHAR(50) NOT NULL,
    country       VARCHAR(50) NOT NULL,
    timezone      VARCHAR(50)
);

CREATE TABLE dim_categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_id     INT NULL,
    FOREIGN KEY (parent_id) REFERENCES dim_categories(category_id)
);

CREATE TABLE dim_customers (
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) UNIQUE NOT NULL,
    phone           VARCHAR(20),
    gender          ENUM('Male','Female','Other'),
    date_of_birth   DATE,
    city            VARCHAR(80),
    region_id       INT,
    registration_date DATE NOT NULL,
    customer_segment  ENUM('New','Regular','Premium','VIP') DEFAULT 'New',
    FOREIGN KEY (region_id) REFERENCES dim_regions(region_id)
);

CREATE TABLE dim_products (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    product_name  VARCHAR(200) NOT NULL,
    sku           VARCHAR(50) UNIQUE NOT NULL,
    category_id   INT NOT NULL,
    brand         VARCHAR(100),
    unit_cost     DECIMAL(10,2) NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    stock_qty     INT DEFAULT 0,
    is_active     BOOLEAN DEFAULT TRUE,
    launch_date   DATE,
    FOREIGN KEY (category_id) REFERENCES dim_categories(category_id)
);

CREATE TABLE dim_salesreps (
    rep_id        INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE,
    region_id     INT,
    hire_date     DATE,
    is_active     BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (region_id) REFERENCES dim_regions(region_id)
);

-- ─────────────────────────────────────────────
-- FACT TABLES
-- ─────────────────────────────────────────────

CREATE TABLE fact_orders (
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    rep_id          INT,
    order_date      DATETIME NOT NULL,
    ship_date       DATETIME,
    status          ENUM('Pending','Processing','Shipped','Delivered','Cancelled','Returned') DEFAULT 'Pending',
    payment_method  ENUM('Credit Card','Debit Card','UPI','Net Banking','COD','Wallet'),
    discount_pct    DECIMAL(5,2) DEFAULT 0.00,
    shipping_cost   DECIMAL(8,2) DEFAULT 0.00,
    total_amount    DECIMAL(12,2) NOT NULL,
    region_id       INT,
    FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),
    FOREIGN KEY (rep_id)      REFERENCES dim_salesreps(rep_id),
    FOREIGN KEY (region_id)   REFERENCES dim_regions(region_id)
);

CREATE TABLE fact_order_items (
    item_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    unit_cost     DECIMAL(10,2) NOT NULL,
    discount_amt  DECIMAL(10,2) DEFAULT 0.00,
    line_total    DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES fact_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
);

CREATE TABLE fact_returns (
    return_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    return_date   DATE NOT NULL,
    quantity      INT NOT NULL,
    reason        ENUM('Defective','Wrong Item','Not Satisfied','Damaged','Other'),
    refund_amount DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES fact_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
);

CREATE TABLE fact_inventory_log (
    log_id        INT AUTO_INCREMENT PRIMARY KEY,
    product_id    INT NOT NULL,
    log_date      DATE NOT NULL,
    opening_stock INT,
    units_sold    INT,
    units_returned INT DEFAULT 0,
    units_restocked INT DEFAULT 0,
    closing_stock INT,
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
);
