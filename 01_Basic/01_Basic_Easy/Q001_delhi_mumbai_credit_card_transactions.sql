/*
===============================================================================
Question ID: Q001
Category: Basic Easy (01/50)
Title: High-Value Credit Card Transactions in Metro Cities
Difficulty: Easy
Concepts: SELECT, WHERE, IN, AND, ORDER BY, Aliases
===============================================================================

PROBLEM STATEMENT:
Fetch customer name, city, and amount for customers from 'Delhi' or 'Mumbai' 
who paid using 'Credit Card' and whose transaction amount is >= 5000.
Sort the result by amount in descending order.

TABLE SCHEMA:
transactions (
    transaction_id INT,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    payment_mode VARCHAR(50),
    amount DECIMAL(10, 2),
    transaction_date DATE
);
===============================================================================
*/

-- 🚀 SOLUTION (Row-Level Transaction Filter):
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
-------------------------------------------------------------------------------
💡 INTERVIEW TAKEAWAYS & CRITIQUE:
-------------------------------------------------------------------------------
1. Filter Condition Trap:
   - 'payment_mode = Credit Card' condition ko miss nahi karna hai.
2. Row-Level vs Aggregation:
   - Question me single transactions >= 5000 poocha tha, isliye GROUP BY ki zaroorat nahi thi.
3. ANSI SQL Standard Rule on HAVING:
   - Agar GROUP BY lagate hain, toh SQL Server/Postgres me HAVING ke andar column alias (total_amount)
     direct use nahi kar sakte, wahan `HAVING SUM(amount) >= 5000` likhna padta hai.
-------------------------------------------------------------------------------
*/
