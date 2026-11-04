# Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 004 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Marketing automation team ko targeted Gmail email campaign bhejna hai. Hume un genuine customers ki list filter karni hai jinka name letter 'A' se start hota ho, official email domain `@gmail.com` ho, aur QA / internal dummy test accounts (`%test%`) excluded hon."

---

## 📊 Sample Mock Table (`customers`)

| customer_id | customer_name | email | city |
| :--- | :--- | :--- | :--- |
| 201 | Amit Roy | amit.roy@gmail.com | Delhi |
| 202 | Ananya Sen | ananya_test@gmail.com | Mumbai |
| 203 | Bharat Kumar | bharat@gmail.com | Bangalore |
| 204 | Aradhana Nair | aradhana@yahoo.com | Chennai |
| 205 | Alok Gupta | alok.gupta@gmail.com | Kolkata |
| 206 | Aakash Test | aakash@testdomain.com | Hyderabad |

---

## 🎯 Expected Output Table

| customer_id | customer_name | email | city |
| :--- | :--- | :--- | :--- |
| 201 | Amit Roy | amit.roy@gmail.com | Delhi |
| 205 | Alok Gupta | alok.gupta@gmail.com | Kolkata |

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

## ⚙️ Execution Logic (Saral Bhasha Me)
`LIKE 'A%'` starting letter 'A' se match karta hai, `LIKE '%@gmail.com'` ending domain verify karta hai, aur `NOT LIKE '%test%'` dummy accounts ko drop karta hai.

---

## ⚠️ Interviewer Trap Question
*"Agar table mein 1 crore rows hon, toh `customer_name LIKE 'A%'` aur `email LIKE '%@gmail.com'` dono mein se kaunsi condition fast chalegi aur kaunsi slow, aur kyu?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, `customer_name LIKE 'A%'` fast chalegi kyunki yeh ek **Prefix Search (Trailing Wildcard)** hai, jisme database B-Tree index ka direct **Index Seek** use kar leta hai.*  
> *Lekin `email LIKE '%@gmail.com'` mein aage `%` (Leading Wildcard) laga hua hai. Is case mein database index ko string ki starting position nahi pata hoti, isliye B-Tree index bypass ho jata hai aur database ko har row scan karni padti hai (**Full Table Scan**). Production mein leading wildcards ke liye hum Trigram Index (`pg_trgm`) ya Full-Text Search use karte hain."*
