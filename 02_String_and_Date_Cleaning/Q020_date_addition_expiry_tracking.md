# Q020: Date Addition & Expiry/Warranty Tracking (`DATE_ADD`, `INTERVAL`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 020 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In a consumer electronics post-sales servicing platform, product warranties are dynamic based on device tier (e.g. 6 months, 12 months, 24 months). To prepare warranty lapse notices and prevent unauthorized warranty claims, the customer operations team requires calculating the exact expiration timestamp for every device and filtering for active accounts (`service_status = 'Active'`) whose coverage has expired prior to the audit cut-off date (`'2024-01-01'`).

---

## 📊 Sample Mock Table (`device_warranties`)

| warranty_id | customer_name | device_type | purchase_date | warranty_months | service_status |
| :---: | :--- | :--- | :---: | :---: | :--- |
| 401 | Amit Sharma | Smartphone | 2022-06-15 | 12 | Active |
| 402 | Sneha Rao | Laptop | 2023-03-10 | 24 | Active |
| 403 | Rohan Varma | Smartwatch | 2022-11-20 | 12 | Active |
| 404 | Priya Das | Tablet | 2021-08-05 | 24 | Claimed |
| 405 | Kunal Sen | Headphones | 2023-08-15 | 6 | Active |
| 406 | Pooja Jain | Smartwatch | 2022-01-10 | 12 | Active |

---

## 🎯 Expected Output

| warranty_id | customer_name | device_type | expiry_date | service_status |
| :---: | :--- | :--- | :---: | :--- |
| 406 | Pooja Jain | Smartwatch | 2023-01-10 | Active |
| 401 | Amit Sharma | Smartphone | 2023-06-15 | Active |
| 403 | Rohan Varma | Smartwatch | 2023-11-20 | Active |

---

## 💡 Production SQL Solution

```sql
SELECT 
    warranty_id, 
    customer_name, 
    device_type, 
    DATE_ADD(purchase_date, INTERVAL warranty_months MONTH) AS expiry_date, 
    service_status 
FROM device_warranties 
WHERE service_status = 'Active' 
  AND DATE_ADD(purchase_date, INTERVAL warranty_months MONTH) < '2024-01-01' 
ORDER BY 
    expiry_date ASC, 
    warranty_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Dynamic Interval Arithmetic:**
   - In real-world data, warranty periods differ per record. Hardcoding a static interval fails.
   - `DATE_ADD(purchase_date, INTERVAL warranty_months MONTH)` dynamically adds the column value `warranty_months` to each individual row's `purchase_date`.

2. **Cross-Dialect Date Addition:**
   - **MySQL**: `DATE_ADD(date, INTERVAL n UNIT)`
   - **SQL Server (T-SQL)**: `DATEADD(month, warranty_months, purchase_date)`
   - **PostgreSQL**: Standard interval addition: `purchase_date + (warranty_months || ' month')::interval`
   - **Oracle**: `ADD_MONTHS(purchase_date, warranty_months)`

3. **End-of-Month Date Normalization:**
   - Database engines automatically adjust for varying month lengths. For example, adding 1 month to `2024-01-31` correctly resolves to `2024-02-29` (leap year) or `2023-02-28`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Dialect Syntax Inversion (`DATE_ADD` vs `DATEADD`):**
   - *Interviewer:* "How does T-SQL (SQL Server) syntax differ from MySQL for date addition?"
   - *Defense:* In SQL Server, the function is `DATEADD()` (no underscore), and the interval keyword is the first argument: `DATEADD(month, warranty_months, purchase_date)`. MySQL uses `DATE_ADD()` with the ANSI `INTERVAL` keyword.

2. **Trap: Strictly Less Than vs Less Than or Equal:**
   - *Interviewer:* "What if a device expired on the exact day `'2024-01-01'`? Is it included?"
   - *Defense:* No. The business prompt strictly requested warranties that expired *before* the cut-off date (`< '2024-01-01'`). Using `<=` would include the cut-off day itself.
