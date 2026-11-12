# Q038: Aggregate Average & The NULL Imputation Trap (`AVG`, `COALESCE`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q038 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / HR & Compensation BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In corporate HR analytics, payroll administration, and annual compensation appraisals (e.g., TCS, Infosys, Accenture, Wipro), employee bonus allocations vary widely. Employees who do not qualify for a bonus or who have not completed their performance milestones record a `NULL` value in the `bonus_amount` column.

When computing the "Department Average Bonus", HR leadership enforces an explicit policy:
**"All active employees in the department must be factored into the average; employees without a bonus are treated as having received ₹0."**

If an analyst naively executes `AVG(bonus_amount)`, SQL's native aggregate behavior automatically drops `NULL` rows from both the numerator and the denominator, calculating the average only among bonus recipients. This artificially inflates the reported departmental average.

The Compensation & Benefits team requires an audited summary where:
1. Only regular employees are evaluated (`employment_type = 'Full-Time'`).
2. Only departments with at least 2 full-time employees are reported (`total_employees >= 2`).
3. The true department-wide average bonus is calculated by zero-imputing `NULL` values (`COALESCE(bonus_amount, 0)`).
4. All averages are rounded to 2 decimal places.
5. Sorted by `avg_department_bonus DESC, department_name ASC`.

---

## 📊 Sample Mock Table: `employee_salaries`

| emp_id | emp_name | department_name | base_salary | bonus_amount | employment_type |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 101 | Rajesh Kumar | Engineering | 80000.00 | 10000.00 | Full-Time |
| 102 | Priya Sharma | Engineering | 95000.00 | NULL | Full-Time |
| 103 | Amit Patel | Engineering | 75000.00 | 5000.00 | Full-Time |
| 104 | Sneha Sen | Marketing | 60000.00 | 6000.00 | Full-Time |
| 105 | Vikram Das | Marketing | 55000.00 | NULL | Full-Time |
| 106 | Anita Roy | HR | 50000.00 | 4000.00 | Full-Time |
| 107 | Deepa Nair | Finance | 70000.00 | 8000.00 | Contractor |

---

## 🎯 Expected Output Table

| department_name | total_employees | avg_base_salary | avg_department_bonus |
|:---:|:---:|:---:|:---:|
| Engineering | 3 | 83333.33 | 5000.00 |
| Marketing | 2 | 57500.00 | 3000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    department_name, 
    COUNT(emp_id) AS total_employees, 
    ROUND(AVG(base_salary), 2) AS avg_base_salary, 
    ROUND(AVG(COALESCE(bonus_amount, 0)), 2) AS avg_department_bonus 
FROM employee_salaries 
WHERE employment_type = 'Full-Time' 
GROUP BY department_name 
HAVING COUNT(emp_id) >= 2 
ORDER BY avg_department_bonus DESC, department_name ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Mathematical Mechanics: `AVG(col)` vs `AVG(COALESCE(col, 0))`
- **Standard `AVG(bonus_amount)`**:
  $$\text{AVG}(col) = \frac{\sum \text{Non-Null Values}}{\text{COUNT}(col)}$$
  In Engineering, this yields: $\frac{10000 + 5000}{2} = \mathbf{7500.00}$. The employee with `NULL` is excluded from the denominator.
- **Zero-Imputed `AVG(COALESCE(bonus_amount, 0))`**:
  $$\frac{10000 + 0 + 5000}{3} = \mathbf{5000.00}$$
  `COALESCE` converts the `NULL` into a concrete scalar `0`, forcing the denominator to encompass all 3 department members.

### 2. Alternative Mathematical Formulation: `SUM / COUNT(*)`
- An interviewer may ask for an alternative solution without `COALESCE`:
  ```sql
  ROUND(SUM(bonus_amount) / COUNT(*), 2) AS avg_department_bonus
  ```
  Because `SUM(bonus_amount)` ignores NULLs in the numerator while `COUNT(*)` counts all physical records in the group denominator, this yields the identical mathematical quotient.

### 3. Row-Level vs Post-Aggregation Filtering
- `WHERE employment_type = 'Full-Time'`: Discards Contractors prior to grouping, preventing non-qualifying roles from diluting base salary or headcount.
- `HAVING COUNT(emp_id) >= 2`: Prunes singleton departments (like HR with only 1 employee) after group aggregation.

---

## 🚨 Common Interview Traps & Defense

### Trap 1: The Artificial Inflation Trap
- **Interviewer Query:** *"What is the business risk of omitting `COALESCE` in payroll or performance analytics?"*
- **Candidate Defense:**
  > *"Omitting `COALESCE` biases the sample by restricting the population solely to bonus recipients. For departments where only 10% of staff received a bonus, reporting `AVG(bonus_amount)` suggests the entire department enjoyed a massive average payout, misrepresenting total company compensation and budget allocations."*

### Trap 2: Using `IFNULL` vs `COALESCE`
- **Interviewer Query:** *"Why prefer `COALESCE` over `IFNULL`?"*
- **Candidate Defense:**
  > *"`IFNULL` is proprietary to MySQL. `COALESCE` is ANSI SQL standard, accepts multiple fallback arguments, and functions identically across PostgreSQL, Oracle, SQL Server, Snowflake, and BigQuery."*
