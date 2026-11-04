# Q001: Strict Numeric Boundary Filtering & Column Projection

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 001 / 200
- **Company Tag:** TCS, Infosys, Cognizant
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **`FROM` Phase**: The query engine accesses the `employees` table.
2. **`WHERE` Phase**: The predicate `salary > 60000` evaluates each row against the numeric boundary, filtering out all values $\le 60000$.
3. **`SELECT` Phase**: Only the 4 requested columns are projected into the final result set, avoiding unnecessary memory buffers.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Strict Inequality vs Inclusive Boundary (`>` vs `>=`)**:
   - The business requirement explicitly states *"strictly greater than 60,000"*. Using `>=` would incorrectly include Rajesh Kumar (`salary = 60000.00`), creating an audit discrepancy.
2. **The `SELECT *` Production Risk**:
   - In production tables containing 40+ columns, `SELECT *` forces the database engine to perform expensive disk reads and buffer pool bloat.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"In production environments, selecting explicit columns minimizes disk I/O and network payload, allowing the database query optimizer to leverage a **Covering Index (Index-Only Scan)** without reading the physical table pages. Furthermore, applying strict inequality (`> 60000`) guarantees that exact boundary matches such as 60,000.00 are excluded, strictly satisfying the compliance audit specification."*
