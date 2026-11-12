# Q032: Month-End Closing & Grace Period Due Date (`LAST_DAY`, `DATE_ADD`)

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q032 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / FinTech Operations Analyst (0–2 Years Experience)
- **Dialect Compatibility:** MySQL (`LAST_DAY`), Snowflake (`LAST_DAY`), SQL Server (`EOMONTH`), PostgreSQL (`DATE_TRUNC`)

---

## 🏢 Business Scenario
In retail banking and credit card payment systems (e.g., HDFC Bank, SBI Card, CRED, American Express), cardholder billing statements are generated periodically throughout the calendar month. 

However, banking accounting rules require two standardized milestones for financial settlements:
1. **Cycle Closing Date**: Every account's billing cycle formally snaps to the final calendar day of that billing month (`LAST_DAY`), regardless of whether the statement was generated on the 5th, 18th, or 25th.
2. **Grace Period Due Date**: Customers receive a mandatory 15-day interest-free grace window extending from the cycle closing date (`cycle_closing_date + 15 days`).

The Credit Card Operations team requires an audited settlement schedule of active cardholders whose statement balances exceed ₹5,000.00, ensuring proper month-end reconciliation even during leap years (e.g., February 2024 having 29 days).

---

## 📊 Sample Mock Table: `credit_billing_statements`

| statement_id | account_id | billing_date | billed_amount | account_status |
|:---:|:---:|:---:|:---:|:---:|
| 7001 | ACC_101 | 2024-01-12 | 14500.00 | Active |
| 7002 | ACC_102 | 2024-01-20 | 3200.00 | Active |
| 7003 | ACC_103 | 2024-02-05 | 28900.00 | Active |
| 7004 | ACC_104 | 2024-02-18 | 7500.00 | Dormant |
| 7005 | ACC_105 | 2024-02-25 | 18200.00 | Active |
| 7006 | ACC_106 | 2024-03-08 | 45000.00 | Active |
| 7007 | ACC_107 | 2024-03-15 | 2100.00 | Active |

---

## 🎯 Expected Output Table

| statement_id | account_id | billing_date | cycle_closing_date | payment_due_date | billed_amount |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 7006 | ACC_106 | 2024-03-08 | 2024-03-31 | 2024-04-15 | 45000.00 |
| 7003 | ACC_103 | 2024-02-05 | 2024-02-29 | 2024-03-15 | 28900.00 |
| 7005 | ACC_105 | 2024-02-25 | 2024-02-29 | 2024-03-15 | 18200.00 |
| 7001 | ACC_101 | 2024-01-12 | 2024-01-31 | 2024-02-15 | 14500.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    statement_id, 
    account_id, 
    billing_date, 
    LAST_DAY(billing_date) AS cycle_closing_date, 
    DATE_ADD(LAST_DAY(billing_date), INTERVAL 15 DAY) AS payment_due_date, 
    billed_amount 
FROM credit_billing_statements 
WHERE account_status = 'Active' 
  AND billed_amount >= 5000.00 
ORDER BY cycle_closing_date DESC, statement_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Robust Leap Year Handling with `LAST_DAY()`
- Hardcoded addition of 30 days fails because calendar months vary between 28, 29, 30, and 31 days.
- In leap years like 2024, `LAST_DAY('2024-02-05')` natively yields `'2024-02-29'`. In non-leap years (e.g., 2023), it yields `'2023-02-28'`.

### 2. Nested Temporal Functions
- In MySQL, `DATE_ADD(LAST_DAY(billing_date), INTERVAL 15 DAY)` nests the month-end resolution directly as the base date for interval addition, avoiding multi-step CTE overhead.

### 3. Cross-Dialect Equivalents
- **SQL Server (T-SQL)**:
  ```sql
  EOMONTH(billing_date) AS cycle_closing_date,
  DATEADD(day, 15, EOMONTH(billing_date)) AS payment_due_date
  ```
- **PostgreSQL**:
  ```sql
  (DATE_TRUNC('month', billing_date) + INTERVAL '1 month - 1 day')::DATE AS cycle_closing_date,
  ((DATE_TRUNC('month', billing_date) + INTERVAL '1 month - 1 day') + INTERVAL '15 days')::DATE AS payment_due_date
  ```
- **Snowflake & BigQuery**:
  ```sql
  LAST_DAY(billing_date) AS cycle_closing_date,
  DATEADD('day', 15, LAST_DAY(billing_date)) AS payment_due_date
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Manual 30-Day Addition vs Engine Calendar Logic
- **Interviewer Query:** *"Why not just add 30 days to `billing_date`?"*
- **Candidate Defense:**
  > *"Adding fixed 30-day offsets introduces calendar drift across short months (February) and 31-day months (January, March). Financial compliance demands that credit card statements close on the exact statutory last day of the calendar month, which only engine-level calendar functions (`LAST_DAY` / `EOMONTH`) guarantee."*

### Trap 2: Banking Holiday & Weekend Roll-Forward
- **Interviewer Query:** *"What if the 15th grace day falls on a Sunday or National Bank Holiday?"*
- **Candidate Defense:**
  > *"Under retail banking clearing rules (e.g., RBI / NACH / ACH guidelines), if a calculated payment due date coincides with a non-clearing weekend (`DAYOFWEEK IN (1, 7)`), the due date rolls forward to the next statutory business day (Monday). In enterprise analytics architectures, this is handled by joining with an enterprise Bank Holiday calendar dimension table."*
