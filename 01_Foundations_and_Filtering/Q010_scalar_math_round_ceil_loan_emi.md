# Q010: Loan EMI & Interest (`ROUND`, `CEIL` Rounding)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 010 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"FinTech loan app ke liye approved loans ka total interest, total repayment, aur monthly EMI calculate karni hai, jisme customer se paise round-off karke aage wale poore rupaye mein lene hain."

---

## 📊 Sample Mock Table (`loan_application`)

| loan_id | borrower_name | principal_amount | annual_rate | tenure_months | loan_status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1001 | Manish Verma | 500000.00 | 10.50 | 36 | Approved |
| 1002 | Shweta Tiwari | 250000.00 | 12.00 | 24 | Approved |
| 1003 | Kunal Roy | 750000.00 | 9.00 | 60 | Rejected |
| 1004 | Ritu Phogat | 100000.00 | 14.00 | 12 | Approved |
| 1005 | Deepa Malik | 300000.00 | 11.00 | 48 | Pending |
| 1006 | Saurav Ganguly | 150000.00 | 13.50 | 18 | Approved |

---

## 🎯 Expected Output Table

| loan_id | borrower_name | total_interest | total_repayment | monthly_emi |
| :--- | :--- | :--- | :--- | :--- |
| 1004 | Ritu Phogat | 14000.00 | 114000.00 | 9500 |
| 1006 | Saurav Ganguly | 30375.00 | 180375.00 | 10021 |
| 1002 | Shweta Tiwari | 60000.00 | 310000.00 | 12917 |
| 1001 | Manish Verma | 157500.00 | 657500.00 | 18264 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    loan_id, 
    borrower_name, 
    ROUND(principal_amount * (annual_rate / (12 * 100.0)) * tenure_months, 2) AS total_interest, 
    ROUND(principal_amount * (1 + (annual_rate / (12 * 100.0)) * tenure_months), 2) AS total_repayment, 
    CEIL(ROUND(principal_amount * (1 + (annual_rate / (12 * 100.0)) * tenure_months), 2) / tenure_months) AS monthly_emi 
FROM loan_application 
WHERE loan_status = 'Approved' 
ORDER BY monthly_emi;
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum simple interest formula use karenge. 2 decimal places tak paison ko sahi rakhne ke liye `ROUND(..., 2)` karenge, aur monthly EMI ke liye total repayment ko tenure se divide karke `CEIL(...)` lagayenge taaki 1 paisa bhi kam na kate."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"`ROUND()` aur `CEIL()` mein kya fark hai? EMI mein `ROUND()` kyu nahi lagaya?"*

* **🛡️ Trap ka Counter-Jawab:**
  "`ROUND()` nearest number dekhta hai (agar .50 se kam ho toh piche, zyada ho toh aage). Lekin bank aur loan mein agar ₹10,416.20 ki EMI bani aur humne use ₹10,416 round kar diya, toh aakhri mein bank ka 20-30 paisa loss ho jayega.
  `CEIL()` hamesha upar ke agle rupaye pe le jata hai (jaise ₹10,416.20 ko seedha ₹10,417 kar dega), jisse bank ka recovery target poora rehta hai."
