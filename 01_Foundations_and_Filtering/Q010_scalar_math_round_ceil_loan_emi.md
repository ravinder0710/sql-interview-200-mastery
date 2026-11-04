# Q010: Scalar Math Functions (`ROUND`, `CEIL`, `FLOOR`) & CTE Decomposition

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 010 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"FinTech digital lending application mein 'Approved' micro-loans ka simple interest, total repayment obligation, aur monthly installment (EMI) schedule compute karna hai bina kisi penny-loss / fractional shortfall ke."

---

## 📊 Sample Mock Table (`loan_applications`)

| loan_id | borrower_name | principal_amount | annual_rate | tenure_months | loan_status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 7001 | Rajesh Varma | 50000.00 | 12.00 | 12 | Approved |
| 7002 | Preeti Nair | 120000.00 | 14.50 | 24 | Approved |
| 7003 | Suresh Patil | 30000.00 | 10.00 | 6 | Rejected |
| 7004 | Anjali Sen | 85000.00 | 13.25 | 18 | Approved |
| 7005 | Tarun Khanna | 200000.00 | 11.50 | 36 | Approved |

---

## 🎯 Expected Output Table

| loan_id | borrower_name | total_interest | total_repayment | monthly_emi |
| :--- | :--- | :--- | :--- | :--- |
| 7005 | Tarun Khanna | 69000.00 | 269000.00 | 7473 |
| 7002 | Preeti Nair | 34800.00 | 154800.00 | 6450 |
| 7004 | Anjali Sen | 16893.75 | 101893.75 | 5661 |
| 7001 | Rajesh Varma | 60000.00 | 56000.00 | 4667 |

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

## ⚙️ Execution Logic (Saral Bhasha Me)
Common Table Expression (`WITH loan_calc AS (...)`) pehle interest calculation ko modular layer mein compute karta hai. Outer query us computed interest ko reuse karke repayment sum karti hai aur `CEIL()` function se round-up karti hai.

---

## ⚠️ Interviewer Trap Question
*"EMI calculate karte waqt `ROUND()` ke bajaye `CEIL()` lagane ka kya financial reason hai? Aur CTE lagane se production query ko kya fayda hota hai?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, banking aur NBFC lending systems mein agar EMI decimal mein aati hai (jaise ₹4,666.67), aur hum standard `ROUND()` ya `FLOOR()` laga dein toh last month tak bank ko aggregate recovery mein kuch paison ya rupaye ka shortfall ho jata hai. `CEIL()` (Ceiling) hamesha next higher integer par round-up karta hai, jisse company ka principal aur interest collection kabhi bhi under-recover na ho.*  
> *Doosri baat, CTE (`WITH`) use karne se complex nested formulas baar-baar repeat nahi karne padte. Code highly readable aur maintainable ban jata hai jisse debugging easy ho jati hai."*
