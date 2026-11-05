# Q013: String Cleansing & Normalization (`REPLACE`, `TRIM`, `UPPER`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 013 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an e-commerce logistics platform, address data entered by end-users during checkout often contains leading or trailing whitespaces caused by mobile autofill. Furthermore, regional city codes are stored as abbreviations (e.g. `'BLR'`). For automated courier dispatch and dispatch label generation, the data analytics team must clean irregular whitespaces, normalize city abbreviations to full corporate names (`'Bangalore'`), and filter for Bangalore PIN codes starting with `'56'`.

---

## 📊 Sample Mock Table (`customer_addresses`)

| address_id | customer_name | raw_address | city_code | pin_code |
| :---: | :--- | :--- | :--- | :--- |
| 301 | Vikas Verma | &nbsp;&nbsp;&nbsp;12th Main Indiranagar&nbsp;&nbsp; | BLR | 560038 |
| 302 | Neha Sharma | 45 MG Road | BOM | 400001 |
| 303 | Amit Roy | &nbsp;&nbsp;7th Cross Koramangala&nbsp;&nbsp;&nbsp;&nbsp; | BLR | 560034 |
| 304 | Kavita Das | 102 Brigade Road | BLR | 560025 |
| 305 | Kunal Sen | &nbsp;&nbsp;&nbsp;Park Street&nbsp;&nbsp; | CCU | 700016 |

---

## 🎯 Expected Output

| address_id | customer_name | cleaned_address | standard_city | pin_code |
| :---: | :--- | :--- | :--- | :--- |
| 301 | Vikas Verma | 12th Main Indiranagar | Bangalore | 560038 |
| 303 | Amit Roy | 7th Cross Koramangala | Bangalore | 560034 |
| 304 | Kavita Das | 102 Brigade Road | Bangalore | 560025 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    address_id, 
    customer_name, 
    TRIM(raw_address) AS cleaned_address, 
    REPLACE(UPPER(city_code), 'BLR', 'Bangalore') AS standard_city, 
    pin_code 
FROM customer_addresses 
WHERE pin_code LIKE '56%' 
ORDER BY address_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why `TRIM()` vs `LTRIM()` / `RTRIM()`?**
   - Standard ANSI `TRIM(str)` strips whitespace from **both** ends of a string simultaneously.
   - `LTRIM()` removes only leading (left) spaces, while `RTRIM()` removes only trailing (right) spaces. In data cleaning pipelines, `TRIM()` ensures complete edge sanitization.

2. **Case-Sensitivity of `REPLACE()` Across SQL Engines:**
   - In PostgreSQL, Oracle, and SQLite, `REPLACE()` is strictly **case-sensitive**. Searching for `'blr'` when the data holds `'BLR'` will silently fail to replace!
   - To make production code bulletproof across all dialects, wrap the target column with `UPPER(city_code)` prior to applying `REPLACE(..., 'BLR', ...)`.

3. **String Function Immutability:**
   - Scalar string functions like `TRIM()` and `REPLACE()` do not alter underlying physical disk tables; they return newly computed character streams in memory for projection.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Internal Whitespace Stripping:**
   - *Interviewer:* "Does `TRIM(' 12th Main Indiranagar ')` remove the space between '12th' and 'Main'?"
   - *Defense:* No. `TRIM()` strictly removes leading and trailing padding characters. It never alters internal word delimiters. To remove or collapse internal spaces, regex functions like `REGEXP_REPLACE(str, '\s+', ' ')` or nested `REPLACE` calls are used.

2. **Trap: Case-Sensitivity Trap in `REPLACE`:**
   - *Interviewer:* "If the table contains lowercase `'blr'` or mixed-case `'Blr'`, will `REPLACE(city_code, 'BLR', 'Bangalore')` catch them in PostgreSQL?"
   - *Defense:* In PostgreSQL, `REPLACE` is strictly case-sensitive and will miss `'blr'`. The robust pattern is `REPLACE(UPPER(city_code), 'BLR', 'Bangalore')` or using PostgreSQL's regex replace function `REGEXP_REPLACE(city_code, 'blr', 'Bangalore', 'i')` with the `'i'` flag for case-insensitivity.
