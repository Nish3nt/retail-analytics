# 🛒 Retail Analytics — MySQL + Excel Project

An industry-grade end-to-end retail analytics system using **MySQL** for data storage and **Python + Excel** for reporting.

---
## 📸 Dashboard Preview

### KPI Cards & Monthly Table
![KPI Dashboard](""C:\Users\diwat\OneDrive\Pictures\dashboard_chart.png"")

### Monthly Revenue vs Profit Chart
![Revenue Chart]("C:\Users\diwat\OneDrive\Pictures\dashboard_chart.png")
## 📁 File Guide

| File | Description |
|------|-------------|
| `01_create_database.sql` | Full schema — dimensions, facts, relationships |
| `02_seed_data.sql` | 30 customers, 20 products, 50 orders, 5 regions |
| `03_analytics_queries.sql` | 10 business analytics queries (CLV, RFM, YoY, etc.) |
| `04_stored_procedures.sql` | 4 stored procedures for reporting |
| `05_generate_excel.py` | Python pipeline: MySQL → formatted Excel dashboard |
| `retail_analytics_dashboard.xlsx` | Pre-built Excel dashboard (demo data) |

---

## 🗄️ Database Schema

```
dim_regions         → 5 Indian regions
dim_categories      → Parent + sub-categories (14 total)
dim_customers       → 30 customers with segments (New/Regular/Premium/VIP)
dim_products        → 20 products across 6 categories
dim_salesreps       → 8 sales reps across regions

fact_orders         → 50 orders (2023–2024)
fact_order_items    → Line items per order
fact_returns        → Return & refund tracking
fact_inventory_log  → Daily stock movement
```

---

## 📊 Excel Dashboard Sheets

| Sheet | Contents |
|-------|----------|
| 📊 Dashboard | KPI cards + monthly revenue chart |
| 📅 Monthly Trends | 24-month revenue, profit, margin |
| 📦 Top Products | Top 10 by revenue with margin |
| 🌍 Regional Sales | Revenue breakdown by region |
| 👥 Sales Reps | Rep leaderboard with profit |
| 🗂️ Categories | Parent + sub-category analysis |
| 👤 Customer CLV | Top 10 customers by lifetime value |
| 💳 Payments | Payment method distribution + pie chart |
| 📈 YoY Growth | 2023 vs 2024 revenue comparison |

---

## ⚙️ Setup Instructions

### 1. MySQL Setup
```sql
-- Run in order:
mysql -u root -p < 01_create_database.sql
mysql -u root -p < 02_seed_data.sql
```

### 2. Run Analytics Queries
```sql
mysql -u root -p retail_analytics < 03_analytics_queries.sql
```

### 3. Generate Excel Report
```bash
pip install mysql-connector-python pandas openpyxl

# Update DB credentials in 05_generate_excel.py, then:
python 05_generate_excel.py
```

---

## 🧠 Analytics Covered

- Monthly Revenue, COGS & Gross Profit
- Top 10 Products by Revenue & Margin
- Customer Lifetime Value (CLV)
- RFM Segmentation (Recency, Frequency, Monetary)
- Sales Rep Performance Leaderboard
- Regional Sales Breakdown
- Category & Sub-category Analysis
- Payment Method Distribution
- Return Rate Analysis
- Year-over-Year Growth (with LAG window function)
