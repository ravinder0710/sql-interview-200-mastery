# Q027: Nullifying Sentinel Dummy Values (`NULLIF`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 027 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an automated cold-chain logistics network, IoT temperature sensors occasionally lose connectivity or experience hardware probe faults. Instead of transmitting standard `NULL` values, the microcontroller firmware writes a sentinel dummy error code (`-999.00`). If uncleaned, downstream statistical models and aggregations like `AVG()` will severely corrupt regulatory compliance audits. The data engineering team requires nullifying `-999.00` error codes using `NULLIF()` and filtering for active sensors (`battery_level_pct >= 20`) with valid, non-null temperature readings.

---

## 📊 Sample Mock Table (`sensor_telemetry`)

| reading_id | sensor_location | reading_time | temperature_celsius | battery_level_pct |
| :---: | :--- | :--- | :---: | :---: |
| 501 | Warehouse A | 2023-11-20 10:00:00 | 4.50 | 85 |
| 502 | Freezer B | 2023-11-20 10:05:00 | -999.00 | 72 |
| 503 | Warehouse A | 2023-11-20 10:10:00 | 8.20 | 15 |
| 504 | Cold Room C | 2023-11-20 10:15:00 | -18.50 | 90 |
| 505 | Freezer B | 2023-11-20 10:20:00 | -999.00 | 65 |
| 506 | Cold Room C | 2023-11-20 10:25:00 | -15.00 | 45 |

---

## 🎯 Expected Output

| reading_id | sensor_location | clean_temperature | battery_level_pct |
| :---: | :--- | :---: | :---: |
| 501 | Warehouse A | 4.50 | 85 |
| 506 | Cold Room C | -15.00 | 45 |
| 504 | Cold Room C | -18.50 | 90 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    reading_id, 
    sensor_location, 
    NULLIF(temperature_celsius, -999.00) AS clean_temperature, 
    battery_level_pct 
FROM sensor_telemetry 
WHERE battery_level_pct >= 20 
  AND NULLIF(temperature_celsius, -999.00) IS NOT NULL 
ORDER BY 
    clean_temperature DESC, 
    reading_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **How `NULLIF(expr1, expr2)` Works:**
   - Evaluates two arguments: if $\text{expr1} = \text{expr2}$, it returns `NULL`.
   - If $\text{expr1} \ne \text{expr2}$, it returns $\text{expr1}$.
   - It is essentially syntactic shorthand for:
     $$\mathbf{CASE\ WHEN\ expr1 = expr2\ THEN\ NULL\ ELSE\ expr1\ END}$$

2. **Why Nullifying Sentinel Values is Critical for Aggregates:**
   - SQL aggregate functions (`AVG()`, `SUM()`, `MIN()`, `MAX()`) **automatically ignore NULLs**.
   - If `-999.00` remains in the column, calculating `AVG()` over readings `[4.50, -999.00]` yields `-497.25` (severe failure).
   - Once nullified to `[4.50, NULL]`, `AVG()` correctly computes `4.50`.

3. **Preventing Division-by-Zero with `NULLIF`:**
   - The most common enterprise use of `NULLIF` is in mathematical division:
     $$\text{revenue} / \mathbf{NULLIF}(\text{quantity},\ 0)$$
   - If quantity is `0`, `NULLIF` produces `NULL`, and any number divided by `NULL` safely yields `NULL` rather than a fatal query crash (`Division by zero error`).

---

## 🚨 Common Interview Traps & Defense

1. **Trap: `NULLIF` vs `COALESCE` Confusion:**
   - *Interviewer:* "What is the exact inverse relationship between `COALESCE` and `NULLIF`?"
   - *Defense:* `COALESCE` converts `NULL` into a non-null default value. Conversely, `NULLIF` converts a non-null target value into `NULL`. They are mirror opposites in data sanitation pipelines.

2. **Trap: Type Coercion in `NULLIF`:**
   - *Interviewer:* "Can you write `NULLIF(temperature_celsius, 'N/A')` on a numeric column?"
   - *Defense:* No! Both arguments to `NULLIF` must share compatible data types. Passing string `'N/A'` to a `DECIMAL` column causes a fatal data conversion exception. Dirty string flags must either be cast before comparison or handled at string ingestion.
