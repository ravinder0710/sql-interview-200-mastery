# Q008: Second Highest Price (`DISTINCT`, `OFFSET`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 008 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Real-estate portal par Bangalore city ke andar sabse mehenge flat ke baad jo doosra sabse mehenga price hai wo pata karna hai."

---

## 📊 Sample Mock Table (`properties`)

| property_id | property_name | city | price | bhk |
| :--- | :--- | :--- | :--- | :--- |
| 101 | Prestige Palms | Bangalore | 18500000.00 | 3 |
| 102 | Sobha Silicon | Bangalore | 24000000.00 | 4 |
| 103 | Brigade Gateway | Bangalore | 24000000.00 | 4 |
| 104 | Godrej Woods | Bangalore | 16000000.00 | 3 |
| 105 | DLF Phase 5 | Gurgaon | 35000000.00 | 4 |
| 106 | Purva Park | Bangalore | 13500000.00 | 2 |

---

## 🎯 Expected Output Table

| price |
| :--- |
| 18500000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT DISTINCT price 
FROM properties 
WHERE city = 'Bangalore' 
ORDER BY price DESC 
LIMIT 1 OFFSET 1;
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum duplicate prices hatayenge `SELECT DISTINCT price`, Bangalore filter karenge, price ko descending sort karenge, aur `LIMIT 1 OFFSET 1` laga kar pehle ko skip karke doosra utha lenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar do alag-alag properties ka price same ho (jaise top dono 1.50 Crore ki hon), aur tumne `DISTINCT` na lagaya ho toh kya output aayega?"*

* **🛡️ Trap ka Counter-Jawab:**
  "Sir, agar `DISTINCT` nahi lagaya toh 1.50 Crore hi do baar aa jayega, aur `OFFSET 1` doosre number pe bhi 1.50 Crore hi utha lega — jabki hume second highest price chahiye tha. Isliye duplicate price hatane ke liye `DISTINCT` lagana compulsory hai."
