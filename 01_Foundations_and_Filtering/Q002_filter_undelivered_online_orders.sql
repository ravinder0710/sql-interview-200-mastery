/*
===============================================================================
Question ID: Q002
Curriculum: 200 SQL Interview Mastery Challenge (0 - 2 Years Track)
Block: 01_Foundations_and_Filtering
Company Tag: Amazon / Swiggy / Zomato / E-Commerce Operations
Topic: String Inequality (<> / !=), Boolean AND Filtering, and The NULL Trap
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
A food delivery operations team needs to extract all non-delivered orders 
(Cancelled, In Transit, Pending) paid via 'Online' payment mode for tracking. 
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
   `<>` is strict ANSI SQL standard; `!=` is supported across PostgreSQL, 
   MySQL, SQL Server, and Snowflake.

2. Three-Valued Logic & NULL Drop:
   `NULL <> 'Delivered'` yields UNKNOWN (treated as FALSE in WHERE clause).
   If NULL statuses exist and must be included, explicit `OR order_status IS NULL` 
   handling is mandatory.

3. SARGability:
   Inequality filters cannot use B-Tree index seeks and typically trigger a 
   full table or index scan unless filtered/partial indexes are created.
===============================================================================
*/
