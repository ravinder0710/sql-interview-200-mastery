# Q023: Hour & Minute Extraction for Peak Traffic (`HOUR`, `MINUTE`, `DATETIME`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 023 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an on-demand quick-commerce fulfillment platform (e.g. Zepto, Swiggy Instamart), surge incentives and fuel bonuses are paid to delivery partners operating during evening rush hours. The operations team requires an automated auditing query that extracts granular time components (`pickup_hour` and `pickup_minute`) from transaction timestamps, filtering strictly for completed long-distance trips (`trip_distance_km >= 5.0`) initiated during the evening surge window between 7:00 PM and 9:59 PM (`HOUR BETWEEN 19 AND 21`).

---

## 📊 Sample Mock Table (`delivery_trips`)

| trip_id | rider_name | pickup_time | trip_distance_km | trip_status |
| :---: | :--- | :--- | :---: | :--- |
| 901 | Ramesh Varma | 2023-11-15 19:45:10 | 6.50 | Completed |
| 902 | Ananya Roy | 2023-11-15 14:15:00 | 8.20 | Completed |
| 903 | Kunal Sen | 2023-11-15 20:10:30 | 3.20 | Completed |
| 904 | Pooja Jain | 2023-11-15 21:05:00 | 7.80 | Cancelled |
| 905 | Tarun Das | 2023-11-15 21:30:15 | 5.40 | Completed |
| 906 | Sunita Patel | 2023-11-15 20:50:00 | 9.10 | Completed |

---

## 🎯 Expected Output

| trip_id | rider_name | pickup_time | pickup_hour | pickup_minute | trip_distance_km |
| :---: | :--- | :--- | :---: | :---: | :---: |
| 905 | Tarun Das | 2023-11-15 21:30:15 | 21 | 30 | 5.40 |
| 906 | Sunita Patel | 2023-11-15 20:50:00 | 20 | 50 | 9.10 |
| 901 | Ramesh Varma | 2023-11-15 19:45:10 | 19 | 45 | 6.50 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    trip_id, 
    rider_name, 
    pickup_time, 
    HOUR(pickup_time) AS pickup_hour, 
    MINUTE(pickup_time) AS pickup_minute, 
    trip_distance_km 
FROM delivery_trips 
WHERE trip_status = 'Completed' 
  AND HOUR(pickup_time) BETWEEN 19 AND 21 
  AND trip_distance_km >= 5.0 
ORDER BY 
    pickup_time DESC, 
    trip_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **24-Hour Time Standard in SQL:**
   - Database engines evaluate `HOUR()` on a 24-hour military clock (values 0 through 23).
   - 7:00 PM corresponds to `19`, and 9:59 PM corresponds to `21`.
   - The expression `BETWEEN 19 AND 21` cleanly spans `19:00:00` through `21:59:59`.

2. **Cross-Engine Time Extraction:**
   - **MySQL**: `HOUR(datetime_col)`, `MINUTE(datetime_col)`
   - **PostgreSQL**: `EXTRACT(HOUR FROM datetime_col)`, `EXTRACT(MINUTE FROM datetime_col)`
   - **SQL Server (T-SQL)**: `DATEPART(hour, datetime_col)`, `DATEPART(minute, datetime_col)`

3. **Time-Only Slicing vs Datetime Range:**
   - Using `HOUR(pickup_time) BETWEEN 19 AND 21` evaluates the recurring time window regardless of calendar date, making it suitable for recurring daily surge analysis.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: The 10:00 PM Boundary Trap (`BETWEEN 19 AND 22`):**
   - *Interviewer:* "If the surge ends at 9:59 PM, what happens if you write `BETWEEN 19 AND 22`?"
   - *Defense:* In SQL, `HOUR(...) = 22` represents any timestamp from 10:00:00 PM to 10:59:59 PM. Writing `BETWEEN 19 AND 22` would inadvertently include trips up to 10:59 PM, causing an overpayment of surge incentives. `BETWEEN 19 AND 21` accurately covers up to 9:59:59 PM.

2. **Trap: Timezone Offsets in Server Timestamps:**
   - *Interviewer:* "What if timestamps are recorded in UTC, but the surge window is based on Indian Standard Time (IST, UTC+5:30)?"
   - *Defense:* Evaluating `HOUR(pickup_time)` directly on UTC data produces a 5.5-hour skew. In multi-region production systems, we defensively convert to local timezone first:  
     `CONVERT_TZ(pickup_time, '+00:00', '+05:30')` in MySQL, or `pickup_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kolkata'` in PostgreSQL.
