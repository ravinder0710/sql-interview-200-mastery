# Q002: String Inequality (<> / !=) & The Famous NULL Trap

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 002 / 150
- **Company Tag:** Amazon / Swiggy / Zomato / E-Commerce Operations
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A food delivery operations team needs to extract all non-delivered orders (Cancelled, In Transit, Pending) paid via 'Online' payment mode for tracking. Display order ID, customer name, order status, and order amount.

---

## 📊 Sample Mock Table (`orders`)

| order_id | customer_name | order_status | payment_type | order_amount |
| :--- | :--- | :--- | :--- | :--- |
| 5001 | Vikas Jain | Delivered | Online | 450.00 |
| 5002 | Meera Sen | Cancelled | Online | 1200.00 |
| 5003 | Arjun Kapoor | In Transit | Online | 850.00 |
| 5004 | Deepa Shah | In Transit | COD | 600.00 |
| 5005 | Tarun Malik | Delivered | COD | 350.00 |
| 5006 | Ritu Garg | Pending | Online | 990.00 |
| 5007 | Manish Paul | Cancelled | COD | 510.00 |

---

## 🎯 Expected Output Table

| order_id | customer_name | order_status | order_amount |
| :--- | :--- | :--- | :--- |
| 5002 | Meera Sen | Cancelled | 1200.00 |
| 5003 | Arjun Kapoor | In Transit | 850.00 |
| 5006 | Ritu Garg | Pending | 990.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    order_id, 
    customer_name, 
    order_status, 
    order_amount 
FROM orders 
WHERE order_status <> 'Delivered' 
  AND payment_type = 'Online';
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **The Three-Valued Logic NULL Trap**:
   - In SQL, `NULL <> 'Delivered'` yields `UNKNOWN` (treated as FALSE in WHERE clause).
   - If status allows NULLs and unassigned orders must be included, explicit `(order_status <> 'Delivered' OR order_status IS NULL)` is mandatory.

2. **ANSI Standard Inequality**:
   - `<>` is the ANSI standard operator; `!=` is supported across PostgreSQL, MySQL, SQL Server, and Snowflake.
