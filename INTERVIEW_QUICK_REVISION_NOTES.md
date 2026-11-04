# ⚡ SQL Interview Revision Cheat Sheet (Deep Theory & Defense Edition)
### (Target: Data Analyst | 0 — 2 Years Experience)

---

## 📌 Block 01: Foundations & Data Filtering (Q001 — Q010)

---

### 🔹 Q001: Strict Numeric Boundary Filtering & Column Projection
* **Syntax / Formula**:
  ```sql
  SELECT emp_id, emp_name, department, salary 
  FROM employees 
  WHERE salary > 60000;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Logical Processing Order**: `FROM` $\rightarrow$ `WHERE` $\rightarrow$ `SELECT`. The query engine first loads the table into memory (`FROM`), filters the row blocks according to the predicate (`WHERE`), and then projects the required columns (`SELECT`).
  2. **Covering Index (Index-Only Scan)**: In production tables with 50+ columns, selecting only explicit columns allows the optimizer to retrieve all requested data directly from the leaf nodes of a secondary B-Tree index without performing an expensive "Table Lookup" or reading data blocks from disk.
* **The Traps to Watch Out For**:
  * **Boundary Inclusion Trap**: Testing `>` vs `>=`. When the business specifies "strictly greater than 60,000", an exact record with 60,000.00 must be excluded.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Sir, I explicitly projected only the required four columns rather than `SELECT *` to eliminate unnecessary memory allocation and network I/O. This enables the database optimizer to perform an Index-Only Scan. Furthermore, I enforced strict inequality (`> 60000`) to respect the business rule and omit boundary matches."*

---

### 🔹 Q002: String Inequality (`<>` / `!=`) & The Famous NULL Trap
* **Syntax / Formula**:
  ```sql
  SELECT order_id, customer_name, order_status, order_amount 
  FROM orders 
  WHERE order_status <> 'Delivered' 
    AND payment_type = 'Online';
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Three-Valued Logic (3VL)**: SQL operates on three boolean states: `TRUE`, `FALSE`, and `UNKNOWN`. Any arithmetic or relational comparison with a `NULL` operand (e.g. `NULL <> 'Delivered'`) evaluates to `UNKNOWN`.
  2. **The WHERE Filter Rule**: The `WHERE` clause strictly filters for rows that evaluate to `TRUE`. Rows evaluating to `FALSE` or `UNKNOWN` are silently rejected.
* **The Traps to Watch Out For**:
  * **The Silent Drop**: If unassigned orders exist where `order_status` is `NULL`, writing `WHERE order_status != 'Delivered'` will drop all NULL records!
  * **Safe Standard**: `WHERE (order_status <> 'Delivered' OR order_status IS NULL)`.
  * **ANSI vs Modern**: `<>` is strict ANSI SQL; `!=` is supported across modern RDBMS (Postgres, MySQL, SQL Server).
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"In standard SQL, comparing any value against NULL results in UNKNOWN rather than TRUE. Therefore, inequality filters like `status <> 'Delivered'` automatically discard NULL rows. If unassigned or pending records are nullable, wrapping with explicit `OR status IS NULL` handling is mandatory to prevent data loss."*

---

### 🔹 Q003: Set Membership (`IN`) & Inclusive Range (`BETWEEN`)
* **Syntax / Formula**:
  ```sql
  SELECT product_id, product_name, category, price, stock_qty 
  FROM products 
  WHERE category IN ('Electronics', 'Appliances') 
    AND price BETWEEN 1000 AND 10000 
    AND stock_qty > 0;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Hash Lookup Optimization**: `category IN ('Electronics', 'Appliances')` is transformed by query optimizers into an internal in-memory hash set lookup ($O(1)$ lookup time), whereas multiple `OR` statements create complex conditional evaluation trees ($O(N)$).
  2. **Inclusive Range Evaluation**: The SQL operator `BETWEEN low AND high` is mathematically equivalent to:
     $$\text{price} \ge \text{low} \quad \mathbf{AND} \quad \text{price} \le \text{high}$$
* **The Traps to Watch Out For**:
  * Believing `BETWEEN` is exclusive. Boundary values (exact 1,000 and 10,000) are fully included.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Both `IN` and `BETWEEN` are SARGable (Search Argument Able) predicates. Because they do not wrap columns inside scalar functions, the engine can execute efficient B-Tree Index Range Scans instead of scanning the full table."*

---

### 🔹 Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)
* **Syntax / Formula**:
  ```sql
  SELECT customer_id, customer_name, email, city 
  FROM customers 
  WHERE customer_name LIKE 'A%' 
    AND email LIKE '%@gmail.com' 
    AND email NOT LIKE '%test%';
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Wildcard Tokens**:
     * `%` matches zero, one, or multiple characters.
     * `_` (single underscore) matches exactly one character.
  2. **Anchor vs Leading Wildcard Index Performance**:
     * `LIKE 'A%'` anchors to the beginning of the string. A B-Tree index can instantly seek to the letter 'A' and scan forward (Index Seek).
     * `LIKE '%@gmail.com'` contains a leading `%`. The engine cannot determine where the string starts, invalidating standard B-Tree indexes and forcing a Full Table Scan.
* **The Traps to Watch Out For**:
  * Writing `LIKE '@gmail.com'` without the leading `%` forces an exact match against literally `"@gmail.com"`, dropping all valid email addresses.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"`LIKE 'A%'` maintains high performance via B-Tree index prefix seeking. Conversely, leading wildcards like `LIKE '%@gmail.com'` degrade performance on large tables unless specialized functional indexes, reverse-string indexes, or trigram indexes (`pg_trgm`) are maintained."*

---

### 🔹 Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` over `OR`)
* **Syntax / Formula**:
  ```sql
  SELECT rep_id, rep_name, salary, commission_pct, manager_id 
  FROM sales_reps 
  WHERE salary >= 50000 
    AND is_active = TRUE 
    AND (commission_pct IS NULL OR manager_id IS NULL);
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Operator Precedence (BODMAS of SQL)**: The logical order of evaluation is:
     $$\mathbf{NOT} \longrightarrow \mathbf{AND} \longrightarrow \mathbf{OR}$$
  2. **Why Parentheses Matter**: Omitting parentheses evaluates the query as:
     $$\mathbf{[}\text{salary} \ge 50000 \text{ AND is\_active = TRUE AND comm IS NULL}\mathbf{]} \quad \mathbf{OR} \quad \mathbf{[}\text{manager\_id IS NULL}\mathbf{]}$$
     This defect leaks inactive employees and employees earning below 50,000 into the report whenever their manager is NULL.
* **The Traps to Watch Out For**:
  * Writing `col = NULL`. In SQL, `NULL = NULL` is UNKNOWN. Equality against NULL is invalid; use strictly `IS NULL` or `IS NOT NULL`.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Because logical AND binds tighter than OR, grouping compound OR conditions inside parentheses is strictly necessary to prevent logic leaks. Furthermore, because NULL represents an absent state rather than a concrete value, standard equality (`= NULL`) fails, requiring the explicit `IS NULL` predicate."*

---

### 🔹 Q006: Multi-Column Sorting & Tie-Breaking (`ORDER BY`)
* **Syntax / Formula**:
  ```sql
  SELECT appointment_id, patient_name, doctor_id, priority_score, appointment_time 
  FROM patient_appointments 
  WHERE status = 'Waiting' 
  ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Hierarchical Sorting**: The query engine sorts by the primary column (`doctor_id`). The secondary column (`priority_score`) and tertiary column (`appointment_time`) are evaluated strictly as tie-breakers when preceding keys are identical.
  2. **Composite Index Sorting**: If a composite index exists on `(status, doctor_id, priority_score DESC, appointment_time)`, the database can read pre-sorted index pages directly, eliminating in-memory sorting overhead (`filesort`).
* **The Traps to Watch Out For**:
  * **Positional Indexing**: Writing `ORDER BY 3 ASC, 4 DESC, 5 ASC`. If someone adds or reorders columns in `SELECT`, the query silently sorts by the wrong business metrics.
  * **NULL Sort Defaults**: PostgreSQL defaults to `NULLS LAST` in ASC, whereas MySQL and SQL Server treat NULLs as the lowest possible values (`NULLS FIRST` in ASC).
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Multi-column sorting evaluates subsequent columns only as tie-breakers when earlier sort keys match. To ensure maintainability, named column references should always be used over positional integers. For high-volume triage tables, aligning composite indexes with sort order eliminates expensive memory sorting."*

---

### 🔹 Q007: Top-N Truncation & Dialect Variations (`LIMIT`, `TOP`, `FETCH FIRST`)
* **Syntax / Formula**:
  ```sql
  SELECT song_id, title, artist, total_streams 
  FROM songs 
  WHERE release_year >= 2023 
  ORDER BY total_streams DESC 
  LIMIT 3;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Top-N Heapsort Optimization**: When `LIMIT n` is paired with an indexed `ORDER BY`, the database does not sort the entire dataset. It utilizes an in-memory priority queue / heapsort and halts scanning immediately upon collecting $n$ qualifying rows.
  2. **Cross-Engine Dialects**:
     * **PostgreSQL / MySQL / SQLite**: `LIMIT n` (end of query).
     * **SQL Server (T-SQL)**: `SELECT TOP n ...` (immediately following SELECT).
     * **Oracle / ANSI SQL:2008**: `OFFSET 0 ROWS FETCH NEXT n ROWS ONLY`.
* **The Traps to Watch Out For**:
  * **The Blind Truncation Trap**: `LIMIT 3` arbitrarily drops tied records if the 3rd and 4th songs share identical stream counts.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"LIMIT executes as the final step in query execution. When backed by a sorted index, the engine executes a fast Top-N heapsort without full table sorting. To handle ties deterministically, T-SQL provides `TOP n WITH TIES`, while standard ANSI SQL uses window ranking functions like `DENSE_RANK()`."*

---

### 🔹 Q008: Nth Extreme Value via Pagination (`LIMIT 1 OFFSET N-1` + `DISTINCT`)
* **Syntax / Formula**:
  ```sql
  SELECT DISTINCT price AS second_highest_price 
  FROM properties 
  WHERE city = 'Bangalore' 
  ORDER BY price DESC 
  LIMIT 1 OFFSET 1;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Offset Formula**:
     $$\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$$
     To retrieve the Nth record, skip the first $N-1$ records and take the immediate next row.
  2. **Deduplication Requirement**: Without `DISTINCT`, if multiple properties tie for the highest price, `OFFSET 1` returns another record with the 1st highest price rather than the true 2nd tier price.
* **The Traps to Watch Out For**:
  * **Empty Set vs NULL (LeetCode 176)**: If the dataset has fewer than N records, `LIMIT 1 OFFSET (N-1)` returns 0 rows (Empty Set). To force SQL to return `NULL`, wrap the entire query in a scalar subquery:
    ```sql
    SELECT (
        SELECT DISTINCT price FROM properties 
        WHERE city = 'Bangalore' ORDER BY price DESC LIMIT 1 OFFSET 1
    ) AS second_highest_price;
    ```
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Finding the Nth distinct value requires deduplication via `DISTINCT` before ordering and applying `LIMIT 1 OFFSET (N - 1)`. Wrapping the expression inside an outer scalar SELECT guarantees a NULL return value if fewer than N qualifying records exist."*

---

### 🔹 Q009: Calculated Columns, Arithmetic Precedence & Integer Division
* **Syntax / Formula**:
  ```sql
  SELECT 
      item_id, 
      item_name, 
      (unit_price * quantity) * (1 - discount_pct / 100.0) AS net_revenue, 
      ((unit_price * quantity) * (1 - discount_pct / 100.0) - (cost_price * quantity)) AS profit 
  FROM order_items 
  WHERE order_status = 'Completed' 
  ORDER BY profit DESC;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Integer Division Truncation**: In strict SQL engines (SQL Server, PostgreSQL), dividing two integer types (`15 / 100`) truncates the fractional decimal component entirely, yielding `0`. Using `100.0` forces automatic decimal type coercion.
  2. **Alias Visibility Scope**: In ANSI SQL, all expressions within the `SELECT` projection list are evaluated conceptually in parallel. Therefore, an alias defined on column 3 cannot be referenced within column 4 of the same SELECT statement.
* **The Traps to Watch Out For**:
  * Missing multiplication operator `*` between bracketed algebraic terms: `(A)(B)` causes syntax errors in SQL; explicit `(A) * (B)` is required.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Always enforce decimal literals like 100.0 in percentage computations to prevent integer division truncation. Because SELECT projections evaluate concurrently, aliases cannot be reused within the same SELECT statement, though they are valid in ORDER BY since sorting runs after projection."*

---

### 🔹 Q010: Scalar Math Functions (`ROUND`, `CEIL`, `FLOOR`) & CTE Decomposition
* **Syntax / Formula**:
  ```sql
  WITH loan_calc AS (
      SELECT 
          loan_id, 
          borrower_name, 
          tenure_months,
          ROUND(principal_amount * (annual_rate / (12.0 * 100.0)) * tenure_months, 2) AS total_interest,
          principal_amount
      FROM loan_applications 
      WHERE loan_status = 'Approved'
  )
  SELECT 
      loan_id, 
      borrower_name, 
      total_interest, 
      (principal_amount + total_interest) AS total_repayment,
      CEIL((principal_amount + total_interest) / tenure_months) AS monthly_emi
  FROM loan_calc 
  ORDER BY monthly_emi DESC;
  ```
* **Deep Theory & Execution Mechanism**:
  1. **Mathematical Function Hierarchy**:
     * `ROUND(x, d)`: Rounds to $d$ decimal places using half-away-from-zero logic.
     * `CEIL(x)` / `CEILING(x)`: Returns the smallest integer $\ge x$ (Rounds up). In banking, EMIs are rounded up to prevent residual penny loss.
     * `FLOOR(x)`: Returns the largest integer $\le x$ (Rounds down).
  2. **Common Table Expression (CTE) Hygiene**: Breaking multi-stage financial calculations into named CTE blocks prevents expression duplication and makes SQL code modular, readable, and easy to debug.
* **The Traps to Watch Out For**:
  * Unmatched parentheses in nested math expressions. Using a CTE isolates intermediate variables, preventing syntax bugs.
* **Interviewer Ko Kya Bolna Hai (Simple Technical Words)**:
  > *"Financial installment algorithms use `CEIL()` to ensure aggregate collections never fall short of principal plus accrued interest. Utilizing Common Table Expressions (CTEs) breaks complex arithmetic into clean logical layers, avoiding formula repetition and making the code enterprise-ready."*

---
*(Updates continuously after each completed milestone!)*
