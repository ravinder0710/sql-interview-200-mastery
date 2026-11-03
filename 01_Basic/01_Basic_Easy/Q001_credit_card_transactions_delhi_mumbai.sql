/*
===============================================================================
Question ID: Q001
Title: Filter High-Value Credit Card Transactions in Delhi & Mumbai
Category: 01_Basic -> 01_Basic_Easy
Topic: Basic Filtering (WHERE, IN, AND, ORDER BY)
Difficulty: Easy
Target Role: Data Analyst / SQL Developer (2+ Years)
===============================================================================

BUSINESS SCENARIO:
The marketing analytics team wants to target high-value credit card customers.
Retrieve customers from 'Delhi' and 'Mumbai' who paid via 'Credit Card' 
with a transaction amount of 5000 or more, sorted by amount in descending order.

TABLE SCHEMA:
transactions (
    transaction_id INT,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    payment_mode VARCHAR(50),
    amount DECIMAL(10,2),
    transaction_date DATE
);

SAMPLE DATA:
INSERT INTO transactions VALUES
(101, 'Rahul Sharma', 'Delhi', 'Credit Card', 7500.00, '2024-01-15'),
(102, 'Priya Patel', 'Mumbai', 'UPI', 6200.00, '2024-01-16'),
(103, 'Amit Verma', 'Delhi', 'Debit Card', 4500.00, '2024-01-17'),
(104, 'Sneha Roy', 'Mumbai', 'Credit Card', 12000.00, '2024-01-18'),
(105, 'Rohit Singh', 'Bangalore', 'Credit Card', 9000.00, '2024-01-19'),
(106, 'Ananya Das', 'Delhi', 'Credit Card', 3200.00, '2024-01-20'),
(107, 'Vikram Malhotra', 'Delhi', 'Credit Card', 8500.00, '2024-01-21');

EXPECTED OUTPUT:
customer_name    | city   | amount
Sneha Roy        | Mumbai | 12000.00
Vikram Malhotra  | Delhi  | 8500.00
Rahul Sharma     | Delhi  | 7500.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    customer_name,
    city,
    amount
FROM transactions
WHERE city IN ('Delhi', 'Mumbai')
  AND payment_mode = 'Credit Card'
  AND amount >= 5000
ORDER BY amount DESC;

/*
===============================================================================
INTERVIEW TAKEAWAY:
- Common Trap: Adding SUM(amount) without a GROUP BY clause causes a SQL syntax 
  error ('column must appear in the GROUP BY clause or be used in an aggregate function').
- Since question asks for individual transaction records, no aggregation (SUM) 
  or GROUP BY is needed.
- If the interviewer asks for 'total spent by customer', only then use:
  GROUP BY customer_name, city with SUM(amount).
===============================================================================
*/
