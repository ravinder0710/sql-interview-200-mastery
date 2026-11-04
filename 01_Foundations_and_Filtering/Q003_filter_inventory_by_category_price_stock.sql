/*
===============================================================================
Question ID: Q003
Curriculum: 200 SQL Interview Mastery Challenge (0 - 2 Years Track)
Block: 01_Foundations_and_Filtering
Company Tag: Flipkart / Amazon Inventory / Retail Supply Chain
Topic: Set Membership (IN), Inclusive Range (BETWEEN), and Stock Verification
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
The warehouse inventory manager requires a filtered catalog of products belonging 
to either 'Electronics' or 'Appliances' categories, with unit prices ranging 
between 1,000 and 10,000 (inclusive), and strictly having available stock (stock_qty > 0). 
Display product ID, product name, category, price, and stock quantity.

TABLE SCHEMA:
products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_qty INT NOT NULL
);

SAMPLE DATA:
INSERT INTO products (product_id, product_name, category, price, stock_qty) VALUES
(201, 'Wireless Earbuds',  'Electronics', 1999.00,  45),
(202, 'Smart Watch',       'Electronics', 999.00,   12),
(203, 'Electric Kettle',   'Appliances',  1450.00,  0),
(204, 'Induction Cooktop', 'Appliances',  3200.00,  18),
(205, 'Running Shoes',     'Apparel',     2499.00,  30),
(206, 'Microwave Oven',    'Appliances',  9999.00,  5),
(207, '4K LED TV',         'Electronics', 34999.00, 8);

EXPECTED OUTPUT:
product_id | product_name      | category    | price   | stock_qty
-----------+-------------------+-------------+---------+----------
201        | Wireless Earbuds  | Electronics | 1999.00 | 45
204        | Induction Cooktop | Appliances  | 3200.00 | 18
206        | Microwave Oven    | Appliances  | 9999.00 | 5
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    product_id, 
    product_name, 
    category, 
    price, 
    stock_qty 
FROM products 
WHERE category IN ('Electronics', 'Appliances') 
  AND price BETWEEN 1000 AND 10000 
  AND stock_qty > 0;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Inclusive Range Boundaries:
   The `BETWEEN low AND high` operator evaluates as `>= low AND <= high`, 
   ensuring boundary values (1,000 and 10,000) are retained.

2. Set Membership Optimization:
   `category IN (...)` simplifies complex OR chains and maps to an efficient 
   in-memory set lookup in modern query engines.

3. SARGability:
   Both `IN` and `BETWEEN` are SARGable predicates that preserve B-Tree index 
   seek and range scan capabilities.
===============================================================================
*/
