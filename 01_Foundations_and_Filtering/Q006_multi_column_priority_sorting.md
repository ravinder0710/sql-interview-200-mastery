# Q006: Multi-Column Priority Sorting & Tie-Breaking (`ORDER BY`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 006 / 200
- **Company Tag:** Hospital & Logistics Triage
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **Primary Sort Key (`doctor_id ASC`)**: Groups patient queues by their consulting physician.
2. **Secondary Sort Key (`priority_score DESC`)**: Ranks critical patients highest within each doctor's cohort.
3. **Tertiary Tie-Breaker (`appointment_time ASC`)**: Resolves identical priority scores fairly based on arrival timestamp.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Positional Numbering Anti-Pattern (`ORDER BY 3, 4 DESC, 5`)**:
   - Referencing columns by integer positions creates silent production bugs if column orders in the `SELECT` projection are modified in future pipeline deployments.
2. **NULL Value Sorting Across Engines**:
   - In MySQL and SQL Server, `ASC` sorts `NULL` values first.
   - In PostgreSQL and Oracle, `ASC` sorts `NULL` values last by default. Use explicit `NULLS LAST` for deterministic cross-engine consistency.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"Multi-column sorting evaluates criteria sequentially, using secondary keys strictly as deterministic tie-breakers. Specifying explicit column identifiers rather than ordinal numbers is vital for maintainability and prevents pipeline breakage when underlying projection schemas evolve."*
