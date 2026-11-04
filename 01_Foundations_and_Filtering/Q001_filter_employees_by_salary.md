# Q001: Strict Numeric Boundary Filtering & Column Projection

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 001 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
During an annual HR compensation audit, the payroll and finance teams require a standardized report of all employees earning a monthly salary strictly greater than 60,000 to review upper tax bracket withholding. Only business-critical attributes (`emp_id`, `emp_name`, `department`, `salary`) must be fetched.

---

## 📊 Sample Mock Table (`employees`)

| emp_id | emp_name | department | salary | joining_date |
| :---: | :--- | :--- | :---: | :---: |
| 101 | Amit Sharma | IT | 75000.00 | 2022-03-15 |
| 102 | Priya Verma | HR | 52000.00 | 2023-01-10 |
| 103 | Rajesh Kumar | Finance | 60000.00 | 2021-07-20 |
| 104 | Sneha Patel | IT | 92000.00 | 2020-11-05 |
| 105 | Rohit Gupta | Marketing | 48000.00 | 2023-06-12 |
| 106 | Ananya Roy | Finance | 68000.00 | 2022-09-01 |

---

## 🎯 Expected Output

| emp_id | emp_name | department | salary |
| :---: | :--- | :--- | :---: |
| 101 | Amit Sharma | IT | 75000.00 |
| 104 | Sneha Patel | IT | 92000.00 |
| 106 | Ananya Roy | Finance | 68000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    emp_id, 
    emp_name, 
    department, 
    salary 
FROM employees 
WHERE salary > 60000;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why Explicit Column Projection over `SELECT *`?**
   - In production tables containing 40+ columns, `SELECT *` forces expensive disk I/O, network latency, and memory buffer bloat.
   - Specifying required columns allows the query optimizer to utilize a **Covering Index (Index-Only Scan)** directly from the B-Tree index pages without touching physical table blocks.

2. **Strict Inequality vs Inclusive Boundary:**
   - The condition `salary > 60000` guarantees strict threshold filtering, excluding boundary values such as 60,000.00.
   - If the business asks for "at least 60,000", then `>=` is required. Precision in choosing `>` vs `>=` prevents payroll audit discrepancies.

3. **SQL Query Processing Lifecycle:**
   - SQL queries do not execute top-to-bottom. The logical execution order is:
     $$\mathbf{FROM} \longrightarrow \mathbf{WHERE} \longrightarrow \mathbf{SELECT}$$
   - The engine first locates the table, filters rows in memory, and only projects the required columns at the final step.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Production Use of `SELECT *`:**
   - *Interviewer:* "Why not just write `SELECT *` if you want to quickly see all employee details in the report?"
   - *Defense:* In enterprise databases with millions of rows, `SELECT *` bypasses index-only scans, inflates network payload, and breaks downstream applications if new schema columns are added later. Always project explicit columns.

2. **Trap: Boundary Value Matching:**
   - *Interviewer:* "An employee earns exactly 60,000. Does your query include or exclude them?"
   - *Defense:* It strictly excludes them. The `>` operator filters out exact boundary matches. If the requirement was '60,000 and above', we would use `>= 60000`.
