# Q006: Multi-Column Priority Sorting & Tie-Breaking (`ORDER BY`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 006 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Hospital Emergency Room (ER) / OPD queue management system mein 'Waiting' status wale patients ki live triage queue display karni hai. Sorting logic hierarchical hona chahiye: pehle Doctor ID ascending, fir Emergency Priority Score descending (critical patients pehle), aur agar priority tie ho toh Arrival Time ascending (first-come first-served)."

---

## 📊 Sample Mock Table (`patient_appointments`)

| appointment_id | patient_name | doctor_id | priority_score | appointment_time | status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1001 | Ramesh Gupta | 101 | 3 | 09:15:00 | Waiting |
| 1002 | Sunita Sen | 102 | 5 | 09:20:00 | Waiting |
| 1003 | Vikas Mehra | 101 | 5 | 09:30:00 | Waiting |
| 1004 | Anita Roy | 101 | 5 | 09:10:00 | Waiting |
| 1005 | Tarun Das | 102 | 4 | 09:05:00 | Completed |
| 1006 | Meena Jain | 101 | 2 | 09:40:00 | Waiting |

---

## 🎯 Expected Output Table

| appointment_id | patient_name | doctor_id | priority_score | appointment_time |
| :--- | :--- | :--- | :--- | :--- |
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

## ⚙️ Execution Logic (Saral Bhasha Me)
Hierarchical sorting engine primary key (`doctor_id`) se sort karta hai. Jab tak doctors distinct hain, agle columns inactive rehte hain. Jaise hi doctor same hota hai, engine `priority_score DESC` se rank karta hai. Agar score bhi tie ho jaye, tab `appointment_time ASC` final tie-breaker banata hai.

---

## ⚠️ Interviewer Trap Question
*"Kuch developers shortcut ke liye `ORDER BY 3, 4 DESC, 5` likh dete hain. Kya production code mein yeh safe practice hai? Aur agar `priority_score` kisi patient ka NULL ho toh wo kahan sort hoga?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, production environment mein positional numbers (`ORDER BY 3, 4`) use karna strict anti-pattern hai. Kal ko agar team mein kisi ne SELECT list mein columns ka sequence badal diya, toh poori sorting bina kisi syntax error ke galat business columns par lag jayegi. Hamesha explicit column names hi likhne chahiye.*  
> *Rahi baat NULL values ki, SQL dialect ke hisab se default behavior alag hota hai—MySQL aur SQL Server ASC order mein NULL ko sabse upar (NULLS FIRST) rakhte hain jabki PostgreSQL ASC mein NULL ko last mein rakhta hai. Consistent output ke liye standard SQL mein hum explicit `NULLS LAST` specify karte hain."*
