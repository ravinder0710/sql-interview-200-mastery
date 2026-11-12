# Q040: Conditional Aggregation & Loan Delinquency Tracking (`SUM(CASE WHEN ...)`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q040 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / FinTech Risk Analyst (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In commercial banking, retail lending, and FinTech risk management (e.g., HDFC Bank, Bajaj Finserv, CRED Lending), credit risk analysts continuously monitor branch-level loan portfolios. 

Risk leadership requires portfolio performance segmented across two fundamental operational states:
1. **Performing / Active Asset Volume**: Loans maintaining current standing (`loan_status = 'Current'`).
2. **At-Risk / Delinquent Volume**: Loans in default or overdue status (`loan_status = 'Delinquent'`).

Rather than generating separate reports, risk reporting dashboards demand a single aggregated row per branch featuring cross-tabulated metric columns (conditional aggregation / manual pivoting). Fully settled loans (`loan_status = 'Closed'`) must be excluded from open exposure calculations.

The Chief Risk Officer requires an audited branch exposure summary where:
1. Only open loans are evaluated (`loan_status IN ('Current', 'Delinquent')`).
2. Each branch displays total open loan counts, active performing amount, and delinquent amount.
3. Only branches carrying delinquent balances (`delinquent_amount > 0`) are retained.
4. Output is sorted by `delinquent_amount DESC, branch_name ASC`.

---

## 📊 Sample Mock Table: `loan_portfolio`

| loan_id | branch_name | borrower_id | loan_amount | loan_status |
|:---:|:---:|:---:|:---:|:---:|
| L101 | Mumbai-Andheri | BOR_501 | 500000.00 | Current |
| L102 | Mumbai-Andheri | BOR_502 | 150000.00 | Delinquent |
| L103 | Mumbai-Andheri | BOR_503 | 200000.00 | Closed |
| L104 | Bengaluru-Whitefield | BOR_504 | 800000.00 | Current |
| L105 | Bengaluru-Whitefield | BOR_505 | 350000.00 | Current |
| L106 | Delhi-CP | BOR_506 | 400000.00 | Current |
| L107 | Delhi-CP | BOR_507 | 250000.00 | Delinquent |
| L108 | Delhi-CP | BOR_508 | 100000.00 | Delinquent |
| L109 | Pune-Kothrud | BOR_509 | 300000.00 | Closed |

---

## 🎯 Expected Output Table

| branch_name | total_open_loans | active_current_amount | delinquent_amount |
|:---:|:---:|:---:|:---:|
| Delhi-CP | 3 | 400000.00 | 350000.00 |
| Mumbai-Andheri | 2 | 500000.00 | 150000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    branch_name, 
    COUNT(loan_id) AS total_open_loans, 
    SUM(CASE WHEN loan_status = 'Current' THEN loan_amount ELSE 0 END) AS active_current_amount, 
    SUM(CASE WHEN loan_status = 'Delinquent' THEN loan_amount ELSE 0 END) AS delinquent_amount 
FROM loan_portfolio 
WHERE loan_status IN ('Current', 'Delinquent') 
GROUP BY branch_name 
HAVING SUM(CASE WHEN loan_status = 'Delinquent' THEN loan_amount ELSE 0 END) > 0 
ORDER BY delinquent_amount DESC, branch_name ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Mechanics of Conditional Aggregation
- In standard SQL, wrapping a `CASE WHEN` statement inside an aggregate function (`SUM`, `COUNT`, `AVG`) evaluates conditions on individual records during group accumulation.
- For records matching `'Current'`, the loan amount is added to `active_current_amount`; for non-matching records, `0` is added, preserving running totals without nullification.

### 2. The Dangerous `COUNT(CASE WHEN ... ELSE 0 END)` Trap
- When conditionally counting occurrences, writing `COUNT(CASE WHEN cond THEN 1 ELSE 0 END)` is a catastrophic logic error:
  - `COUNT(expr)` increments for **any non-null value**, including `0`.
- **Correct Formulation**:
  ```sql
  -- Approach A: SUM of 1s and 0s
  SUM(CASE WHEN loan_status = 'Delinquent' THEN 1 ELSE 0 END)
  
  -- Approach B: COUNT omitting ELSE (defaults to NULL, which COUNT ignores)
  COUNT(CASE WHEN loan_status = 'Delinquent' THEN 1 END)
  ```

### 3. Modern SQL: The `FILTER` Clause
- PostgreSQL, DuckDB, and ANSI SQL:2003 support the cleaner `FILTER` syntax:
  ```sql
  SUM(loan_amount) FILTER (WHERE loan_status = 'Delinquent') AS delinquent_amount
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: PIVOT Operator vs `SUM(CASE WHEN ...)`
- **Interviewer Query:** *"Why use `SUM(CASE WHEN ...)` instead of database-native `PIVOT` operators?"*
- **Candidate Defense:**
  > *"`PIVOT` syntax is proprietary and varies widely between SQL Server, Oracle, and Snowflake, while being completely unsupported in MySQL and SQLite. `SUM(CASE WHEN ...)` is ANSI standard, portable across all relational engines, and allows computing multiple metrics (`COUNT`, `SUM`, ratios) simultaneously within a single query."*

### Trap 2: Excluding Closed Loans in `WHERE` vs `CASE WHEN`
- **Interviewer Query:** *"Why filter `loan_status IN ('Current', 'Delinquent')` in `WHERE` if the `CASE` statements already isolate those statuses?"*
- **Candidate Defense:**
  > *"Filtering in `WHERE` reduces the volume of rows fed into the grouping stage, saving hash table memory and CPU cycles. Furthermore, it ensures `COUNT(loan_id) AS total_open_loans` does not accidentally count closed loans."*
