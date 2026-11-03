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
*(Updates live after each solved question!)*
