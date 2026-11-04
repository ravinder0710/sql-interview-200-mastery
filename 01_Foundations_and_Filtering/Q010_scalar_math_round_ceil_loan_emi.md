# Q010: Scalar Math Functions (`ROUND`, `CEIL`, `FLOOR`) & CTE Decomposition

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 010 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
A digital micro-lending platform generates loan servicing and amortization schedules for 'Approved' applications. To prevent compounding fractional shortfall (penny loss) over tenure, the platform requires computing the total simple interest rounded to 2 decimal places, the total repayment obligation, and the rounded-up monthly installment (EMI) using ceiling math.

---

## 📊 Sample Mock Table (`loan_applications`)

| loan_id | borrower_name | principal_amount | annual_rate | tenure_months | loan_status |
| :---: | :--- | :---: | :---: | :---: | :--- |
| 7001 | Rajesh Varma | 50000.00 | 12.00 | 12 | Approved |
| 7002 | Preeti Nair | 120000.00 | 14.50 | 24 | Approved |
| 7003 | Suresh Patil | 30000.00 | 10.00 | 6 | Rejected |
| 7004 | Anjali Sen | 85000.00 | 13.25 | 18 | Approved |
| 7005 | Tarun Khanna | 200000.00 | 11.50 | 36 | Approved |

---

## 🎯 Expected Output

| loan_id | borrower_name | total_interest | total_repayment | monthly_emi |
| :---: | :--- | :---: | :---: | :---: |
| 7005 | Tarun Khanna | 69000.00 | 269000.00 | 7473 |
| 7002 | Preeti Nair | 34800.00 | 154800.00 | 6450 |
| 7004 | Anjali Sen | 16893.75 | 101893.75 | 5661 |
| 7001 | Rajesh Varma | 6000.00 | 56000.00 | 4667 |

---

## 💡 Production SQL Solution

```sql
WITH loan_calc AS (
    SELECT 
        loan_id, 
        borrower_name, 
        tenure_months,
        ROUND(principal_amount * (annual_rate / (12.0 * 100.0)) * tenure_months, 2) AS total_interest,
        principal_amount
    FROM loan_applications 
    WHERE loan_status = 'Approved'
)
SELECT 
    loan_id, 
    borrower_name, 
    total_interest, 
    (principal_amount + total_interest) AS total_repayment, 
    CEIL((principal_amount + total_interest) / tenure_months) AS monthly_emi 
FROM loan_calc 
ORDER BY monthly_emi DESC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why `CEIL()` over `ROUND()` for Installment Calculations?**
   - In lending and banking algorithms, rounding installments down or using standard rounding creates cumulative fractional shortfalls over long tenures. `CEIL()` guarantees that total installment collections fully cover principal and accrued interest.

2. **Common Table Expression (CTE) Decomposition:**
   - Instead of duplicating long math formulas across multiple expressions, a CTE (`WITH` clause) modularizes calculation into distinct, readable layers.
   - It separates data preparation from final presentation logic.

3. **Rounding Function Differences:**
   - `ROUND(val, 2)`: Standard arithmetic half-up rounding to 2 decimals.
   - `CEIL(val)` / `CEILING(val)`: Smallest integer $\ge val$ (always rounds up).
   - `FLOOR(val)`: Largest integer $\le val$ (always rounds down).

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Fractional Shortfall Risk:**
   - *Interviewer:* "Why not use `ROUND((principal + interest) / tenure, 0)` for EMI calculation?"
   - *Defense:* Standard rounding can round down (e.g., ₹4,666.49 becomes ₹4,666), resulting in the lender receiving less than the legally owed sum over the loan's lifetime. `CEIL()` protects against under-recovery.

2. **Trap: CTE vs Subquery Performance:**
   - *Interviewer:* "Does using a CTE slow down execution compared to writing everything in one single SELECT?"
   - *Defense:* In modern SQL optimizers (PostgreSQL, SQL Server, MySQL 8+), non-recursive CTEs are inlined by the optimizer. They incur zero performance overhead while providing substantial maintainability and readability advantages.
