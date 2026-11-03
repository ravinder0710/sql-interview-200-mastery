/*
===============================================================================
Question ID: Q001
Category: 01_Basic / 01_Basic_Easy
Topic: Column Projection & Numeric Boundary Filtering
Difficulty: Easy
SQL Standard: ANSI SQL (PostgreSQL, MySQL, SQL Server compatible)
===============================================================================

PROBLEM STATEMENT:
The HR department requires a report of all employees earning a monthly salary 
strictly greater than 60,000. Display employee ID, employee name, department, 
and monthly salary.

TABLE SCHEMA:
employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    joining_date DATE NOT NULL
);

SAMPLE DATA:
INSERT INTO employees (emp_id, emp_name, department, salary, joining_date) VALUES
(101, 'Amit Sharma',  'IT',        75000.00, '2022-03-15'),
(102, 'Priya Verma',  'HR',        52000.00, '2023-01-10'),
(103, 'Rajesh Kumar', 'Finance',   60000.00, '2021-07-20'),
(104, 'Sneha Patel',  'IT',        92000.00, '2020-11-05'),
(105, 'Rohit Gupta',  'Marketing', 48000.00, '2023-06-12'),
(106, 'Ananya Roy',   'Finance',   68000.00, '2022-09-01');

EXPECTED OUTPUT:
emp_id | emp_name     | department | salary
-------+--------------+------------+---------
101    | Amit Sharma  | IT         | 75000.00
104    | Sneha Patel  | IT         | 92000.00
106    | Ananya Roy   | Finance    | 68000.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    emp_id, 
    emp_name, 
    department, 
    salary 
FROM employees 
WHERE salary > 60000;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Column Projection:
   Selecting explicit columns instead of `SELECT *` minimizes network I/O
   and allows the query optimizer to utilize covering indexes.

2. Strict Inequality:
   The condition `salary > 60000` excludes boundary matches (e.g. 60,000.00),
   adhering strictly to business requirements.

3. Logical Processing Phase:
   FROM employees -> WHERE salary > 60000 -> SELECT projections.
===============================================================================
*/
