"""
06_generate_data.py
════════════════════════════════════════════════════════════════
Generates 1000+ realistic retail orders and inserts into MySQL.
Run ONCE after your seed data is loaded.

Usage:
    python scripts/06_generate_data.py
"""

import mysql.connector
import random
from datetime import datetime, timedelta
#from dotenv import load_dotenv
#import os

#load_dotenv(override=True, encoding='utf-8')

DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "Admin@123",
    "database": "retail_analytics",
}

# ── CONSTANTS ──────────────────────────────────────────────────────────────
TOTAL_ORDERS      = 1200   # target number of new orders
CUSTOMER_IDS      = list(range(1, 31))     # 30 customers
REP_IDS           = list(range(1, 9))      # 8 reps
REGION_IDS        = list(range(1, 6))      # 5 regions
PAYMENT_METHODS   = [
    "Credit Card", "Debit Card", "UPI",
    "Net Banking", "COD", "Wallet"
]
PAYMENT_WEIGHTS   = [35, 15, 30, 10, 8, 2]   # realistic distribution

ORDER_STATUSES    = ["Delivered", "Delivered", "Delivered",
                     "Delivered", "Shipped", "Processing",
                     "Cancelled", "Returned"]   # weighted toward Delivered

# Product catalogue: (product_id, unit_price, unit_cost)
PRODUCTS = [
    (1,  28999, 18000), (2,  79999, 55000), (3,  22999, 15000),
    (4,  52999, 35000), (5,  62999, 40000), (6,  47999, 32000),
    (7,   1799,   800), (8,   8499,  4500), (9,   1499,   600),
    (10,  2999,  1200), (11,  1799,   700), (12,  2299,   900),
    (13,  7499,  4000), (14,  9999,  5500), (15, 10999,  6000),
    (16, 14999,  8000), (17,  5999,  2500), (18,  1999,   800),
    (19,   499,   150), (20,   799,   350),
]

# Seasonal multipliers by month (1=Jan … 12=Dec)
# Higher in festive months: Oct(Diwali), Nov(sale), Dec(Christmas/NY)
SEASONAL = {
    1:0.7, 2:0.7, 3:0.8, 4:0.8, 5:0.9, 6:0.9,
    7:0.8, 8:0.9, 9:1.0, 10:1.4, 11:1.5, 12:1.3
}

# ── HELPERS ────────────────────────────────────────────────────────────────
def random_date(start: datetime, end: datetime) -> datetime:
    delta = end - start
    return start + timedelta(seconds=random.randint(0, int(delta.total_seconds())))

def seasonal_order_count(month: int, base: int = 80) -> int:
    return max(1, int(base * SEASONAL[month] + random.gauss(0, 5)))

def pick_products() -> list:
    """Return 1–4 products for an order with realistic quantities."""
    n = random.choices([1, 2, 3, 4], weights=[60, 25, 10, 5])[0]
    chosen = random.sample(PRODUCTS, n)
    items = []
    for pid, price, cost in chosen:
        qty = random.choices([1, 2, 3], weights=[75, 20, 5])[0]
        discount_pct = random.choices(
            [0, 5, 10, 15, 20], weights=[50, 20, 15, 10, 5]
        )[0]
        discount_amt = round(price * qty * discount_pct / 100, 2)
        line_total   = round(price * qty - discount_amt, 2)
        items.append((pid, qty, price, cost, discount_amt, line_total))
    return items

# ── MAIN ───────────────────────────────────────────────────────────────────
def main():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    print("🔄 Generating 1200 realistic orders …")

    START = datetime(2022, 1, 1)
    END   = datetime(2024, 12, 31)

    orders_inserted = 0
    items_inserted  = 0

    for _ in range(TOTAL_ORDERS):
        # Random order datetime
        order_dt = random_date(START, END)
        ship_dt  = order_dt + timedelta(days=random.randint(2, 7))
        status   = random.choice(ORDER_STATUSES)
        payment  = random.choices(PAYMENT_METHODS, weights=PAYMENT_WEIGHTS)[0]
        cust_id  = random.choice(CUSTOMER_IDS)
        rep_id   = random.choice(REP_IDS)
        region_id= random.choice(REGION_IDS)
        discount = round(random.choices([0,5,10,15,20],
                                        weights=[50,20,15,10,5])[0], 2)
        shipping = 0.0 if payment != "COD" else 99.0
        items    = pick_products()
        total    = round(sum(i[5] for i in items) + shipping, 2)

        # Insert order
        cursor.execute("""
            INSERT INTO fact_orders
              (customer_id, rep_id, order_date, ship_date, status,
               payment_method, discount_pct, shipping_cost, total_amount, region_id)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (cust_id, rep_id, order_dt, ship_dt, status,
              payment, discount, shipping, total, region_id))

        order_id = cursor.lastrowid
        orders_inserted += 1

        # Insert order items
        for pid, qty, price, cost, disc_amt, line_total in items:
            cursor.execute("""
                INSERT INTO fact_order_items
                  (order_id, product_id, quantity, unit_price,
                   unit_cost, discount_amt, line_total)
                VALUES (%s,%s,%s,%s,%s,%s,%s)
            """, (order_id, pid, qty, price, cost, disc_amt, line_total))
            items_inserted += 1

        # Commit every 100 orders for performance
        if orders_inserted % 100 == 0:
            conn.commit()
            print(f"   ✅ {orders_inserted} orders inserted …")

    conn.commit()
    cursor.close()
    conn.close()

    print(f"\n🎉 Done!")
    print(f"   Orders inserted : {orders_inserted}")
    print(f"   Items inserted  : {items_inserted}")
    print(f"   Total orders in DB will be ~{orders_inserted + 50}")

if __name__ == "__main__":
    main()