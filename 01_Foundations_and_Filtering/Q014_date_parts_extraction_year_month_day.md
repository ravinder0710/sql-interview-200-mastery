# Q014: Date Part Extraction & Temporal Filtering (`YEAR`, `MONTH`, `DAY` / `EXTRACT`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 014 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
During financial audits, an e-commerce retail analytics team needs to evaluate the performance of the October 2023 festive Diwali sales campaign. The business requires decomposing order timestamps into granular temporal parts (Year, Month, and Day) to identify peak shopping days, while strictly isolating verified successful transactions (`payment_status = 'Paid'`).

---

## 📊 Sample Mock Table (`customer_orders`)

| order_id | customer_name | order_date | order_amount | payment_status |
| :---: | :--- | :---: | :---: | :--- |
| 801 | Rakesh Kumar | 2023-10-15 | 14500.00 | Paid |
| 802 | Ananya Roy | 2023-09-28 | 8200.00 | Paid |
| 803 | Deepak Sharma | 2023-10-22 | 24000.00 | Paid |
| 804 | Sunita Das | 2023-10-05 | 12000.00 | Failed |
| 805 | Amit Jain | 2022-10-18 | 19500.00 | Paid |
| 806 | Priya Patel | 2023-10-12 | 24000.00 | Paid |

---

## 🎯 Expected Output

| order_id | customer_name | order_year | order_month | order_day | order_amount |
| :---: | :--- | :---: | :---: | :---: | :---: |
| 803 | Deepak Sharma | 2023 | 10 | 22 | 24000.00 |
| 806 | Priya Patel | 2023 | 10 | 12 | 24000.00 |
| 801 | Rakesh Kumar | 2023 | 10 | 15 | 14500.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    order_id, 
    customer_name, 
    YEAR(order_date) AS order_year, 
    MONTH(order_date) AS order_month, 
    DAY(order_date) AS order_day, 
    order_amount 
FROM customer_orders 
WHERE payment_status = 'Paid' 
  AND YEAR(order_date) = 2023 
  AND MONTH(order_date) = 10 
ORDER BY 
    order_amount DESC, 
    order_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Dialect Portability with ANSI `EXTRACT()`:**
   - While `YEAR()`, `MONTH()`, and `DAY()` are supported in MySQL and SQL Server, the official ANSI SQL standard syntax is:
     $$\mathbf{EXTRACT(PART\ FROM\ date\_column)}$$
     *(e.g., `EXTRACT(YEAR FROM order_date)` in PostgreSQL and Oracle).*

2. **The Non-SARGable Function Trap in `WHERE`:**
   - Applying functions like `YEAR(order_date) = 2023` in the `WHERE` clause prevents the database optimizer from performing an **Index Seek** on `order_date`. The engine must execute the function row-by-row on every record in the table.

3. **Production SARGable Optimization:**
   - In production databases with millions of rows, write date ranges using boundary comparison to preserve index performance:
     ```sql
     WHERE payment_status = 'Paid' 
       AND order_date >= '2023-10-01' 
       AND order_date < '2023-11-01'
     ```

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Non-SARGable Date Predicates:**
   - *Interviewer:* "If `order_date` has a B-Tree index, why will `YEAR(order_date) = 2023 AND MONTH(order_date) = 10` be slow on 50 million rows?"
   - *Defense:* Wrapping an indexed column inside scalar functions invalidates index seeks, forcing a Full Table Scan. To make it SARGable, we replace the function calls with a direct range comparison: `order_date >= '2023-10-01' AND order_date < '2023-11-01'`.

2. **Trap: Timestamp with Time Component:**
   - *Interviewer:* "If `order_date` contains time (e.g., `2023-10-31 23:45:00`), why is `BETWEEN '2023-10-01' AND '2023-10-31'` dangerous?"
   - *Defense:* The string `'2023-10-31'` casts to midnight `2023-10-31 00:00:00`. Any orders placed later on October 31st will be dropped. The bulletproof pattern is `order_date >= '2023-10-01' AND order_date < '2023-11-01'`.
