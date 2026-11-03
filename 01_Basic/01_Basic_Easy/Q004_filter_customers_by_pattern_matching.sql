/*
===============================================================================
Question ID: Q004
Category: 01_Basic / 01_Basic_Easy
Topic: Wildcard Pattern Matching (LIKE, %, NOT LIKE)
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
A CRM marketing team wants to target genuine customer accounts for an email 
campaign. Retrieve customers whose name begins with 'A', who use a Gmail domain 
('@gmail.com'), and whose email does not contain the substring 'test'. 
Display customer ID, customer name, email, and city.

TABLE SCHEMA:
customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL,
    city VARCHAR(50) NOT NULL
);

SAMPLE DATA:
INSERT INTO customers (customer_id, customer_name, email, city) VALUES
(301, 'Amit Sharma',  'amit.sharma@gmail.com', 'Delhi'),
(302, 'Anjali Verma', 'anjali_test@gmail.com', 'Mumbai'),
(303, 'Rohit Kumar',  'rohit.k@gmail.com',     'Pune'),
(304, 'Aarti Patel',  'aarti.patel@yahoo.com', 'Ahmedabad'),
(305, 'Alok Gupta',   'alok.gupta@gmail.com',  'Kolkata'),
(306, 'Akash Roy',    'akash123@hotmail.com',  'Bangalore'),
(307, 'test_user',    'ajay.test@gmail.com',   'Chennai');

EXPECTED OUTPUT:
customer_id | customer_name | email                 | city
------------+---------------+-----------------------+--------
301         | Amit Sharma   | amit.sharma@gmail.com | Delhi
305         | Alok Gupta    | alok.gupta@gmail.com  | Kolkata
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    customer_id, 
    customer_name, 
    email, 
    city 
FROM customers 
WHERE customer_name LIKE 'A%' 
  AND email LIKE '%@gmail.com' 
  AND email NOT LIKE '%test%';

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Wildcard Anchor Rules:
   - `LIKE 'A%'` anchors at the beginning and can utilize an index range scan (B-Tree).
   - `LIKE '%@gmail.com'` has a leading wildcard `%`, forcing the engine to scan 
     characters from the right or perform a full table scan unless a reverse-string 
     index or trigram index (pg_trgm) is available.

2. Negation (`NOT LIKE`):
   `NOT LIKE '%test%'` eliminates any records containing the substring anywhere in 
   the string.
===============================================================================
*/
