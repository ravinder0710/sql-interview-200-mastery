# Q006: Doctor Priority Sorting (`ORDER BY` Multi-column)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 006 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Hospital OPD mein waiting patients ki line lagani hai. Pehle doctor ke hisab se group ho, fir sabse emergency (high priority) patient pehle dekha jaye, aur agar do logon ki priority barabar ho toh jo pehle aaya wo pehle jaye."

---

## 📊 Sample Mock Table (`patient_appointments`)

| appointment_id | patient_name | doctor_id | priority_score | appointment_time | status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Ramesh Yadav | 201 | 8 | 09:30:00 | Waiting |
| 2 | Sunita Rao | 201 | 5 | 09:15:00 | Waiting |
| 3 | Deepak Goyal | 201 | 8 | 09:10:00 | Waiting |
| 4 | Anita Desai | 202 | 9 | 10:00:00 | Waiting |
| 5 | Manoj Tiwari | 202 | 9 | 09:45:00 | Waiting |
| 6 | Suresh Raina | 201 | 10 | 10:15:00 | Completed |
| 7 | Geeta Bali | 202 | 4 | 09:20:00 | Waiting |

---

## 🎯 Expected Output Table

| appointment_id | patient_name | doctor_id | priority_score | appointment_time |
| :--- | :--- | :--- | :--- | :--- |
| 3 | Deepak Goyal | 201 | 8 | 09:10:00 |
| 1 | Ramesh Yadav | 201 | 8 | 09:30:00 |
| 2 | Sunita Rao | 201 | 5 | 09:15:00 |
| 5 | Manoj Tiwari | 202 | 9 | 09:45:00 |
| 4 | Anita Desai | 202 | 9 | 10:00:00 |
| 7 | Geeta Bali | 202 | 4 | 09:20:00 |

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
ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC;
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum `WHERE status = 'Waiting'` lagayenge, aur sorting mein teen cheezein denge: `ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC`. Isse doctor-wise high score pehle aayega, aur tie hone par purana appointment pehle."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar main `ORDER BY doctor_id, priority_score, appointment_time` likh doon bina ASC/DESC lagaye, toh kya hoga?"*

* **🛡️ Trap ka Counter-Jawab:**
  "Sir, SQL by default sabko `ASC` (chhote se bada) maan leta hai. Toh emergency patient (score 10 wala) sabse aakhri mein chala jayega aur normal sardi-zukham (score 1 wala) pehle aa jayega. Isliye priority ke aage `DESC` likhna mandatory hai."
