# Q004: Text Search & Wildcards (`LIKE '%...'`, `NOT LIKE`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 004 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Marketing team ko email campaign bhejna hai. Hume wo customers chahiye jinka naam 'A' se shuru hota ho, email Gmail ka ho, lekin kisi tester ya fake email (`test`) pe mail nahi jana chahiye."

---

## 📊 Sample Mock Table (`customers`)

| customer_id | customer_name | email | city |
| :--- | :--- | :--- | :--- |
| 1 | Aarav Sharma | aarav.sharma@gmail.com | Delhi |
| 2 | Ananya Sen | ananya_test@gmail.com | Kolkata |
| 3 | Rahul Verma | rahul.verma@yahoo.com | Mumbai |
| 4 | Amit Patel | amit.patel@gmail.com | Ahmedabad |
| 5 | Alok Gupta | test_alok@gmail.com | Bangalore |
| 6 | Priya Nair | priya.nair@gmail.com | Chennai |
| 7 | Ayush Mehta | ayush.mehta@outlook.com | Pune |

---

## 🎯 Expected Output Table

| customer_id | customer_name | email | city |
| :--- | :--- | :--- | :--- |
| 1 | Aarav Sharma | aarav.sharma@gmail.com | Delhi |
| 4 | Amit Patel | amit.patel@gmail.com | Ahmedabad |

---

## 💡 Production SQL Solution

```sql
SELECT 
    customer_id, 
    customer_name, 
    email, 
    city 
FROM customers 
WHERE customer_name LIKE 'A%' 
  AND email LIKE '%@gmail.com' 
  AND email NOT LIKE '%test%';
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, naam ke liye `customer_name LIKE 'A%'`, Gmail confirm karne ke liye `email LIKE '%@gmail.com'`, aur fake emails hatane ke liye `email NOT LIKE '%test%'` lagayenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar 1 crore customers ka data ho, toh `LIKE 'A%'` aur `LIKE '%@gmail.com'` mein se kaunsi line database ko slow kar sakti hai?"*

* **🛡️ Trap ka Counter-Jawab:**
  "`LIKE '%@gmail.com'` slow karegi sir. Kyunki uske aage `%` laga hai, database ko pata hi nahi string kahan se shuru ho rahi hai, toh use puri table ke har ek row ko check karna padega (Full Table Scan). Jabki `A%` mein pehla letter pata hai, toh database seedha 'A' pe jump kar sakta hai."
