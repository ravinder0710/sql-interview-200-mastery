# ⚡ SQL Interview Revision Cheat Sheet (Zero to Hero)
### (Har Question Ka Core Concept, Interviewer Ka Trap & Exact Answer)

---

## 📌 Category: 01_Basic_Easy

---

### 🔹 Q001: Numeric Boundary & Column Projection
* **Syntax / Formula**:
  ```sql
  SELECT col1, col2 FROM table_name WHERE numeric_col > threshold;
  ```
* **Interviewer Trap**:
  * Testing `>` vs `>=`. When the question specifies "strictly greater than 60,000", an exact 60,000 row is excluded.
* **Interviewer Ko Kya Bolna Hai (Interview Answer)**:
  > *"Avoid `SELECT *` in production/interview queries. Selecting explicit columns reduces I/O bandwidth and allows the database optimizer to use a **Covering Index** (Index-Only Scan)."*
* **Execution Order**:
  `FROM` $\rightarrow$ `WHERE` $\rightarrow$ `SELECT`.

---

### 🔹 Q002: String Inequality (`<>` / `!=`) & The NULL Trap
* **Syntax / Formula**:
  ```sql
  SELECT col1, col2 FROM table_name WHERE status_col <> 'Target' AND type_col = 'Value';
  ```
* **Interviewer Trap (Most Important)**:
  * In SQL Three-Valued Logic (`TRUE`, `FALSE`, `UNKNOWN`), `NULL <> 'Delivered'` yields `UNKNOWN` (treated as FALSE in `WHERE`).
  * If a column has `NULL` values and you filter `WHERE status <> 'Delivered'`, **all NULL rows will be silently dropped!**
* **Interviewer Ko Kya Bolna Hai (Interview Answer)**:
  > *"`<>` is the strict ANSI standard for inequality, though `!=` is supported across modern engines. If the column is nullable and we want unassigned rows, we must explicitly write `(status <> 'Delivered' OR status IS NULL)`."*

---

### 🔹 Q003: Multi-Value Inclusion (`IN`) & Ranges (`BETWEEN`)
* **Syntax / Formula**:
  ```sql
  SELECT col1, col2 FROM table_name 
  WHERE category IN ('A', 'B') 
    AND price BETWEEN low AND high 
    AND stock > 0;
  ```
* **Interviewer Trap**:
  * Forgetting that `BETWEEN low AND high` is **inclusive** on both ends (`>= low AND <= high`).
* **Interviewer Ko Kya Bolna Hai (Interview Answer)**:
  > *"Using `IN ('A', 'B')` is preferred over multiple `OR` conditions because it is more readable and SQL optimizers evaluate set membership via internal hash/list lookups. Both `IN` and `BETWEEN` remain SARGable on indexed columns for B-Tree index range seeks."*

---

### 🔹 Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)
* **Syntax / Formula**:
  ```sql
  SELECT col1, col2 FROM table_name 
  WHERE name LIKE 'A%' 
    AND email LIKE '%@gmail.com' 
    AND email NOT LIKE '%test%';
  ```
* **Interviewer Trap**:
  * Writing `email LIKE '@gmail.com'` without the leading `%`. Without `%`, SQL treats `LIKE` as an exact `=` match.
* **Interviewer Ko Kya Bolna Hai (Interview Answer)**:
  > *"`%` matches zero or more characters, while `_` matches exactly one character. `LIKE 'A%'` can utilize a B-Tree index seek (prefix match), but `LIKE '%@gmail.com'` has a leading wildcard and generally causes a full table scan unless a reverse index or trigram index is configured."*

---

### 🔹 Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` vs `OR`)
* **Syntax / Formula**:
  ```sql
  SELECT col1, col2 FROM table_name 
  WHERE is_active = TRUE 
    AND salary >= 50000 
    AND (commission IS NULL OR manager_id IS NULL);
  ```
* **Interviewer Trap**:
  1. `col = NULL` never matches anything. `NULL = NULL` is UNKNOWN in SQL.
  2. Forgetting parentheses `()` around `OR`. Because `AND` has higher precedence than `OR`, omitting parentheses evaluates `(A AND B AND C) OR D`, allowing inactive or low-salary records where only `D` is true.
* **Interviewer Ko Kya Bolna Hai (Interview Answer)**:
  > *"SQL treats NULL as an unknown state rather than a concrete value, requiring `IS NULL` instead of `= NULL`. Furthermore, since logical `AND` takes precedence over `OR`, wrapping compound `OR` conditions in parentheses is strictly mandatory to prevent logic leakage."*

---
*(Will be updated continuously with every question!)*
