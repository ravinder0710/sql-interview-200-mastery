# Q022: Exact Age Calculation & Senior Citizen KYC (`TIMESTAMPDIFF`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 022 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In a health insurance underwriting platform, premium calculations and policy renewal subsidies are strictly contingent on the policyholder's completed age. Because leap years and unreached birth months introduce inaccuracies when dividing day counts by 365, the risk compliance team requires computing the exact completed age as of the benchmark date `'2024-01-01'`. The audit requires isolating active senior citizen policyholders (`age >= 60` and `policy_status = 'Active'`), prioritizing the eldest members.

---

## 📊 Sample Mock Table (`policy_holders`)

| holder_id | customer_name | date_of_birth | policy_type | policy_status |
| :---: | :--- | :---: | :--- | :--- |
| 801 | Ramesh Gupta | 1960-05-15 | Health | Active |
| 802 | Sunita Sen | 1975-08-20 | Health | Active |
| 803 | Vikas Mehra | 1958-11-10 | Term Life | Active |
| 804 | Anita Roy | 1963-12-01 | Health | Lapsed |
| 805 | Tarun Das | 1964-03-25 | Health | Active |
| 806 | Meena Jain | 1952-09-18 | Health | Active |

---

## 🎯 Expected Output

| holder_id | customer_name | date_of_birth | customer_age | policy_status |
| :---: | :--- | :---: | :---: | :--- |
| 806 | Meena Jain | 1952-09-18 | 71 | Active |
| 803 | Vikas Mehra | 1958-11-10 | 65 | Active |
| 801 | Ramesh Gupta | 1960-05-15 | 63 | Active |

---

## 💡 Production SQL Solution

```sql
SELECT 
    holder_id, 
    customer_name, 
    date_of_birth, 
    TIMESTAMPDIFF(YEAR, date_of_birth, '2024-01-01') AS customer_age, 
    policy_status 
FROM policy_holders 
WHERE policy_status = 'Active' 
  AND TIMESTAMPDIFF(YEAR, date_of_birth, '2024-01-01') >= 60 
ORDER BY 
    customer_age DESC, 
    holder_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why `TIMESTAMPDIFF(YEAR, ...)` Instead of `DATEDIFF() / 365.25`?**
   - Naive formulas like `FLOOR(DATEDIFF(...) / 365.25)` or `(YEAR(current) - YEAR(dob))` fail on edge cases. For instance, an individual born on December 31st will be reported as 1 year older on January 1st simply because the calendar year incremented, even though their actual birthday is 364 days away.
   - `TIMESTAMPDIFF(YEAR, start_date, end_date)` strictly checks whether the birthday has actually been celebrated in the target year.

2. **Cross-Engine Age Calculation Syntax:**
   - **MySQL**: `TIMESTAMPDIFF(YEAR, date_of_birth, '2024-01-01')`
   - **PostgreSQL**: `EXTRACT(YEAR FROM AGE('2024-01-01'::DATE, date_of_birth))` *(Uses native `AGE()` function)*
   - **SQL Server (T-SQL)**: `DATEDIFF(year, date_of_birth, '2024-01-01') - CASE WHEN DATEADD(year, DATEDIFF(year, date_of_birth, '2024-01-01'), date_of_birth) > '2024-01-01' THEN 1 ELSE 0 END`

3. **Argument Sequence in `TIMESTAMPDIFF`:**
   - The initial parameter is the unit (`YEAR`, `MONTH`, `DAY`).
   - The 2nd argument is the earlier date (`date_of_birth`), and the 3rd argument is the later target date. Inverting them produces negative age values.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Calendar Year Subtraction Trap (`YEAR(d2) - YEAR(d1)`):**
   - *Interviewer:* "Why not simply calculate `YEAR('2024-01-01') - YEAR(date_of_birth)`?"
   - *Defense:* Simple year subtraction ignores months and days. Tarun Das was born on `1964-03-25`. Evaluating `2024 - 1964` returns 60. However, on `2024-01-01`, his 60th birthday has not occurred yet (it occurs in March); his real age is 59. `TIMESTAMPDIFF()` accounts for calendar day completion.

2. **Trap: T-SQL Year Boundary Crossing Trap:**
   - *Interviewer:* "Does SQL Server's `DATEDIFF(year, dob, target)` work like MySQL's `TIMESTAMPDIFF`?"
   - *Defense:* No! In SQL Server, `DATEDIFF(year, '2023-12-31', '2024-01-01')` returns `1` because it only counts the number of year boundaries crossed (1 day apart!). We must adjust by checking whether the birth date has arrived in the current year.
