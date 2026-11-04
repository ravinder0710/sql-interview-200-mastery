# Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` vs `OR`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 005 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
During a sales HR compensation audit, management needs to identify all active, high-earning sales representatives (`salary >= 50000` and `is_active = TRUE`) who have governance or policy gaps—specifically, reps who either lack an assigned commission rate (`commission_pct IS NULL`) or do not currently report to an assigned sales manager (`manager_id IS NULL`).

---

## 📊 Sample Mock Table (`sales_reps`)

| rep_id | rep_name | salary | commission_pct | manager_id | is_active |
| :---: | :--- | :---: | :---: | :---: | :---: |
| 1 | Vijay Verma | 55000.00 | NULL | 10 | True |
| 2 | Neha Sharma | 62000.00 | 0.15 | NULL | True |
| 3 | Rahul Sen | 48000.00 | NULL | 10 | True |
| 4 | Swati Das | 70000.00 | 0.20 | 12 | True |
| 5 | Manish Rao | 52000.00 | NULL | NULL | False |
| 6 | Pooja Joshi | 50000.00 | 0.10 | NULL | True |

---

## 🎯 Expected Output

| rep_id | rep_name | salary | commission_pct | manager_id |
| :---: | :--- | :---: | :---: | :---: |
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

## 🧠 Interview Defense & Technical Takeaways

1. **Logical Operator Precedence Hierarchy:**
   - In SQL, logical operators evaluate strictly as:
     $$\mathbf{NOT} \longrightarrow \mathbf{AND} \longrightarrow \mathbf{OR}$$
   - Because `AND` has higher precedence than `OR`, unparenthesized compound conditions evaluate unexpectedly.

2. **The Parentheses Isolation Rule:**
   - Wrapping `(commission_pct IS NULL OR manager_id IS NULL)` ensures the `OR` logic is resolved as an atomic unit before intersecting with `salary` and `is_active` filters.

3. **Equality Comparison with NULL:**
   - Testing `col = NULL` or `col != NULL` is fundamentally invalid in SQL. `NULL` represents an unknown state, so equality comparisons always return `UNKNOWN`. Explicit `IS NULL` or `IS NOT NULL` is required.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Removing Parentheses (Logic Leak):**
   - *Interviewer:* "What happens if we remove the parentheses around the `OR` statement?"
   - *Defense:* The query transforms into `(salary >= 50000 AND is_active = TRUE AND commission_pct IS NULL) OR (manager_id IS NULL)`. Any employee whose manager is NULL will be pulled in—even inactive staff or interns with small salaries. Parentheses prevent this logic leak.

2. **Trap: Writing `= NULL`:**
   - *Interviewer:* "Why can't we simply write `WHERE commission_pct = NULL`?"
   - *Defense:* In ANSI SQL Three-Valued Logic, `NULL` cannot equal anything, not even itself (`NULL = NULL` is UNKNOWN). Therefore, `= NULL` evaluates to UNKNOWN for every row and returns an empty result set.
