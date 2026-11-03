/*
===============================================================================
Question ID: Q002
Category: 01_Basic / 01_Basic_Easy
Topic: String Inequality (<> / !=) and Multi-condition AND Filtering
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
A food delivery operations team needs to extract all non-delivered orders 
(Cancelled, In Transit, Pending) paid via 'Online' payment mode. 
Display order ID, customer name, order status, and order amount.

TABLE SCHEMA:
orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    order_amount DECIMAL(10, 2) NOT NULL
);

SAMPLE DATA:
INSERT INTO orders (order_id, customer_name, order_status, payment_type, order_amount) VALUES
(5001, 'Vikas Jain',    'Delivered',  'Online', 450.00),
(5002, 'Meera Sen',     'Cancelled',  'Online', 1200.00),
(5003, 'Arjun Kapoor',  'In Transit', 'Online', 850.00),
(5004, 'Deepa Shah',    'In Transit', 'COD',    600.00),
(5005, 'Tarun Malik',   'Delivered',  'COD',    350.00),
(5006, 'Ritu Garg',     'Pending',    'Online', 990.00),
(5007, 'Manish Paul',   'Cancelled',  'COD',    510.00);

EXPECTED OUTPUT:
order_id | customer_name | order_status | order_amount
---------+---------------+--------------+-------------
5002     | Meera Sen     | Cancelled    | 1200.00
5003     | Arjun Kapoor  | In Transit   | 850.00
5006     | Ritu Garg     | Pending      | 990.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    order_id, 
    customer_name, 
    order_status, 
    order_amount 
FROM orders 
WHERE order_status <> 'Delivered' 
  AND payment_type = 'Online';

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Inequality Operators:
   `<>` is the strict ANSI standard for inequality, whereas `!=` is widely 
   supported in modern SQL engines (Postgres, MySQL, SQL Server, Snowflake).

2. Three-Valued Logic & The NULL Trap:
   In SQL, evaluating `NULL <> 'Delivered'` yields UNKNOWN (not TRUE). 
   If the status column allows NULLs and those rows are desired, explicit 
   `OR order_status IS NULL` handling is mandatory.

3. SARGability & Index Usage:
   Inequality filters (`<>`) generally cannot utilize standard B-Tree index seeks 
   and typically lead to an Index/Table Scan unless a partial/filtered index is created.
===============================================================================
*/
