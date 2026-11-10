# Q026: Day Name Extraction & Weekend Surge Analysis (`DAYNAME`, `CASE WHEN`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 026 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an upscale retail store chain, merchandising directors want to evaluate weekend versus weekday customer purchasing behavior. Because customer footfall and basket sizes spike on Saturdays and Sundays, the operations team requires classifying raw transaction dates into human-readable day names (`'Saturday'`, `'Sunday'`, etc.) and categorizing them into `'Weekend'` versus `'Weekday'` cohorts. The query isolates premium high-ticket sales (`gross_amount >= 5000`) occurring exclusively on weekends.

---

## 📊 Sample Mock Table (`store_sales`)

| sale_id | store_location | sale_date | gross_amount | payment_method |
| :---: | :--- | :---: | :---: | :--- |
| 601 | Indiranagar | 2023-11-18 | 12500.00 | Card |
| 602 | Koramangala | 2023-11-19 | 4200.00 | UPI |
| 603 | Whitefield | 2023-11-20 | 8500.00 | Card |
| 604 | Indiranagar | 2023-11-19 | 18000.00 | Card |
| 605 | Jayanagar | 2023-11-17 | 6500.00 | Cash |
| 606 | Koramangala | 2023-11-18 | 7400.00 | UPI |

*(Calendar Reference: 17 Nov = Friday, 18 Nov = Saturday, 19 Nov = Sunday, 20 Nov = Monday)*

---

## 🎯 Expected Output

| sale_id | store_location | sale_date | day_of_week | day_type | gross_amount |
| :---: | :--- | :---: | :--- | :--- | :---: |
| 604 | Indiranagar | 2023-11-19 | Sunday | Weekend | 18000.00 |
| 601 | Indiranagar | 2023-11-18 | Saturday | Weekend | 12500.00 |
| 606 | Koramangala | 2023-11-18 | Saturday | Weekend | 7400.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    sale_id, 
    store_location, 
    sale_date, 
    DAYNAME(sale_date) AS day_of_week, 
    CASE 
        WHEN DAYNAME(sale_date) IN ('Saturday', 'Sunday') THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS day_type, 
    gross_amount 
FROM store_sales 
WHERE gross_amount >= 5000 
  AND DAYNAME(sale_date) IN ('Saturday', 'Sunday') 
ORDER BY 
    gross_amount DESC, 
    sale_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Numeric Day-of-Week vs String Day Name:**
   - `DAYNAME(date)` returns the full English weekday name (e.g., `'Saturday'`).
   - `DAYOFWEEK(date)` returns numeric indices: `1 = Sunday, 2 = Monday, ..., 7 = Saturday` (ODBC standard).
   - In numeric filtering, the weekend condition can be written compactly as:
     `WHERE DAYOFWEEK(sale_date) IN (1, 7)`.

2. **Cross-Engine Equivalents:**
   - **MySQL**: `DAYNAME(date)` or `DAYOFWEEK(date)`
   - **PostgreSQL**: `TO_CHAR(date, 'Day')` or `EXTRACT(DOW FROM date)` *(0 = Sunday, 6 = Saturday)*
   - **SQL Server (T-SQL)**: `DATENAME(weekday, date)` or `DATEPART(weekday, date)`

3. **Locale & Language Dependencies:**
   - In enterprise multi-region databases, string matching like `DAYNAME(...) = 'Sunday'` can break if the server's session locale is changed to Spanish, French, or German.
   - For robust international production pipelines, using numeric extractions (`DAYOFWEEK` or `EXTRACT(DOW ...)`) is preferred over localized string literals.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Trailing Whitespace in PostgreSQL `TO_CHAR`:**
   - *Interviewer:* "In PostgreSQL, why does `WHERE TO_CHAR(sale_date, 'Day') = 'Saturday'` fail to match?"
   - *Defense:* In PostgreSQL, `TO_CHAR(..., 'Day')` pads the returned day name with trailing blank spaces to match the longest day name ('Wednesday' = 9 characters). So it returns `'Saturday '` (9 chars)! We must use the fill-mode modifier `FMDay`: `TO_CHAR(sale_date, 'FMDay') = 'Saturday'`.

2. **Trap: `DAYOFWEEK()` vs `WEEKDAY()` Offsets in MySQL:**
   - *Interviewer:* "How does `WEEKDAY()` differ from `DAYOFWEEK()` in MySQL?"
   - *Defense:* `DAYOFWEEK()` follows ODBC standards where `1 = Sunday` and `7 = Saturday`. Conversely, `WEEKDAY()` follows Python/ISO conventions where `0 = Monday` and `6 = Sunday`. Confusing the two shifts weekday tags by one full day.
