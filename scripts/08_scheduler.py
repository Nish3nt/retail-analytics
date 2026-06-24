"""
08_scheduler.py

Automatically runs the full pipeline every Monday at 8:00 AM:
  Step 1  Validate data   (07_validate_data.py)
  Step 2  Generate Excel  (05_generate_excel.py)
  Step 3  Log the result

Two ways to use this:
  A) Run it manually once  it schedules itself using Windows Task Scheduler
  B) Just keep it running in background using: python scripts/08_scheduler.py

Usage:
    python scripts/08_scheduler.py
"""

import schedule
import time
import subprocess
import os
import logging
from datetime import datetime

#  LOGGING SETUP 
os.makedirs("logs", exist_ok=True)
logging.basicConfig(
    filename=f"logs/scheduler.log",
    level=logging.INFO,
    format="%(asctime)s  %(levelname)s  %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)
logging.getLogger().addHandler(console)

log = logging.getLogger(__name__)

#  PIPELINE 
def run_pipeline():
    log.info("=" * 55)
    log.info(" WEEKLY PIPELINE STARTED")
    log.info("=" * 55)

    steps = [
        ("Data Validation",    ["python", "scripts/07_validate_data.py"]),
        ("Excel Dashboard",    ["python", "scripts/05_generate_excel.py"]),
    ]

    all_ok = True
    for step_name, cmd in steps:
        log.info(f"  Running: {step_name} ")
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=300,   # 5 min max per step
            )
            if result.returncode == 0:
                log.info(f"    {step_name}  PASSED")
                if result.stdout.strip():
                    for line in result.stdout.strip().splitlines():
                        log.info(f"      {line}")
            else:
                log.error(f"    {step_name}  FAILED")
                log.error(f"      {result.stderr.strip()}")
                all_ok = False
        except subprocess.TimeoutExpired:
            log.error(f"    {step_name}  TIMED OUT after 5 minutes")
            all_ok = False
        except Exception as e:
            log.error(f"    {step_name}  ERROR: {e}")
            all_ok = False

    log.info("=" * 55)
    if all_ok:
        log.info(" PIPELINE COMPLETE  All steps passed")
    else:
        log.info("  PIPELINE COMPLETE  Some steps failed, check logs")
    log.info("=" * 55)


#  SCHEDULE 
def main():
    log.info(" Scheduler started  pipeline will run every Monday at 08:00")
    log.info("   Press Ctrl+C to stop\n")

    # Run every Monday at 08:00 AM
    schedule.every().monday.at("08:00").do(run_pipeline)

    # Also run immediately on first launch so you can test it
    log.info("  Running pipeline now for first-time test ")
    run_pipeline()

    while True:
        schedule.run_pending()
        time.sleep(60)   # check every minute


if __name__ == "__main__":
    main()