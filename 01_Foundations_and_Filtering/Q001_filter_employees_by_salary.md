# Q001: Strict Numeric Boundary Filtering & Column Projection

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 001 / 150
- **Company Tag:** TCS / Infosys / Cognizant / Retail Startups
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
The HR department requires a report of all employees earning a monthly salary strictly greater than 60,000. Display employee ID, employee name, department, and monthly salary.

---

## 📊 Sample Mock Table (`employees`)

| emp_id | emp_name | department | salary | joining_date |
| :--- | :--- | :--- | :--- | :--- |
| 101 | Amit Sharma | IT | 75000.00 | 2022-03-15 |
| 102 | Priya Verma | HR | 52000.00 | 2023-01-10 |
| 103 | Rajesh Kumar | Finance | 60000.00 | 2021-07-20 |
| 104 | Sneha Patel | IT | 92000.00 | 2020-11-05 |
| 105 | Rohit Gupta | Marketing | 48000.00 | 2023-06-12 |
| 106 | Ananya Roy | Finance | 68000.00 | 2022-09-01 |

---

## 🎯 Expected Output Table

| emp_id | emp_name | department | salary |
| :--- | :--- | :--- | :--- |
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

1. **Column Projection vs `SELECT *`**:
   - Selecting explicit columns avoids excessive disk and network I/O, allowing query optimizers to utilize covering indexes (Index-Only Scan).

2. **Strict Inequality Boundary**:
   - `salary > 60000` excludes boundary matches (e.g. 60,000.00), adhering strictly to business requirements.

3. **Logical Processing Phase**:
   - `FROM` -> `WHERE` -> `SELECT`.
