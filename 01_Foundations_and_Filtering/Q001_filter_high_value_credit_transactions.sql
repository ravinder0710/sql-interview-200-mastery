/*
===============================================================================
Question ID: Q001
Category: 01_Basic / 01_Basic_Easy
Topic: WHERE Filtering with Multi-Conditions (IN, AND, Comparison, ORDER BY)
Difficulty: Easy
===============================================================================

BUSINESS SCENARIO:
An e-commerce marketing team wants to identify high-value credit card 
transactions originating from Metro cities ('Delhi' and 'Mumbai') with 
transaction amount >= 5000, sorted by highest amount first.

TABLE SCHEMA:
transactions (
    transaction_id INT,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    payment_mode VARCHAR(50),
    amount DECIMAL(10, 2),
    transaction_date DATE
)

SAMPLE DATA:
(101, 'Rahul Sharma', 'Delhi',     'Credit Card', 7500.00,  '2024-01-15'),
(102, 'Priya Patel',  'Mumbai',    'UPI',         6200.00,  '2024-01-16'),
(103, 'Amit Verma',   'Delhi',     'Debit Card',  4500.00,  '2024-01-17'),
(104, 'Sneha Roy',    'Mumbai',    'Credit Card', 12000.00, '2024-01-18'),
(105, 'Rohit Singh',  'Bangalore', 'Credit Card', 9000.00,  '2024-01-19'),
(106, 'Ananya Das',   'Delhi',     'Credit Card', 3200.00,  '2024-01-20');

EXPECTED OUTPUT:
customer_name | city   | total_amount
--------------+--------+-------------
Sneha Roy     | Mumbai | 12000.00
Rahul Sharma  | Delhi  | 7500.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    customer_name, 
    city, 
    amount AS total_amount 
FROM transactions 
WHERE city IN ('Delhi', 'Mumbai') 
  AND payment_mode = 'Credit Card' 
  AND amount >= 5000 
ORDER BY total_amount DESC;

/*
LOGIC EXPLANATION:
1. `WHERE city IN ('Delhi', 'Mumbai')`: Restricts search to specified metro cities.
2. `AND payment_mode = 'Credit Card'`: Ensures only credit card mode is filtered.
3. `AND amount >= 5000`: Applies numeric boundary check.
4. `ORDER BY total_amount DESC`: Orders results from highest to lowest transaction value.
*/
