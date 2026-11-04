# Q001: Strict Numeric Boundary Filtering & Column Projection

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 001 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Company mein HR compensation audit ya annual appraisal review chal raha hai. Finance team ko un sabhi employees ki report chahiye jinki monthly salary strictly 60,000 se zyada hai. Output mein sirf business-critical columns (ID, Name, Dept, Salary) required hain."

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

## ⚙️ Execution Logic (Saral Bhasha Me)
SQL engine pehle `FROM employees` table access karta hai. Fir `WHERE salary > 60000` condition evaluate karke 60k se kam aur barabar walo ko memory se drop karta hai. Aakhri mein `SELECT` clause sirf specific 4 columns fetch karti hai.

---

## ⚠️ Interviewer Trap Question
*"Maine dekha tumne `SELECT emp_id, emp_name...` explicit likha, agar tum yahan `SELECT *` likh dete toh kya problem hoti? Aur agar dataset mein salary exact 60,000 hui toh kya wo output mein aayegi?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, production database mein tables mein 40-50 columns hote hain. Agar hum `SELECT *` likhenge toh unnecessary disk I/O aur network bandwidth waste hogi. Specific columns specify karne se database optimizer **Covering Index (Index-Only Scan)** use karta hai jisse query 5-10 guna fast execute hoti hai.*  
> *Rahi baat 60,000 ki, business requirement 'strictly greater than 60,000' thi, isliye maine `>` operator lagaya hai na ki `>=`. Toh exact 60,000 ki boundary value exclude rahegi aur audit report 100% accurate rahegi."*
