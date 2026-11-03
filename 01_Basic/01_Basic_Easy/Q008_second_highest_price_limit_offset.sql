/*
===============================================================================
Question ID: Q008
Category: 01_Basic / 01_Basic_Easy
Topic: Nth Highest Value via LIMIT / OFFSET & De-duplication (DISTINCT)
Difficulty: Easy
SQL Standard: ANSI SQL Compatible (PostgreSQL, MySQL, SQLite)
===============================================================================

PROBLEM STATEMENT:
A real estate analytics team wants to determine the 2nd highest distinct property 
price in the city of 'Bangalore' to benchmark luxury segment valuations. 
Ensure duplicate highest prices are collapsed so the true runner-up price is retrieved. 
Display the price aliased as `second_highest_price`.

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
(803, 'Sobha Dream Acres',  'Bangalore', 45000000.00),
(804, 'Brigade Gateway',    'Bangalore', 32000000.00),
(805, 'DLF Magnolias',      'Gurgaon',   95000000.00),
(806, 'Purva Palm Beach',   'Bangalore', 28000000.00),
(807, 'Total Environment',  'Bangalore', 41000000.00);

EXPECTED OUTPUT:
second_highest_price
---------------------
41000000.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT DISTINCT 
    price AS second_highest_price 
FROM properties 
WHERE city = 'Bangalore' 
ORDER BY price DESC 
LIMIT 1 OFFSET 1;

-- 💡 ALTERNATIVE SYNTAX (SQL Server / T-SQL):
-- SELECT DISTINCT price AS second_highest_price 
-- FROM properties 
-- WHERE city = 'Bangalore' 
-- ORDER BY price DESC 
-- OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. The Duplicate Tie Trap:
   Without `DISTINCT`, if the top price is tied across multiple rows, 
   `OFFSET 1` will merely return another instance of the 1st highest price.

2. Nth Highest Mathematical Pattern:
   To retrieve the Nth distinct value using pagination:
   `LIMIT 1 OFFSET (N - 1)` ordered `DESC`.

3. Missing Value Edge Case:
   If fewer than N distinct values exist, this query returns an empty result set (0 rows). 
   To return NULL instead when no 2nd value exists, wrap the entire statement inside 
   a scalar subquery: `SELECT (SELECT DISTINCT price FROM ... LIMIT 1 OFFSET 1) AS second_highest;`
===============================================================================
*/
