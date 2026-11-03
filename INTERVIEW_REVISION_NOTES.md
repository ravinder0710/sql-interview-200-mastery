# 🧠 SQL Interview Master Revision Cheatsheet
### (Quick Formula, Interview Explanations & Gotchas)

---

## 📌 Q001: Column Projection & Numeric Boundary Filter
* **Core Concept**: `SELECT col1, col2` instead of `SELECT *`, strict inequality `>`.
* **Formula / Syntax**:
  ```sql
  SELECT col1, col2 FROM table_name WHERE numeric_col > value;
  ```
* **What to tell Interviewer**:
  - *"We explicitly project required columns to avoid unnecessary memory/network overhead and allow covering index optimization."*
  - *"Strict inequality `>` excludes exact boundary matches, adhering strictly to 'greater than' requirements."*
* **Trap to Avoid**: Do not confuse `>` with `>=` when boundary values are present.

---

## 📌 Q002: String Inequality (`<>` vs `!=`) & The NULL Trap
* **Core Concept**: Negation filtering on status/category strings.
* **Formula / Syntax**:
  ```sql
  WHERE status <> 'Delivered' AND type = 'Online'
  ```
* **What to tell Interviewer**:
  - *"`<>` is the strict ANSI standard for inequality, though `!=` is supported by all modern engines."*
* **Trap to Avoid (The NULL Trap)**:
  - In SQL, `NULL <> 'Delivered'` yields **UNKNOWN (False)**. If status allows NULLs, they will be dropped unless handled: `WHERE (status <> 'Delivered' OR status IS NULL)`.

---

## 📌 Q003: Multi-Value Inclusion (`IN`) & Range (`BETWEEN`)
* **Core Concept**: Set inclusion and continuous range checking.
* **Formula / Syntax**:
  ```sql
  WHERE category IN ('A', 'B') AND price BETWEEN 1000 AND 10000 AND stock > 0
  ```
* **What to tell Interviewer**:
  - *"`IN (...)` is cleaner and converted into hash lookups by optimizers compared to chained ORs."*
  - *"`BETWEEN low AND high` is inclusive on both boundaries (`>= low AND <= high`) and is fully SARGable on indexed columns."*
* **Trap to Avoid**: Remember that `BETWEEN` includes both 1000 and 10000.

---

## 📌 Q004: Wildcard Pattern Matching (`LIKE` & `NOT LIKE`)
* **Core Concept**: Substring and prefix/suffix searches.
* **Formula / Syntax**:
  ```sql
  WHERE name LIKE 'A%' AND email LIKE '%@gmail.com' AND email NOT LIKE '%test%'
  ```
* **What to tell Interviewer**:
  - *"`%` matches zero or more characters; `_` matches exactly one character."*
  - *"`LIKE 'A%'` anchors at the start and can use B-Tree index seek. `LIKE '%@gmail.com'` has a leading `%` and requires full column scan."*
* **Trap to Avoid**: `LIKE '@gmail.com'` without leading `%` only matches the literal `@gmail.com` with no username! Always write `'%@gmail.com'`.

---

## 📌 Q005: NULL Handling (`IS NULL`) & Boolean Precedence (`AND` vs `OR`)
* **Core Concept**: Three-valued logic (NULL) and parentheses grouping.
* **Formula / Syntax**:
  ```sql
  WHERE is_active = TRUE 
    AND salary >= 50000 
    AND (commission_pct IS NULL OR manager_id IS NULL)
  ```
* **What to tell Interviewer**:
  - *"In SQL, `AND` has higher precedence than `OR` (similar to multiplication over addition). Parentheses are mandatory when combining `OR` with `AND`."*
  - *"Never use `= NULL` or `!= NULL` because NULL cannot be compared. Always use `IS NULL` or `IS NOT NULL`."*
* **Trap to Avoid**: Writing `cond1 AND cond2 AND (A IS NULL AND B IS NULL)` when the requirement asks for **either** A or B being missing.
