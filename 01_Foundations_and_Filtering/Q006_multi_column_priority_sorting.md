# Q006: Multi-Column Sorting & Priority Queue Logic

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 006 / 150
- **Company Tag:** Apollo / Fortis / Hospital & Logistics Triage Systems
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A hospital management system requires a real-time prioritized OPD waiting queue:
1. Group appointments primarily by `doctor_id ASC`.
2. Within each doctor, prioritize urgent cases first using `priority_score DESC` (Score 3 = Emergency, 2 = Urgent, 1 = Normal).
3. If priority scores match, break the tie by earliest arrival (`appointment_time ASC`).
4. Filter out any patients whose status is not 'Waiting'.

---

## 📊 Sample Mock Table (`patient_appointments`)

| appointment_id | patient_name | doctor_id | priority_score | appointment_time | status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 601 | Ramesh Gupta | 101 | 1 | 09:30:00 | Waiting |
| 602 | Suman Lata | 102 | 3 | 10:15:00 | Waiting |
| 603 | Geeta Sen | 101 | 3 | 10:00:00 | Waiting |
| 604 | Arvind Rana | 101 | 1 | 09:15:00 | Waiting |
| 605 | Mohan Lal | 102 | 2 | 09:45:00 | Completed |
| 606 | Sunita Jain | 102 | 3 | 09:00:00 | Waiting |
| 607 | Kapil Dev | 101 | 2 | 10:30:00 | Cancelled |

---

## 🎯 Expected Output Table

| appointment_id | patient_name | doctor_id | priority_score | appointment_time |
| :--- | :--- | :--- | :--- | :--- |
| 603 | Geeta Sen | 101 | 3 | 10:00:00 |
| 604 | Arvind Rana | 101 | 1 | 09:15:00 |
| 601 | Ramesh Gupta | 101 | 1 | 09:30:00 |
| 606 | Sunita Jain | 102 | 3 | 09:00:00 |
| 602 | Suman Lata | 102 | 3 | 10:15:00 |

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

1. **Multi-tier Sorting Mechanism**:
   - Primary sort column handles initial partitioning. Subsequent columns evaluate strictly as tie-breakers when prior keys are identical.

2. **Named References vs Positional References**:
   - Avoid `ORDER BY 3 ASC, 4 DESC, 5 ASC`. Named references protect queries against schema column reordering bugs.

3. **Composite Indexing for ORDER BY**:
   - A composite index on `(status, doctor_id, priority_score DESC, appointment_time)` allows the database to read pre-sorted index pages directly, bypassing in-memory filesort operators.
