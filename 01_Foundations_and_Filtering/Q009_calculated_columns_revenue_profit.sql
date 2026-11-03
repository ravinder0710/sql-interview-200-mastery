/*
===============================================================================
Question ID: Q009
Category: 01_Basic / 01_Basic_Easy
Topic: Calculated Columns, Arithmetic Precedence & Integer Division Prevention
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
A retail store finance manager requires a profitability report for all 'Completed' orders.
For each item, compute:
1. Net Revenue: (unit_price * quantity) - ((unit_price * quantity) * (discount_pct / 100.0))
2. Total Profit: Net Revenue - (cost_price * quantity)

Display item ID, item name, net revenue, and profit. 
Sort the results by profit in descending order.

TABLE SCHEMA:
order_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    discount_pct DECIMAL(5, 2) NOT NULL,
    order_status VARCHAR(30) NOT NULL
);

SAMPLE DATA:
INSERT INTO order_items (item_id, item_name, unit_price, cost_price, quantity, discount_pct, order_status) VALUES
(901, 'Gaming Mouse',        2000.00, 1200.00, 2, 10.00, 'Completed'),
(902, 'Mechanical Keyboard', 5000.00, 3000.00, 1, 20.00, 'Completed'),
(903, 'USB-C Cable',          500.00,  200.00, 3,  0.00, 'Refunded'),
(904, 'Wireless Headset',    4000.00, 2500.00, 2, 15.00, 'Completed'),
(905, 'Monitor Stand',       1500.00,  900.00, 1,  5.00, 'Pending'),
(906, 'Mousepad RGB',        1000.00,  400.00, 4,  0.00, 'Completed');

EXPECTED OUTPUT:
item_id | item_name           | net_revenue | profit
--------+---------------------+-------------+--------
906     | Mousepad RGB        | 4000.00     | 2400.00
904     | Wireless Headset    | 6800.00     | 1800.00
901     | Gaming Mouse        | 3600.00     | 1200.00
902     | Mechanical Keyboard | 4000.00     | 1000.00
===============================================================================
*/

-- 🚀 SOLUTION:
SELECT 
    item_id, 
    item_name, 
    ((unit_price * quantity) - (unit_price * quantity) * (discount_pct / 100.0)) AS net_revenue,
    (((unit_price * quantity) - (unit_price * quantity) * (discount_pct / 100.0)) - (cost_price * quantity)) AS profit
FROM order_items 
WHERE order_status = 'Completed' 
ORDER BY profit DESC;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Integer Division Hazard:
   Dividing integers by `100` in engines like SQL Server or PostgreSQL truncates 
   the fractional portion (e.g. `15 / 100 = 0`). Explicitly dividing by `100.0` 
   forces decimal coercion and preserves precision.

2. Alias Scope Limitations:
   In ANSI SQL, a column alias declared in the SELECT clause (e.g., `net_revenue`) 
   cannot be referenced within the same SELECT statement. To avoid formula repetition 
   in complex queries, a Common Table Expression (CTE) is standard practice.

3. ORDER BY Alias Resolution:
   Because `ORDER BY` is logically evaluated AFTER `SELECT`, referencing the 
   computed alias `ORDER BY profit DESC` is fully valid in standard SQL.
===============================================================================
*/
