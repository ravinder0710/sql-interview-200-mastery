# Q005: Missing Commission & Bracket Trap (`IS NULL`, Brackets `()`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 005 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Audit team un active sales reps ko dhoondh rahi hai jinki salary kam se kam 50,000 ho, lekin ya toh unka commission set nahi hua hai ya unka koi manager assign nahi hai."

---

## 📊 Sample Mock Table (`sales_reps`)

| rep_id | rep_name | salary | commission_pct | manager_id | is_active |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | Rohit Mehra | 55000.00 | NULL | 10 | TRUE |
| 102 | Simran Kaur | 48000.00 | NULL | 10 | TRUE |
| 103 | Varun Dhawan | 62000.00 | 0.15 | NULL | TRUE |
| 104 | Alia Bhatt | 75000.00 | 0.20 | 12 | TRUE |
| 105 | Sidharth M | 50000.00 | NULL | NULL | TRUE |
| 106 | Kiara Advani | 58000.00 | 0.10 | 10 | FALSE |
| 107 | Ranveer Singh | 52000.00 | 0.12 | 14 | TRUE |

---

## 🎯 Expected Output Table

| rep_id | rep_name | salary | commission_pct | manager_id |
| :--- | :--- | :--- | :--- | :--- |
| 101 | Rohit Mehra | 55000.00 | NULL | 10 |
| 103 | Varun Dhawan | 62000.00 | 0.15 | NULL |
| 105 | Sidharth M | 50000.00 | NULL | NULL |

---

## 💡 Production SQL Solution

```sql
SELECT 
    rep_id, 
    rep_name, 
    salary, 
    commission_pct, 
    manager_id 
FROM sales_reps 
WHERE salary >= 50000 
  AND is_active = TRUE 
  AND (commission_pct IS NULL OR manager_id IS NULL);
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum `salary >= 50000 AND is_active = TRUE` ke saath `AND (commission_pct IS NULL OR manager_id IS NULL)` lagayenge. Dono missing fields ko pakadne ke liye `OR` ko brackets mein band karenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar tum `(commission_pct IS NULL OR manager_id IS NULL)` ke aage-peeche ka bracket hata do, toh result par kya asar padega?"*

* **🛡️ Trap ka Counter-Jawab:**
  "Sir, SQL mein `AND` pehle chalta hai aur `OR` baad mein. Agar bracket hata diya, toh aisa koi bhi sales rep aa jayega jiska manager NULL ho — chahe uski salary 5,000 hi kyu na ho aur chahe wo inactive ho chuka ho! Isliye dono condition ko combine karne ke liye bracket lagana compulsory hai."
