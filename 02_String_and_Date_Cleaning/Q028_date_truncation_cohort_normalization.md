# Q028: Date Truncation & Cohort Month Normalization

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q028 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL (`DATE_TRUNC`), Snowflake, SQL Server

---

## 🏢 Business Scenario
In SaaS and digital media subscription platforms (e.g., Netflix, Spotify, Disney+ Hotstar), users subscribe, upgrade, and renew across random days of the calendar month (e.g., 2024-01-18, 2024-02-27, 2024-03-22). 

However, customer retention, churn modeling, and cohort lifecycle analytics require all events occurring within the same calendar month to be collapsed into a standardized monthly anchor date: the **1st day of the transaction month** (`YYYY-MM-01`).

The Financial Planning & Analytics (FP&A) team requires an audited extract of successful subscription revenues where:
1. The transaction status is `'Success'`.
2. The subscription plan is recurring (`'Monthly'` or `'Annual'`).
3. The transaction amount meets or exceeds ₹500.00.
4. Each record displays a normalized `cohort_month` column for downstream Power BI date table relationships.

---

## 📊 Sample Mock Table: `subscription_payments`

| payment_id | customer_id | payment_date | plan_name | payment_status | amount_paid |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 101 | CUST_701 | 2024-01-18 | Annual | Success | 1499.00 |
| 102 | CUST_702 | 2024-01-05 | Monthly | Failed | 299.00 |
| 103 | CUST_703 | 2024-02-27 | Monthly | Success | 599.00 |
| 104 | CUST_704 | 2024-02-14 | Weekly | Success | 199.00 |
| 105 | CUST_705 | 2024-03-01 | Annual | Success | 1999.00 |
| 106 | CUST_706 | 2024-03-22 | Monthly | Success | 699.00 |
| 107 | CUST_707 | 2024-03-31 | Quarterly | Success | 899.00 |

---

## 🎯 Expected Output Table

| payment_id | customer_id | payment_date | cohort_month | plan_name | amount_paid |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 105 | CUST_705 | 2024-03-01 | 2024-03-01 | Annual | 1999.00 |
| 106 | CUST_706 | 2024-03-22 | 2024-03-01 | Monthly | 699.00 |
| 103 | CUST_703 | 2024-02-27 | 2024-02-01 | Monthly | 599.00 |
| 101 | CUST_701 | 2024-01-18 | 2024-01-01 | Annual | 1499.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    payment_id,
    customer_id,
    payment_date,
    DATE_FORMAT(payment_date, '%Y-%m-01') AS cohort_month,
    plan_name,
    amount_paid
FROM subscription_payments
WHERE payment_status = 'Success'
  AND amount_paid >= 500.00
  AND plan_name IN ('Monthly', 'Annual')
ORDER BY cohort_month DESC, payment_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Mechanics of First-of-Month Normalization
- `DATE_FORMAT(payment_date, '%Y-%m-01')`: Extracts the 4-digit year (`%Y`) and 2-digit zero-padded month (`%m`), while substituting a static `'01'` as the day literal.
- This effectively collapses timestamps like `2024-03-01`, `2024-03-22`, and `2024-03-31` into a unified partition key: `2024-03-01`.

### 2. Preserving Native DATE Type vs String Casting
- `DATE_FORMAT` returns a string representation (`VARCHAR`). While acceptable in MySQL queries, analytical data pipelines often mandate preserving native `DATE` objects.
- **Pure Date Math (MySQL)**:
  ```sql
  DATE_SUB(payment_date, INTERVAL DAY(payment_date) - 1 DAY)
  ```
  Subtracting `(current_day - 1)` days directly returns the 1st of the month as a native `DATE` type without string coercion.

### 3. Cross-Dialect Equivalents
- **PostgreSQL / Snowflake / BigQuery**:
  ```sql
  DATE_TRUNC('month', payment_date)
  ```
- **SQL Server (T-SQL)**:
  ```sql
  DATEFROMPARTS(YEAR(payment_date), MONTH(payment_date), 1)
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Truncating to Year-Month String (`YYYY-MM`) vs Year-Month-01 Date (`YYYY-MM-01`)
- **Interviewer Query:** *"Why normalize to `YYYY-MM-01` instead of simply grouping by `'2024-03'`?"*
- **Candidate Defense:** 
  > *"Grouping by `'2024-03'` creates a text string rather than a true temporal dimension. Downstream Business Intelligence tools (Power BI, Tableau) require valid date hierarchies to join against an enterprise Date/Calendar dimension table. Having `'YYYY-MM-01'` ensures active calendar joins, enabling DAX time intelligence functions like `SAMEPERIODLASTYEAR` and `DATESMTD`."*

### Trap 2: Operator Precedence with `OR` vs `IN`
- **Interviewer Query:** *"What happens if a candidate writes `WHERE plan_name = 'Monthly' OR plan_name = 'Annual' AND payment_status = 'Success'`?"*
- **Candidate Defense:**
  > *"Because `AND` has higher operator precedence than `OR`, SQL evaluates `(plan_name = 'Annual' AND payment_status = 'Success')` first, and treats `plan_name = 'Monthly'` as an independent clause. This leaks failed monthly payments into the output. Using `plan_name IN ('Monthly', 'Annual')` avoids ambiguity and strictly bounds the conditions."*
