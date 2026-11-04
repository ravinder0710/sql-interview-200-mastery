# ⚡ SQL Technical Interview Quick Revision Notes
### Target Role: Data Analyst / SQL Developer (0 — 2 Years Experience)
*Structured by real-world business scenarios, core database execution mechanics, interviewer trap analysis, and candidate defense statements.*

---

## 📌 Block 01: Foundations & Data Filtering (Q001 — Q010)

---

### 🔹 Q001: Strict Numeric Boundary Filtering & Column Projection
* **SQL Query**:
  ```sql
  SELECT emp_id, emp_name, department, salary 
  FROM employees 
  WHERE salary > 60000;
  ```
* **🏢 Real Business Scenario**:
  HR compensation audit and tax withholding review to identify all employees earning above a strict 60,000 threshold.
* **⚙️ Execution Lifecycle**:
  `FROM employees` $\longrightarrow$ `WHERE salary > 60000` $\longrightarrow$ `SELECT emp_id, emp_name, department, salary`.
* **⚠️ Common Interview Trap**:
  *Trap*: "What happens if you use `SELECT *`? And is an employee earning exactly 60,000 included?"  
  *Risk*: Boundary values ($\le 60000$) must be strictly excluded. `SELECT *` creates buffer cache bloat on large tables.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Selecting explicit columns minimizes disk I/O and network payload, allowing the database query optimizer to leverage a **Covering Index (Index-Only Scan)**. Using strict inequality (`> 60000`) guarantees that exact boundary matches are excluded, satisfying the compliance audit specification."*

---

### 🔹 Q002: String Inequality (`<>` / `!=`) & The Famous NULL Trap
* **SQL Query**:
  ```sql
  SELECT order_id, customer_name, order_status, order_amount 
  FROM orders 
  WHERE order_status <> 'Delivered' 
    AND payment_type = 'Online';
  ```
* **🏢 Real Business Scenario**:
  E-commerce operations tracking undelivered prepaid orders across pending, processing, or cancelled states for triage.
* **⚙️ Execution Lifecycle**:
  Filters online orders and excludes 'Delivered' statuses according to ANSI Three-Valued Logic.
* **⚠️ Common Interview Trap**:
  *Trap*: "If a new order has a `NULL` status due to ingestion lag, does your query return it?"  
  *Risk*: `NULL <> 'Delivered'` yields `UNKNOWN`. Because `WHERE` filters only accept `TRUE`, NULL rows are silently eliminated!
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"In ANSI SQL, inequality comparisons against NULL evaluate to UNKNOWN, causing silent row omission. To defensively handle unassigned or NULL states in production pipelines, we encapsulate the condition as `(order_status <> 'Delivered' OR order_status IS NULL)`."*

---

### 🔹 Q003: Set Membership (`IN`) & Inclusive Range (`BETWEEN`)
* **SQL Query**:
  ```sql
  SELECT product_id, product_name, category, price, stock_qty 
  FROM products 
  WHERE category IN ('Electronics', 'Appliances') 
    AND price BETWEEN 1000 AND 10000 
    AND stock_qty > 0;
  ```
* **🏢 Real Business Scenario**:
  Curating promotional catalog items within a specific price bracket and available stock.
* **⚙️ Execution Lifecycle**:
  Evaluates in-memory hash set lookup for `IN`, applies inclusive range on `BETWEEN`, and enforces `stock_qty > 0`.
* **⚠️ Common Interview Trap**:
  *Trap*: "Does `BETWEEN` include the 1,000 and 10,000 boundary values? Does it use indexes?"  
  *Risk*: Both boundaries are strictly inclusive. Both predicates are SARGable and support B-Tree index scans.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Both `IN` and `BETWEEN` are SARGable predicates that preserve B-Tree Index Range Scans. The query optimizer handles `IN` via an in-memory hash lookup, while `BETWEEN` deterministically includes both lower and upper boundary bounds."*

---

### 🔹 Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)
* **SQL Query**:
  ```sql
  SELECT customer_id, customer_name, email, city 
  FROM customers 
  WHERE customer_name LIKE 'A%' 
    AND email LIKE '%@gmail.com' 
    AND email NOT LIKE '%test%';
  ```
* **🏢 Real Business Scenario**:
  Customer marketing campaign targeting valid Gmail users while cleansing internal sandbox and test accounts.
* **⚙️ Execution Lifecycle**:
  Applies prefix seek on name, scans domain suffix on email, and drops records containing 'test'.
* **⚠️ Common Interview Trap**:
  *Trap*: "Between `LIKE 'A%'` and `LIKE '%@gmail.com'`, which query is slow on a 10-million row table and why?"  
  *Risk*: Leading wildcards (`%@gmail.com`) invalidate B-Tree indexes and trigger Full Table Scans.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Prefix searches like `LIKE 'A%'` are index-friendly and execute via B-Tree Index Range Seeks. Conversely, leading wildcards like `LIKE '%@gmail.com'` force expensive Full Table Scans unless accelerated by Trigram GIN indexes or full-text catalogs in production."*

---

### 🔹 Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` vs `OR`)
* **SQL Query**:
  ```sql
  SELECT rep_id, rep_name, salary, commission_pct, manager_id 
  FROM sales_reps 
  WHERE salary >= 50000 
    AND is_active = TRUE 
    AND (commission_pct IS NULL OR manager_id IS NULL);
  ```
* **🏢 Real Business Scenario**:
  HR audit identifying active sales representatives with missing compensation policies or unassigned managers.
* **⚙️ Execution Lifecycle**:
  Operator precedence evaluates $\mathbf{NOT} \longrightarrow \mathbf{AND} \longrightarrow \mathbf{OR}$. Parentheses isolate the logical `OR` block.
* **⚠️ Common Interview Trap**:
  *Trap*: "What happens if you remove the parentheses around the OR condition?"  
  *Risk*: `AND` binds first. Inactive reps or low-wage workers missing a manager would leak into the output.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Because logical AND takes precedence over OR in SQL evaluation hierarchy, wrapping compound OR conditions inside parentheses is mandatory to prevent logic leaks. Furthermore, equality checks against NULL require explicit `IS NULL` rather than `= NULL`."*

---

### 🔹 Q006: Multi-Column Priority Sorting & Tie-Breaking (`ORDER BY`)
* **SQL Query**:
  ```sql
  SELECT appointment_id, patient_name, doctor_id, priority_score, appointment_time 
  FROM patient_appointments 
  WHERE status = 'Waiting' 
  ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC;
  ```
* **🏢 Real Business Scenario**:
  Hospital triage queue displaying waiting patients by physician, clinical urgency score, and arrival timestamp.
* **⚙️ Execution Lifecycle**:
  Hierarchical evaluation: primary grouping by doctor, secondary ordering by urgency, tertiary tie-breaker by arrival time.
* **⚠️ Common Interview Trap**:
  *Trap*: "Is using positional indexes like `ORDER BY 3, 4 DESC, 5` safe for production?"  
  *Risk*: Schema changes in the `SELECT` list silently scramble sorting logic.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Multi-column sorting evaluates criteria sequentially, using secondary keys strictly as deterministic tie-breakers. Specifying explicit column identifiers rather than positional ordinals is essential for maintainability and prevents pipeline corruption when schemas evolve."*

---

### 🔹 Q007: Top-N Truncation & Dialects (`LIMIT`, `TOP`, `FETCH FIRST`)
* **SQL Query**:
  ```sql
  SELECT song_id, title, artist, total_streams 
  FROM songs 
  WHERE release_year >= 2023 
  ORDER BY total_streams DESC 
  LIMIT 3;
  ```
* **🏢 Real Business Scenario**:
  Spotlight banner featuring the Top 3 most-streamed viral music releases from 2023 onwards.
* **⚙️ Execution Lifecycle**:
  Filters by release year, applies Top-N priority heap sort, and truncates upon reaching 3 rows.
* **⚠️ Common Interview Trap**:
  *Trap*: "How does `LIMIT 3` handle ties when two songs share identical stream counts?"  
  *Risk*: Standard `LIMIT` truncates ties arbitrarily. Use `TOP 3 WITH TIES` (T-SQL) or `DENSE_RANK()` (ANSI SQL) to retain tied ranks.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"When backed by an index on the sort key, `LIMIT` enables a fast Top-N heapsort without sorting the full dataset. To resolve ties deterministically in production reporting, we leverage window ranking functions like `DENSE_RANK()`."*

---

### 🔹 Q008: Nth Highest Value via Pagination (`LIMIT 1 OFFSET N-1` + `DISTINCT`)
* **SQL Query**:
  ```sql
  SELECT DISTINCT price AS second_highest_price 
  FROM properties 
  WHERE city = 'Bangalore' 
  ORDER BY price DESC 
  LIMIT 1 OFFSET 1;
  ```
* **🏢 Real Business Scenario**:
  Property benchmark modeling calculating the distinct second-highest real estate valuation in a metropolitan market.
* **⚙️ Execution Lifecycle**:
  Formula: $\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$. Deduplicates unique prices, sorts descending, skips 1 row, and takes 1 row.
* **⚠️ Common Interview Trap**:
  *Trap*: "What happens without `DISTINCT` if two properties share the highest price? What if only 1 property exists?"  
  *Risk*: Without `DISTINCT`, duplicate top values return the maximum price again. If fewer than N rows exist, wrap in an outer scalar query to return `NULL`.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Retrieving the true Nth highest metric requires deduplicating values via `DISTINCT` prior to offset evaluation. Wrapping the paginated query inside an outer scalar projection ensures that if fewer than N records exist, the database gracefully returns a single row with NULL."*

---

### 🔹 Q009: Calculated Columns, Arithmetic Precedence & Integer Division
* **SQL Query**:
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
* **🏢 Real Business Scenario**:
  Reconciling net revenue after discounts and net profit margins across completed order line items.
* **⚙️ Execution Lifecycle**:
  Calculates discount factor using floating-point arithmetic, projects net revenue, and subtracts total COGS for net profit.
* **⚠️ Common Interview Trap**:
  *Trap*: "Why use `100.0` instead of integer `100`? Can you reuse the `net_revenue` alias in the profit calculation?"  
  *Risk*: Integer division truncates fractions to zero (`15 / 100 = 0`). Column aliases cannot be referenced within the same `SELECT` pass.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"We enforce explicit decimal precision using literals like `100.0` to avoid catastrophic integer division truncation. Furthermore, because column aliases in standard ANSI SQL cannot be accessed within the same projection pass, modularizing calculations with CTEs prevents formula duplication."*

---

### 🔹 Q010: Scalar Math Functions (`ROUND`, `CEIL`, `FLOOR`) & CTE Decomposition
* **SQL Query**:
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
* **🏢 Real Business Scenario**:
  FinTech lending platform computing loan repayment schedules and monthly installment obligations without fractional shortfall.
* **⚙️ Execution Lifecycle**:
  CTE decomposes interest calculation into an isolated layer, followed by outer sum aggregation and `CEIL()` installment rounding.
* **⚠️ Common Interview Trap**:
  *Trap*: "Why is `CEIL()` preferred over `ROUND()` for EMI calculation? What is the production benefit of CTEs?"  
  *Risk*: Standard rounding causes cumulative fractional penny loss across tenure. `CEIL()` guarantees full principal and interest recovery.
* **💬 Candidate's Defense (1–2 Yrs Exp Style)**:
  > *"Financial installment engines deploy `CEIL()` rather than standard rounding to guarantee that total realized collections never fall short of contracted principal and accrued interest. Implementing this logic via Common Table Expressions (CTEs) provides modular separation of concerns and significantly improves maintainability."*

---
*(Curriculum continues with Q011 to Q015...)*
