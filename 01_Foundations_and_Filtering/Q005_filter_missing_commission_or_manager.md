# Q005: Handling Missing Data (IS NULL) & Operator Precedence (AND over OR)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 005 / 150
- **Company Tag:** Infosys / Wipro / Payroll Compliance Audits
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
The HR payroll audit team requires a list of active sales representatives (`is_active = TRUE`) with a base salary of at least 50,000 (`salary >= 50000`) who have missing information in either their commission percentage (`commission_pct IS NULL`) or their reporting manager ID (`manager_id IS NULL`). 

This audit report is critical to resolve missing incentive metrics and broken reporting lines prior to monthly payroll disbursement.

---

## 📊 Sample Mock Table (`sales_reps`)

| rep_id | rep_name | salary | commission_pct | manager_id | is_active |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 401 | Rohan Mehra | 65000.00 | NULL | 10 | TRUE |
| 402 | Simran Kaur | 55000.00 | 0.15 | NULL | TRUE |
| 403 | Deepak Verma | 42000.00 | NULL | NULL | TRUE |
| 404 | Neha Sharma | 70000.00 | 0.10 | 12 | TRUE |
| 405 | Kabir Khan | 58000.00 | NULL | 10 | FALSE |
| 406 | Divya Rao | 50000.00 | NULL | NULL | TRUE |
| 407 | Rahul Joshi | 80000.00 | 0.20 | 10 | TRUE |

---

## 🎯 Expected Output Table

| rep_id | rep_name | salary | commission_pct | manager_id |
| :--- | :--- | :--- | :--- | :--- |
| 401 | Rohan Mehra | 65000.00 | NULL | 10 |
| 402 | Simran Kaur | 55000.00 | 0.15 | NULL |
| 406 | Divya Rao | 50000.00 | NULL | NULL |

---

## 💡 Production SQL Solution

```sql
SELECT 
    rep_id, 
    rep_name, 
    salary, 
    commission_pct, 
    manager_id 
FROM sales_reps 
WHERE salary >= 50000 
  AND is_active = TRUE 
  AND (commission_pct IS NULL OR manager_id IS NULL);
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Operator Precedence (AND over OR)**:
   - In standard SQL logical processing, `AND` evaluates prior to `OR`.
   - Without parentheses around `(commission_pct IS NULL OR manager_id IS NULL)`, the filter decomposes to `(salary >= 50000 AND is_active = TRUE AND commission_pct IS NULL) OR manager_id IS NULL`. This defect introduces low-salary or inactive employees into the output whenever `manager_id` is NULL.

2. **Three-Valued Logic & Equality with NULL**:
   - `column = NULL` is invalid because NULL represents an unknown state rather than a concrete value; `NULL = NULL` evaluates to `UNKNOWN` (treated as FALSE in a WHERE filter).
   - Use explicit predicate `IS NULL` or `IS NOT NULL`.

3. **Index Behavior on Nullable Columns**:
   - PostgreSQL and SQL Server index NULL entries within B-Tree indexes.
   - Oracle B-Trees do not index rows where all indexed columns are NULL, requiring bitmap indexes or composite indexes with non-null constants.
