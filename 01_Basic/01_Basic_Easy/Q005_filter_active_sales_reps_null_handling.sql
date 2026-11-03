/*
===============================================================================
Question ID: Q005
Category: 01_Basic / 01_Basic_Easy
Topic: NULL Handling (IS NULL) and Boolean Precedence (AND / OR with Parentheses)
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
The HR payroll team requires a list of active sales executives (is_active = TRUE) 
earning a base monthly salary >= 50000, who have either missing commission details 
(commission_pct IS NULL) OR missing reporting manager assignment (manager_id IS NULL). 
Display rep ID, rep name, salary, commission percentage, and manager ID.

TABLE SCHEMA:
sales_reps (
    rep_id INT PRIMARY KEY,
    rep_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    commission_pct DECIMAL(4, 2),
    manager_id INT,
    is_active BOOLEAN NOT NULL
);

SAMPLE DATA:
INSERT INTO sales_reps (rep_id, rep_name, salary, commission_pct, manager_id, is_active) VALUES
(401, 'Rohan Mehra',  65000.00, NULL, 10,   TRUE),
(402, 'Simran Kaur',  55000.00, 0.15, NULL, TRUE),
(403, 'Deepak Verma', 42000.00, NULL, NULL, TRUE),
(404, 'Neha Sharma',  70000.00, 0.10, 12,   TRUE),
(405, 'Kabir Khan',   58000.00, NULL, 10,   FALSE),
(406, 'Divya Rao',    50000.00, NULL, NULL, TRUE),
(407, 'Rahul Joshi',  80000.00, 0.20, 10,   TRUE);

EXPECTED OUTPUT:
rep_id | rep_name     | salary   | commission_pct | manager_id
-------+--------------+----------+----------------+-----------
401    | Rohan Mehra  | 65000.00 | NULL           | 10
402    | Simran Kaur  | 55000.00 | 0.15           | NULL
406    | Divya Rao    | 50000.00 | NULL           | NULL
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    rep_id, 
    rep_name, 
    salary, 
    commission_pct, 
    manager_id 
FROM sales_reps 
WHERE is_active = TRUE 
  AND salary >= 50000 
  AND (commission_pct IS NULL OR manager_id IS NULL);

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Operator Precedence (AND over OR):
   In SQL, AND binds more tightly than OR. Enclosing `(condition1 OR condition2)` 
   in parentheses guarantees that the OR evaluation is isolated and both must 
   comply with the preceding AND constraints.

2. NULL Verification:
   Never use `= NULL` or `!= NULL`. Standard SQL requires `IS NULL` or `IS NOT NULL` 
   because comparison with NULL yields UNKNOWN.
===============================================================================
*/
