# ⚡ SQL Interview Revision Cheat Sheet (200 Mastery)
### (Target: Fresher & Data Analyst | 0 — 2 Years Experience)

---

## 📌 Block 01: Foundations & Data Filtering

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
  SELECT col1, col2 FROM table_name 
  WHERE status_col <> 'Delivered' AND payment_type = 'Online';
  ```
* **Interviewer Trap (Most Important)**:
  * In SQL Three-Valued Logic (`TRUE`, `FALSE`, `UNKNOWN`), `NULL <> 'Delivered'` yields `UNKNOWN` (treated as FALSE in `WHERE`).
  * If a column has `NULL` values and you filter `WHERE status <> 'Delivered'`, **all NULL rows will be silently dropped!**
* **Interviewer Ko Kya Bolna Hai (Interview Answer)**:
  > *"`<>` is the strict ANSI standard for inequality. If the column allows NULLs and we want unassigned rows included, we must explicitly write `(status <> 'Delivered' OR status IS NULL)`."*

---
*(Updates live after each solved question!)*
