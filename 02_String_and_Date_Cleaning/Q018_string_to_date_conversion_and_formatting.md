# Q018: String to Date Conversion & Formatting (`STR_TO_DATE`, `DATE_FORMAT`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 018 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In a banking transactional ingestion pipeline, a legacy core banking system produces daily transaction feeds where transaction dates are stored as plain text in the British/Indian format (`DD/MM/YYYY`, e.g., `'15/10/2023'`). Because string sorting sorts alphabetically (where `'28/09/2023'` comes *after* `'15/10/2023'`), the data analytics team must parse and cast raw date strings into true temporal SQL `DATE` objects to accurately isolate successful transactions (`txn_status = 'Success'`) occurring in Q4 2023.

---

## 📊 Sample Mock Table (`legacy_transactions`)

| txn_id | customer_name | raw_txn_date | amount | txn_status |
| :---: | :--- | :--- | :---: | :--- |
| 101 | Rakesh Varma | 15/10/2023 | 25000.00 | Success |
| 102 | Ananya Roy | 28/09/2023 | 12000.00 | Success |
| 103 | Kunal Sen | 05/11/2023 | 45000.00 | Success |
| 104 | Pooja Jain | 12/12/2023 | 8500.00 | Failed |
| 105 | Tarun Das | 20/12/2023 | 31000.00 | Success |
| 106 | Sunita Patel | 01/01/2024 | 18000.00 | Success |

---

## 🎯 Expected Output

| txn_id | customer_name | standard_date | amount | txn_status |
| :---: | :--- | :---: | :---: | :--- |
| 105 | Tarun Das | 2023-12-20 | 31000.00 | Success |
| 103 | Kunal Sen | 2023-11-05 | 45000.00 | Success |
| 101 | Rakesh Varma | 2023-10-15 | 25000.00 | Success |

---

## 💡 Production SQL Solution

```sql
SELECT 
    txn_id, 
    customer_name, 
    STR_TO_DATE(raw_txn_date, '%d/%m/%Y') AS standard_date, 
    amount, 
    txn_status 
FROM legacy_transactions 
WHERE txn_status = 'Success' 
  AND STR_TO_DATE(raw_txn_date, '%d/%m/%Y') BETWEEN '2023-10-01' AND '2023-12-31' 
ORDER BY 
    standard_date DESC, 
    txn_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why Plain String Filtering Fails on Dates:**
   - Comparing text strings evaluates lexicographical (alphabetical) order:
     `'28/09/2023'` is greater than `'15/10/2023'` simply because `'2'` > `'1'`.
   - Converting to `DATE` data type ensures the database compares chronological Unix epoch values rather than ASCII characters.

2. **Cross-Dialect Parsing Functions:**
   - **MySQL**: `STR_TO_DATE(string, '%d/%m/%Y')`
   - **PostgreSQL / Oracle**: `TO_DATE(string, 'DD/MM/YYYY')`
   - **SQL Server (T-SQL)**: `CONVERT(DATE, string, 103)` *(Style code `103` denotes British/French `DD/MM/YYYY`)*

3. **Format Specifier Mechanics (`%Y` vs `%y`):**
   - `%Y` (uppercase) expects a 4-digit year (e.g. `2023`).
   - `%y` (lowercase) expects a 2-digit year (e.g. `23`).
   - `%m` expects numeric month (01–12), while `%M` expects full month name (`October`). Passing the wrong case throws runtime conversion errors or yields `NULL`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Inverted Format Specifier (`%m/%d/%Y`):**
   - *Interviewer:* "What happens if you parse `'15/10/2023'` using `%m/%d/%Y`?"
   - *Defense:* The engine attempts to parse `15` as the month number. Because month cannot exceed 12, MySQL returns `NULL` and issues a warning (`Incorrect datetime value`). In PostgreSQL, `TO_DATE()` throws a fatal runtime exception.

2. **Trap: Using Column Alias in ORDER BY vs WHERE:**
   - *Interviewer:* "Why can you use `standard_date` in `ORDER BY`, but cannot use `standard_date` in `WHERE`?"
   - *Defense:* SQL logical query execution architecture executes `WHERE` prior to `SELECT`. At the filtering phase, `standard_date` does not exist yet. Conversely, `ORDER BY` executes as the final step *after* projection, making all declared column aliases fully accessible.
