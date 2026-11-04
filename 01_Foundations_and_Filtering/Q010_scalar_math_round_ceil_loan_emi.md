# Q010: Scalar Math Functions (`ROUND`, `CEIL`, `FLOOR`) & CTE Decomposition

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 010 / 200
- **Company Tag:** CRED, Paytm Lending
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **CTE Modularization**: Isolates the interest calculation expression so it can be cleanly reused without code duplication.
2. **Ceiling Math**: Applies `CEIL()` on the divided monthly obligation to eliminate under-recovery risks.
3. **Ordering**: Prioritizes portfolios by largest monthly cash inflow.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Why `CEIL()` over `ROUND()` in Financial Applications**:
   - Applying standard rounding or `FLOOR()` creates fractional penny losses over a multi-year tenure (e.g., collecting ₹4,666.66 instead of ₹4,666.67 results in an aggregate shortfall at loan closure). `CEIL()` guarantees full principal and interest recovery.
2. **Decomposition Benefit**:
   - Breaking calculations into CTE layers eliminates deeply nested bracket clutter and makes complex financial SQL enterprise-ready.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"Financial installment engines deploy `CEIL()` rather than standard rounding to guarantee that total realized collections never fall short of contracted principal and accrued interest. Implementing this logic via Common Table Expressions (CTEs) provides modular separation of concerns, eliminating redundant formula evaluation and significantly improving maintainability."*
