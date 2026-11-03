/*
===============================================================================
Question ID: Q008
Category: 01_Basic / 01_Basic_Easy
Topic: Pagination with OFFSET & Finding Nth Extreme Value (LIMIT 1 OFFSET N-1 with DISTINCT)
Difficulty: Easy
SQL Standard: ANSI SQL / PostgreSQL / MySQL
===============================================================================

PROBLEM STATEMENT:
A real estate analytics team wants to determine the second highest unique property 
price in 'Bangalore' city to benchmark luxury housing tiers. 
Retrieve exactly one column named `second_highest_price`.

TABLE SCHEMA:
properties (
    property_id INT PRIMARY KEY,
    property_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    price DECIMAL(12, 2) NOT NULL
);

SAMPLE DATA:
INSERT INTO properties (property_id, property_name, city, price) VALUES
(801, 'Prestige Golfshire', 'Bangalore', 45000000.00),
(802, 'Godrej Woods',       'Noida',     38000000.00),
(803, 'Sobha Dream Acres',   'Bangalore', 45000000.00),
(804, 'Brigade Gateway',     'Bangalore', 32000000.00),
(805, 'DLF Magnolias',       'Gurgaon',   95000000.00),
(806, 'Purva Palm Beach',    'Bangalore', 28000000.00),
(807, 'Total Environment',   'Bangalore', 41000000.00);

EXPECTED OUTPUT:
second_highest_price
--------------------
41000000.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT DISTINCT price AS second_highest_price 
FROM properties 
WHERE city = 'Bangalore' 
ORDER BY price DESC 
LIMIT 1 OFFSET 1;

-- 💡 INTERVIEW VARIANT (Return NULL if 2nd highest does not exist):
-- SELECT (
--     SELECT DISTINCT price 
--     FROM properties 
--     WHERE city = 'Bangalore' 
--     ORDER BY price DESC 
--     LIMIT 1 OFFSET 1
-- ) AS second_highest_price;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Deduplication before Offsetting:
   Without `DISTINCT`, if multiple rows share the maximum price, `OFFSET 1` 
   returns another row holding the 1st maximum price rather than the true 2nd highest.

2. Nth-Value Pagination Formula:
   To fetch the Nth highest value: `ORDER BY col DESC LIMIT 1 OFFSET (N - 1)`.

3. Scalar Subquery for NULL Fallback:
   When `LIMIT 1 OFFSET 1` encounters fewer than 2 rows, it returns an empty set. 
   Wrapping the query in an outer `SELECT (...)` returns `NULL`, satisfying 
   strict interview test cases (e.g. LeetCode 176).
===============================================================================
*/
