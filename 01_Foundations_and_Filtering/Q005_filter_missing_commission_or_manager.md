# Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` vs `OR`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 005 / 200
- **Company Tag:** Infosys, Wipro, Payroll
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **Operator Precedence**: Logical operators evaluate in strict order: $\mathbf{NOT} \longrightarrow \mathbf{AND} \longrightarrow \mathbf{OR}$.
2. **Encapsulation**: Parenthesizing `(commission_pct IS NULL OR manager_id IS NULL)` ensures the `OR` branch is resolved as a single atomic condition before being intersected with the base eligibility filters.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Omission of Parentheses (Logic Leak)**:
   - Removing the parentheses changes the evaluation into:  
     `(salary >= 50000 AND is_active = TRUE AND commission_pct IS NULL) OR (manager_id IS NULL)`  
   - This flaw would mistakenly include every single employee missing a manager—even inactive staff or interns earning low wages.
2. **Equality Trap with NULL (`= NULL`)**:
   - Writing `commission_pct = NULL` is invalid ANSI SQL and always evaluates to `UNKNOWN`. Explicit `IS NULL` is mandatory.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"Because logical AND takes precedence over OR in SQL evaluation hierarchy, wrapping compound OR predicates inside parentheses is required to prevent unintended logic leaks. Additionally, standard comparison operators cannot evaluate NULL values; using explicit `IS NULL` ensures proper three-valued logical verification."*
