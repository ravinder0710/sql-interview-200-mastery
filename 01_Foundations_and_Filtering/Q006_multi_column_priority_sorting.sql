/*
===============================================================================
Question ID: Q006
Category: 01_Basic / 01_Basic_Easy
Topic: Multi-Column Sorting (Primary, Secondary, Tertiary Sort & Tie-Breaking)
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
A hospital OPD reception team requires a real-time priority queue of all patients 
in 'Waiting' status. The queue must be ordered:
1. By doctor ID ascending (grouping appointments under each doctor).
2. By priority score descending (critical/emergency score 3 first, then 2, then 1).
3. In case of identical priority scores, by appointment time ascending (earlier time first).

Display appointment ID, patient name, doctor ID, priority score, and appointment time.

TABLE SCHEMA:
patient_appointments (
    appointment_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    doctor_id INT NOT NULL,
    priority_score INT NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(30) NOT NULL
);

SAMPLE DATA:
INSERT INTO patient_appointments (appointment_id, patient_name, doctor_id, priority_score, appointment_time, status) VALUES
(601, 'Ramesh Gupta', 101, 1, '09:30:00', 'Waiting'),
(602, 'Suman Lata',   102, 3, '10:15:00', 'Waiting'),
(603, 'Geeta Sen',    101, 3, '10:00:00', 'Waiting'),
(604, 'Arvind Rana',  101, 1, '09:15:00', 'Waiting'),
(605, 'Mohan Lal',    102, 2, '09:45:00', 'Completed'),
(606, 'Sunita Jain',  102, 3, '09:00:00', 'Waiting'),
(607, 'Kapil Dev',    101, 2, '10:30:00', 'Cancelled');

EXPECTED OUTPUT:
appointment_id | patient_name | doctor_id | priority_score | appointment_time
---------------+--------------+-----------+----------------+-----------------
603            | Geeta Sen    | 101       | 3              | 10:00:00
604            | Arvind Rana  | 101       | 1              | 09:15:00
601            | Ramesh Gupta | 101       | 1              | 09:30:00
606            | Sunita Jain  | 102       | 3              | 09:00:00
602            | Suman Lata   | 102       | 3              | 10:15:00
===============================================================================
*/

-- 🚀 SOLUTION:
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

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Multi-tier Sorting & Tie-Breaking:
   The query optimizer sorts primarily by `doctor_id`. The secondary and tertiary 
   columns are evaluated strictly as tie-breakers when prior keys are identical.

2. Positional References vs Named References:
   Avoid `ORDER BY 3 ASC, 4 DESC, 5 ASC`. Named column references are immune to 
   column reordering defects during schema migrations.

3. Index Optimization:
   A composite B-Tree index on `(status, doctor_id, priority_score DESC, appointment_time)` 
   enables an index-only scan without a separate Sort (filesort) operator in memory.
===============================================================================
*/
