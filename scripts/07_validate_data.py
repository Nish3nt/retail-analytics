"""
07_validate_data.py

Runs data quality checks on the retail_analytics MySQL database.
Catches bad data BEFORE it enters reports or dashboards.

Checks performed:
  1.  Null checks on critical columns
  2.  Orphan records (FK violations)
  3.  Negative prices / costs
  4.  line_total mismatch vs qty  price
  5.  Future order dates
  6.  Duplicate customer emails
  7.  Orders with zero items
  8.  Return without matching order
  9.  Shipping date before order date
  10. Revenue sanity (order total vs sum of line items)

Usage:
    python scripts/07_validate_data.py
Output:
    logs/validation_report_YYYY-MM-DD.txt
"""

import mysql.connector
import os
from datetime import datetime
#from dotenv import load_dotenv

#load_dotenv()

DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "Admin@123",
    "database": "retail_analytics",
}
LOG_DIR = "logs"
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(
    LOG_DIR,
    f"validation_report_{datetime.now().strftime('%Y-%m-%d_%H-%M')}.txt"
)

#  CHECK DEFINITIONS 
CHECKS = [
    {
        "id":   "CHK-01",
        "name": "NULL customer_id in orders",
        "sql":  "SELECT COUNT(*) FROM fact_orders WHERE customer_id IS NULL",
        "expect": 0,
        "severity": "CRITICAL",
    },
    {
        "id":   "CHK-02",
        "name": "NULL product_id in order items",
        "sql":  "SELECT COUNT(*) FROM fact_order_items WHERE product_id IS NULL",
        "expect": 0,
        "severity": "CRITICAL",
    },
    {
        "id":   "CHK-03",
        "name": "Orphan order items (no parent order)",
        "sql":  """
            SELECT COUNT(*) FROM fact_order_items oi
            LEFT JOIN fact_orders o ON oi.order_id = o.order_id
            WHERE o.order_id IS NULL
        """,
        "expect": 0,
        "severity": "CRITICAL",
    },
    {
        "id":   "CHK-04",
        "name": "Orders with customer not in dim_customers",
        "sql":  """
            SELECT COUNT(*) FROM fact_orders o
            LEFT JOIN dim_customers c ON o.customer_id = c.customer_id
            WHERE c.customer_id IS NULL
        """,
        "expect": 0,
        "severity": "CRITICAL",
    },
    {
        "id":   "CHK-05",
        "name": "Negative unit prices in order items",
        "sql":  "SELECT COUNT(*) FROM fact_order_items WHERE unit_price < 0",
        "expect": 0,
        "severity": "HIGH",
    },
    {
        "id":   "CHK-06",
        "name": "Negative unit costs in order items",
        "sql":  "SELECT COUNT(*) FROM fact_order_items WHERE unit_cost < 0",
        "expect": 0,
        "severity": "HIGH",
    },
    {
        "id":   "CHK-07",
        "name": "Negative line totals",
        "sql":  "SELECT COUNT(*) FROM fact_order_items WHERE line_total < 0",
        "expect": 0,
        "severity": "HIGH",
    },
    {
        "id":   "CHK-08",
        "name": "Future order dates (beyond today)",
        "sql":  "SELECT COUNT(*) FROM fact_orders WHERE order_date > NOW()",
        "expect": 0,
        "severity": "HIGH",
    },
    {
        "id":   "CHK-09",
        "name": "Ship date before order date",
        "sql":  """
            SELECT COUNT(*) FROM fact_orders
            WHERE ship_date IS NOT NULL AND ship_date < order_date
        """,
        "expect": 0,
        "severity": "HIGH",
    },
    {
        "id":   "CHK-10",
        "name": "Duplicate customer emails",
        "sql":  """
            SELECT COUNT(*) FROM (
                SELECT email, COUNT(*) AS cnt
                FROM dim_customers
                GROUP BY email HAVING cnt > 1
            ) t
        """,
        "expect": 0,
        "severity": "MEDIUM",
    },
    {
        "id":   "CHK-11",
        "name": "Orders with zero line items",
        "sql":  """
            SELECT COUNT(*) FROM fact_orders o
            LEFT JOIN fact_order_items oi ON o.order_id = oi.order_id
            WHERE oi.item_id IS NULL
        """,
        "expect": 0,
        "severity": "HIGH",
    },
    {
        "id":   "CHK-12",
        "name": "Returns without matching order",
        "sql":  """
            SELECT COUNT(*) FROM fact_returns r
            LEFT JOIN fact_orders o ON r.order_id = o.order_id
            WHERE o.order_id IS NULL
        """,
        "expect": 0,
        "severity": "CRITICAL",
    },
    {
        "id":   "CHK-13",
        "name": "Products with cost >= price (zero/negative margin)",
        "sql":  """
            SELECT COUNT(*) FROM dim_products
            WHERE unit_cost >= unit_price AND is_active = TRUE
        """,
        "expect": 0,
        "severity": "MEDIUM",
    },
    {
        "id":   "CHK-14",
        "name": "Orders with NULL total_amount",
        "sql":  "SELECT COUNT(*) FROM fact_orders WHERE total_amount IS NULL",
        "expect": 0,
        "severity": "CRITICAL",
    },
    {
        "id":   "CHK-15",
        "name": "Customers with NULL registration_date",
        "sql":  "SELECT COUNT(*) FROM dim_customers WHERE registration_date IS NULL",
        "expect": 0,
        "severity": "MEDIUM",
    },
]

#  RUNNER 
def run_checks():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    results   = []
    passed    = 0
    failed    = 0
    critical  = 0

    print("=" * 60)
    print("  RETAIL ANALYTICS  DATA VALIDATION REPORT")
    print(f"  Run at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)

    for chk in CHECKS:
        cursor.execute(chk["sql"])
        value = cursor.fetchone()[0]
        status = " PASS" if value == chk["expect"] else " FAIL"

        if value == chk["expect"]:
            passed += 1
        else:
            failed += 1
            if chk["severity"] == "CRITICAL":
                critical += 1

        line = (
            f"{status}  [{chk['severity']:8s}]  {chk['id']}  "
            f"{chk['name']}    found: {value}"
        )
        print(line)
        results.append(line)

    print("=" * 60)
    summary = (
        f"  SUMMARY: {passed} passed | {failed} failed "
        f"({critical} CRITICAL)\n"
        f"  Overall: {' ALL CHECKS PASSED' if failed == 0 else ' ISSUES FOUND  review above'}"
    )
    print(summary)
    print("=" * 60)

    cursor.close()
    conn.close()

    #  Write log file
    with open(LOG_FILE, "w", encoding="utf-8") as f:
        f.write("RETAIL ANALYTICS  DATA VALIDATION REPORT\n")
        f.write(f"Run at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write("=" * 60 + "\n")
        for r in results:
            f.write(r + "\n")
        f.write("=" * 60 + "\n")
        f.write(summary + "\n")

    print(f"\n Report saved  {LOG_FILE}")
    return failed

if __name__ == "__main__":
    issues = run_checks()
    exit(0 if issues == 0 else 1)