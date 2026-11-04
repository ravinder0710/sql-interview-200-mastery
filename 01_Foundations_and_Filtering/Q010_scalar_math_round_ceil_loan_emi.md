# Q010: Scalar Math Functions (ROUND, CEIL) & Clean CTE Decomposition

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 010 / 150
- **Company Tag:** CRED / Paytm Lending / FinTech Loan Servicing
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A digital lending FinTech platform requires an amortization schedule for approved loans:
1. Total Interest: `ROUND(principal * (annual_rate / (12.0 * 100.0)) * tenure_months, 2)`
2. Total Repayment: `principal + total_interest`
3. Monthly EMI: `CEIL(total_repayment / tenure_months)` (Rounded UP to nearest whole rupee)

Display loan ID, borrower name, total interest, total repayment, and monthly EMI.
Order results by monthly EMI in descending order.

---

## 📊 Sample Mock Table (`loan_applications`)

| loan_id | borrower_name | principal_amount | annual_rate | tenure_months | loan_status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1001 | Rahul Mehra | 120000.00 | 12.00 | 12 | Approved |
| 1002 | Shweta Tiwari | 50000.00 | 14.00 | 6 | Approved |
| 1003 | Alok Verma | 200000.00 | 10.50 | 24 | Rejected |
| 1004 | Kavita Sen | 80000.00 | 15.00 | 9 | Approved |
| 1005 | Mohit Suri | 150000.00 | 11.00 | 18 | Under Review |
| 1006 | Tanvi Shah | 300000.00 | 9.50 | 36 | Approved |

---

## 🎯 Expected Output Table

| loan_id | borrower_name | total_interest | total_repayment | monthly_emi |
| :--- | :--- | :--- | :--- | :--- |
| 1001 | Rahul Mehra | 14400.00 | 134400.00 | 11200 |
| 1006 | Tanvi Shah | 85500.00 | 385500.00 | 10709 |
| 1004 | Kavita Sen | 9000.00 | 89000.00 | 9889 |
| 1002 | Shweta Tiwari | 3500.00 | 53500.00 | 8917 |

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

1. **Modular CTE vs Redundant Repetition**:
   - Repeating complex arithmetic across multiple projection lines increases maintenance overhead and typo risks. CTEs isolate the interest computation cleanly.

2. **Rounding Semantics**:
   - `ROUND(x, d)`: Arithmetic rounding to `d` decimal positions.
   - `CEIL(x)` / `CEILING(x)`: Returns the smallest integer >= x. Essential in loan installments to prevent residual fractional loss.
   - `FLOOR(x)`: Returns the largest integer <= x.
