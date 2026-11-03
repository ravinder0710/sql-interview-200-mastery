/*
===============================================================================
Question ID: Q010
Category: 01_Basic / 01_Basic_Easy
Topic: Scalar Math Functions (ROUND, CEIL / CEILING) & Clean CTE Decomposition
Difficulty: Easy
SQL Standard: ANSI SQL Compatible
===============================================================================

PROBLEM STATEMENT:
A FinTech lending company requires an amortization breakdown for all 'Approved' loans:
1. Total Interest: ROUND(principal * (annual_rate / (12.0 * 100.0)) * tenure_months, 2)
2. Total Repayment: principal + total_interest
3. Monthly EMI: CEIL(total_repayment / tenure_months) (Rounded UP to nearest whole rupee)

Display loan ID, borrower name, total interest, total repayment, and monthly EMI.
Order results by monthly EMI in descending order.

TABLE SCHEMA:
loan_applications (
    loan_id INT PRIMARY KEY,
    borrower_name VARCHAR(100) NOT NULL,
    principal_amount DECIMAL(12, 2) NOT NULL,
    annual_rate DECIMAL(5, 2) NOT NULL,
    tenure_months INT NOT NULL,
    loan_status VARCHAR(30) NOT NULL
);

SAMPLE DATA:
INSERT INTO loan_applications (loan_id, borrower_name, principal_amount, annual_rate, tenure_months, loan_status) VALUES
(1001, 'Rahul Mehra',   120000.00, 12.00, 12, 'Approved'),
(1002, 'Shweta Tiwari',  50000.00, 14.00,  6, 'Approved'),
(1003, 'Alok Verma',    200000.00, 10.50, 24, 'Rejected'),
(1004, 'Kavita Sen',     80000.00, 15.00,  9, 'Approved'),
(1005, 'Mohit Suri',    150000.00, 11.00, 18, 'Under Review'),
(1006, 'Tanvi Shah',    300000.00,  9.50, 36, 'Approved');

EXPECTED OUTPUT:
loan_id | borrower_name | total_interest | total_repayment | monthly_emi
--------+---------------+----------------+-----------------+------------
1001    | Rahul Mehra   | 14400.00       | 134400.00       | 11200
1006    | Tanvi Shah    | 85500.00       | 385500.00       | 10709
1004    | Kavita Sen    | 9000.00        | 89000.00        | 9889
1002    | Shweta Tiwari | 3500.00        | 53500.00        | 8917
===============================================================================
*/

-- 🚀 SOLUTION (Modular & Clean using CTE):
WITH loan_interest AS (
    SELECT 
        loan_id,
        borrower_name,
        principal_amount,
        tenure_months,
        ROUND(principal_amount * (annual_rate / (12.0 * 100.0)) * tenure_months, 2) AS total_interest
    FROM loan_applications
    WHERE loan_status = 'Approved'
),
repayment_summary AS (
    SELECT 
        loan_id,
        borrower_name,
        tenure_months,
        total_interest,
        (principal_amount + total_interest) AS total_repayment
    FROM loan_interest
)
SELECT 
    loan_id,
    borrower_name,
    total_interest,
    total_repayment,
    CEIL(total_repayment / tenure_months) AS monthly_emi
FROM repayment_summary
ORDER BY monthly_emi DESC;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Reusing Column Aliases via CTE:
   Standard SQL does not permit referencing a column alias within the same 
   SELECT projection list. Breaking the computation into chained CTEs ensures 
   zero formula redundancy while keeping the code maintainable.

2. Rounding Semantics:
   - `ROUND(x, d)`: Rounds to `d` decimal places using half-away-from-zero logic.
   - `CEIL(x)` / `CEILING(x)`: Returns the smallest integer greater than or equal to `x`. 
     Essential in financial installment calculations to ensure total collected >= total owed.

3. Dialect Portability:
   `CEILING()` is universal across PostgreSQL, MySQL, and SQL Server.
   `CEIL()` is supported in PostgreSQL, MySQL, and Oracle.
===============================================================================
*/
