# Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` vs `OR`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 005 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Sales HR Operations audit mein un active sales representatives ki list identify karni hai jinki base salary 50,000 ya usse zyada hai, lekin ya toh unka commission percentage set nahi hai (`commission_pct IS NULL`) ya unhe koi reporting manager assign nahi hua hai (`manager_id IS NULL`)."

---

## 📊 Sample Mock Table (`sales_reps`)

| rep_id | rep_name | salary | commission_pct | manager_id | is_active |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Vijay Verma | 55000.00 | NULL | 10 | True |
| 2 | Neha Sharma | 62000.00 | 0.15 | NULL | True |
| 3 | Rahul Sen | 48000.00 | NULL | 10 | True |
| 4 | Swati Das | 70000.00 | 0.20 | 12 | True |
| 5 | Manish Rao | 52000.00 | NULL | NULL | False |
| 6 | Pooja Joshi | 50000.00 | 0.10 | NULL | True |

---

## 🎯 Expected Output Table

| rep_id | rep_name | salary | commission_pct | manager_id |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Vijay Verma | 55000.00 | NULL | 10 |
| 2 | Neha Sharma | 62000.00 | 0.15 | NULL |
| 6 | Pooja Joshi | 50000.00 | 0.10 | NULL |

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

## ⚙️ Execution Logic (Saral Bhasha Me)
SQL evaluation precedence ke mutabiq `NOT` -> `AND` -> `OR` evaluate hota hai. Parentheses `(commission_pct IS NULL OR manager_id IS NULL)` lagane se OR condition isolate ho jati hai aur overall filters ke saath sahi correlate hoti hai.

---

## ⚠️ Interviewer Trap Question
*"Agar tum `(commission_pct IS NULL OR manager_id IS NULL)` se parentheses `( )` hata do, toh query par kya asar padega? Kya output change hoga?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Bilkul change hoga sir! SQL mein `AND` operator ki precedence `OR` se high hoti hai. Agar hum brackets hata denge, toh engine query ko aise execute karega:*  
> `(salary >= 50000 AND is_active = TRUE AND commission_pct IS NULL) OR (manager_id IS NULL)`  
> *Iska nateeja yeh hoga ki har wo employee jiska `manager_id` NULL hai, wo automatically output mein aa jayega—chahe uski salary 10,000 ho ya wo inactive (`is_active = FALSE`) ho! Isliye compound business logic mein brackets lagana mandatory hai taaki logic leak na ho."*
