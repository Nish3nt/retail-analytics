# Power BI Dashboard — Setup Guide
## Retail Analytics — MySQL Connection

---

## What You Will Build in Power BI

| Sheet | Visuals |
|---|---|
| Overview | KPI cards — Revenue, Orders, Profit, Margin |
| Sales Trends | Line chart — Monthly Revenue & Profit |
| Products | Bar chart — Top 10 Products by Revenue |
| Regions | Map + Bar — Sales by Region |
| Customers | Table — CLV, RFM Segments |
| Sales Reps | Bar — Leaderboard |

---

## STEP 1 — Install Power BI Desktop (Free)

1. Go to: https://powerbi.microsoft.com/downloads
2. Click **"Download free"**
3. Install it (takes ~5 minutes)

---

## STEP 2 — Install MySQL Connector for Power BI

Power BI needs a connector to talk to MySQL.

1. Go to: https://dev.mysql.com/downloads/connector/net/
2. Download **MySQL Connector/NET**
3. Install it
4. **Restart Power BI** after installing

---

## STEP 3 — Connect Power BI to MySQL

1. Open **Power BI Desktop**
2. Click **"Get Data"** (Home tab)
3. Search **"MySQL"** → Select **MySQL database** → Click **Connect**
4. Fill in:
```
Server:   localhost
Database: retail_analytics
```
5. Click **OK**
6. Enter credentials:
```
Username: root
Password: Admin@123
```
7. Click **Connect**

---

## STEP 4 — Load These Tables

In the Navigator window, check these tables:

```
☑ fact_orders
☑ fact_order_items
☑ dim_customers
☑ dim_products
☑ dim_categories
☑ dim_regions
☑ dim_salesreps
☑ fact_returns
```

Click **"Load"**

---

## STEP 5 — Create Relationships (Auto or Manual)

Power BI may auto-detect relationships. If not, go to:
**Model view** (left sidebar icon) and create:

```
fact_orders.customer_id  →  dim_customers.customer_id
fact_orders.region_id    →  dim_regions.region_id
fact_orders.rep_id       →  dim_salesreps.rep_id
fact_order_items.order_id   →  fact_orders.order_id
fact_order_items.product_id →  dim_products.product_id
dim_products.category_id    →  dim_categories.category_id
fact_returns.order_id    →  fact_orders.order_id
```

---

## STEP 6 — Create Measures (DAX Formulas)

Go to **Home → New Measure** and create these one by one:

### Total Revenue
```dax
Total Revenue = SUM(fact_order_items[line_total])
```

### Total Profit
```dax
Total Profit = 
SUMX(
    fact_order_items,
    fact_order_items[line_total] - 
    (fact_order_items[unit_cost] * fact_order_items[quantity])
)
```

### Gross Margin %
```dax
Gross Margin % = 
DIVIDE([Total Profit], [Total Revenue], 0) * 100
```

### Total Orders
```dax
Total Orders = DISTINCTCOUNT(fact_orders[order_id])
```

### Avg Order Value
```dax
Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
```

### YoY Revenue Growth %
```dax
YoY Growth % = 
VAR CurrentYear = [Total Revenue]
VAR PrevYear = CALCULATE(
    [Total Revenue],
    DATEADD(fact_orders[order_date], -1, YEAR)
)
RETURN DIVIDE(CurrentYear - PrevYear, PrevYear, 0) * 100
```

### Return Rate %
```dax
Return Rate % = 
DIVIDE(
    COUNTROWS(fact_returns),
    [Total Orders],
    0
) * 100
```

---

## STEP 7 — Build the Dashboard Pages

### Page 1: Overview
- Add 4 **Card** visuals: Total Revenue, Total Orders, Gross Margin %, Avg Order Value
- Add 1 **Line chart**: Axis = order_date (Month), Values = Total Revenue, Total Profit
- Add 1 **Donut chart**: payment_method vs Total Orders

### Page 2: Products
- Add 1 **Bar chart**: product_name vs Total Revenue (Top 10 filter)
- Add 1 **Table**: product_name, units sold, revenue, profit, margin %
- Add 1 **Treemap**: category_name vs Total Revenue

### Page 3: Regions
- Add 1 **Bar chart**: region_name vs Total Revenue
- Add 1 **Table**: region, orders, revenue, avg order value

### Page 4: Customers
- Add 1 **Table**: customer name, segment, total orders, lifetime value
- Add 1 **Bar chart**: customer_segment vs Total Revenue
- Add 1 **Scatter plot**: X = total orders, Y = lifetime value, Legend = segment

### Page 5: Sales Reps
- Add 1 **Bar chart**: sales_rep vs Total Revenue
- Add 1 **Table**: rep name, region, deals closed, revenue, profit

---

## STEP 8 — Add Slicers (Filters)

Add these slicers on every page:
- **Year** slicer (from order_date)
- **Region** slicer (from dim_regions)
- **Category** slicer (from dim_categories)

---

## STEP 9 — Style the Dashboard

1. Go to **View → Themes** → Pick a professional theme
2. Set background color: `#1F3864` (dark blue) for header
3. Use consistent colors:
   - Revenue: Blue `#2E75B6`
   - Profit: Green `#70AD47`
   - Loss/Returns: Red `#FF0000`

---

## STEP 10 — Save and Export

1. **Save** as `retail_analytics.pbix` in your `powerbi/` folder
2. To share: **File → Export → Export to PDF** for a static version
3. To publish online (free): **File → Publish → Publish to Power BI** (needs free account at powerbi.microsoft.com)

---

## Add to GitHub

After saving the .pbix file:
```bash
git add powerbi/retail_analytics.pbix
git commit -m "Add Power BI dashboard"
git push
```

---

## Final Dashboard Will Look Like

```
┌─────────────────────────────────────────────────┐
│  💰 ₹14.3L    📦 1250    📈 42%    🏆 North     │  ← KPI Cards
├─────────────────────────────────────────────────┤
│  Monthly Revenue vs Profit (Line Chart)          │
│  ▁▂▄█▆▃▂▄▆█▇▅  ←─ trend line                  │
├──────────────┬──────────────────────────────────┤
│ Top Products │  Regional Sales Map               │
│ (Bar Chart)  │  (Bar Chart)                      │
└──────────────┴──────────────────────────────────┘
```

---

## Tip for Resume

Add this to your resume:
> Built interactive Power BI dashboard connected live to MySQL database
> with DAX measures for CLV, YoY growth, and margin analysis
> across 1250+ orders, 30 customers, 5 regions
