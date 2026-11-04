# Q001: Strict Numeric Boundary Filtering & Column Selection

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 001 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Company ko un employees ki list chahiye jinki monthly salary strictly 60,000 se zyada hai taaki unka higher tax slab check kiya ja sake. Report mein sirf zaroori details (ID, Name, Dept, Salary) chahiye."

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

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum `employees` table se sirf 4 maange gaye columns select karenge aur `WHERE salary > 60000` lagayenge. Isse wahi employees aayenge jinki salary 60,000 se ek rupya bhi upar hai."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Dataset mein ek employee ki salary exact 60,000 hai. Kya wo tumhari query mein aayega? Aur agar tum `SELECT *` likh dete toh kya dikkat hoti?"*

* **🛡️ Trap ka Counter-Jawab:**
  "Nahi sir, kyunki aapne 'strictly greater than 60,000' bola tha, isliye humne `>` lagaya hai `>=` nahi, toh 60,000 wala banda filter ho jayega.
  Aur `SELECT *` isliye nahi likha kyunki production database mein tables mein 50-60 columns hote hain. Faaltu columns load karne se server slow ho jata hai, isliye sirf wahi maango jo report mein chahiye."
