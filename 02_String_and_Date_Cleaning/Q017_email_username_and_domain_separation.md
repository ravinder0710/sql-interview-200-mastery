# Q017: Dynamic String Delimiter Splitting (`INSTR`, `SUBSTRING`, `LEFT`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 017 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an enterprise marketing analytics platform, email subscriber logs contain user addresses of variable character lengths (e.g. `rahul.v@gmail.com`, `ananya@fintech.co`). To analyze corporate domain market share versus consumer mail providers, the business intelligence team requires dynamically isolating the `username` (characters preceding `@`) and the `domain_name` (characters following `@`) for all verified subscribers (`is_verified = TRUE`).

---

## 📊 Sample Mock Table (`subscribers`)

| subscriber_id | full_name | email_address | is_verified |
| :---: | :--- | :--- | :--- |
| 501 | Rahul Varma | rahul.v@gmail.com | True |
| 502 | Ananya Roy | ananya@fintech.co | True |
| 503 | Kunal Sen | kunal_test@yahoo.com | False |
| 504 | Pooja Jain | pooja.jain@enterprise.org | True |
| 505 | Tarun Das | tarun@gmail.com | True |

---

## 🎯 Expected Output

| subscriber_id | full_name | username | domain_name |
| :---: | :--- | :--- | :--- |
| 501 | Rahul Varma | rahul.v | gmail.com |
| 502 | Ananya Roy | ananya | fintech.co |
| 504 | Pooja Jain | pooja.jain | enterprise.org |
| 505 | Tarun Das | tarun | gmail.com |

---

## 💡 Production SQL Solution

```sql
SELECT 
    subscriber_id, 
    full_name, 
    LEFT(email_address, INSTR(email_address, '@') - 1) AS username, 
    SUBSTRING(email_address, INSTR(email_address, '@') + 1) AS domain_name 
FROM subscribers 
WHERE is_verified = TRUE 
ORDER BY subscriber_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Dynamic Delimiter Finding with `INSTR()`:**
   - In variable-length string parsing, fixed offsets cannot be hardcoded.
   - `INSTR(email_address, '@')` dynamically returns the 1-based index position of the `@` delimiter.
   - Username length is computed dynamically as $\text{INSTR} - 1$.
   - Domain start position begins immediately after the delimiter: $\text{INSTR} + 1$.

2. **Cross-Engine Delimiter Functions:**
   - **MySQL / Oracle / SQLite**: `INSTR(string, substring)`
   - **SQL Server (T-SQL)**: `CHARINDEX('@', email_address)` *(Notice arguments are inverted!)*
   - **PostgreSQL**: `POSITION('@' IN email_address)` or `STRPOS(email_address, '@')`

3. **Two-Argument `SUBSTRING()` Feature:**
   - In MySQL and SQLite, invoking `SUBSTRING(string, start_position)` without a third length parameter automatically slices from `start_position` to the very end of the string.
   - In SQL Server, the 3rd argument is mandatory; developers pass `LEN(string)`: `SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email))`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Malformed Email Handling (Missing `@`):**
   - *Interviewer:* "What happens if a dirty record has an invalid email with no `@` symbol?"
   - *Defense:* If `@` is missing, `INSTR()` returns `0`. Evaluating `0 - 1 = -1` in `LEFT(email, -1)` throws a runtime error in some engines (like MySQL) or returns empty. In production, we add a defensive filter `WHERE email_address LIKE '%@%'` or wrap with `CASE WHEN INSTR(...) > 0`.

2. **Trap: Multiple `@` Characters in Input:**
   - *Interviewer:* "If a string somehow contains two `@` signs, which one does `INSTR()` locate?"
   - *Defense:* Standard `INSTR()` always locates the **first** occurrence from the left. To search from the right or handle multiple tokens, we leverage regex functions such as `REGEXP_SUBSTR()` or split via string arrays.
