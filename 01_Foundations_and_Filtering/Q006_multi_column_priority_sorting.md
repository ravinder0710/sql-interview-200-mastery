# Q006: Multi-Column Priority Sorting & Tie-Breaking (`ORDER BY`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 006 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
A hospital emergency room (ER) triage management system requires a live dashboard view of all waiting patients (`status = 'Waiting'`). The display queue must adhere to a strict clinical priority hierarchy: grouped primarily by `doctor_id ASC`, ordered secondarily by clinical urgency (`priority_score DESC`), and resolved deterministically by earliest arrival time (`appointment_time ASC`).

---

## 📊 Sample Mock Table (`patient_appointments`)

| appointment_id | patient_name | doctor_id | priority_score | appointment_time | status |
| :---: | :--- | :---: | :---: | :---: | :--- |
| 1001 | Ramesh Gupta | 101 | 3 | 09:15:00 | Waiting |
| 1002 | Sunita Sen | 102 | 5 | 09:20:00 | Waiting |
| 1003 | Vikas Mehra | 101 | 5 | 09:30:00 | Waiting |
| 1004 | Anita Roy | 101 | 5 | 09:10:00 | Waiting |
| 1005 | Tarun Das | 102 | 4 | 09:05:00 | Completed |
| 1006 | Meena Jain | 101 | 2 | 09:40:00 | Waiting |

---

## 🎯 Expected Output

| appointment_id | patient_name | doctor_id | priority_score | appointment_time |
| :---: | :--- | :---: | :---: | :---: |
| 1004 | Anita Roy | 101 | 5 | 09:10:00 |
| 1003 | Vikas Mehra | 101 | 5 | 09:30:00 |
| 1001 | Ramesh Gupta | 101 | 3 | 09:15:00 |
| 1006 | Meena Jain | 101 | 2 | 09:40:00 |
| 1002 | Sunita Sen | 102 | 5 | 09:20:00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    appointment_id, 
    patient_name, 
    doctor_id, 
    priority_score, 
    appointment_time 
FROM patient_appointments 
WHERE status = 'Waiting' 
ORDER BY 
    doctor_id ASC, 
    priority_score DESC, 
    appointment_time ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Hierarchical Sorting Mechanics:**
   - Multi-column `ORDER BY` evaluates sequentially. The engine sorts by the first key (`doctor_id`).
   - Subsequent columns (`priority_score`, then `appointment_time`) act strictly as **tie-breakers** only when previous column values in adjacent rows are identical.

2. **Positional Numbering Anti-Pattern:**
   - Writing `ORDER BY 3, 4 DESC, 5` is an anti-pattern in production SQL. If any future schema deployment adjusts the column sequence in the `SELECT` list, the query silently sorts by the wrong business metrics. Always use explicit column names.

3. **Performance Optimization with Composite Indexes:**
   - On high-traffic queue systems, creating a composite index matching the sort criteria `(status, doctor_id, priority_score DESC, appointment_time)` eliminates expensive in-memory filesort operations.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Positional References:**
   - *Interviewer:* "Can we save typing by writing `ORDER BY 3, 4 DESC, 5`?"
   - *Defense:* While syntactically valid, it is strongly discouraged in enterprise pipelines. Schema changes in projection order silently corrupt report sorting without throwing an error. Explicit column references ensure maintainability.

2. **Trap: NULL Handling in Sort Order:**
   - *Interviewer:* "Where do NULL values appear when sorting in ASC order?"
   - *Defense:* In MySQL and SQL Server, `ASC` places `NULL` values at the top (`NULLS FIRST`). In PostgreSQL and Oracle, `ASC` places `NULL` values at the bottom (`NULLS LAST`). For cross-platform consistency, specify `NULLS LAST` explicitly.
