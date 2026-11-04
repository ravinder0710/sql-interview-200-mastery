# Q002: String Inequality (`<>` / `!=`) & The NULL Trap

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 002 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
An e-commerce logistics operations team requires visibility into all active, prepaid (Online) customer orders that have not yet reached the customer (`order_status <> 'Delivered'`). This includes statuses such as *Shipped*, *Processing*, and *Cancelled* so customer support and fulfillment teams can proactively manage pending shipments.

---

## 📊 Sample Mock Table (`orders`)

| order_id | customer_name | order_status | payment_type | order_amount |
| :---: | :--- | :--- | :--- | :---: |
| 501 | Rahul Sen | Delivered | Online | 1499.00 |
| 502 | Kavita Rao | Shipped | Online | 2999.00 |
| 503 | Anuj Jain | Pending | Cash | 850.00 |
| 504 | Manisha Roy | Delivered | Cash | 1200.00 |
| 505 | Deepak Varma | Processing | Online | 4500.00 |
| 506 | Sonal Gill | Cancelled | Online | 999.00 |

---

## 🎯 Expected Output

| order_id | customer_name | order_status | order_amount |
| :---: | :--- | :--- | :---: |
| 502 | Kavita Rao | Shipped | 2999.00 |
| 505 | Deepak Varma | Processing | 4500.00 |
| 506 | Sonal Gill | Cancelled | 999.00 |

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

1. **Why `<>` instead of `!=`?**
   - Both `<>` and `!=` are accepted in modern SQL engines, but `<>` is the official **ANSI SQL standard** operator for inequality. Writing `<>` ensures universal compatibility across Oracle, PostgreSQL, SQL Server, and MySQL.

2. **Three-Valued Logic (3VL) Mechanics:**
   - SQL implements three boolean states: `TRUE`, `FALSE`, and `UNKNOWN`.
   - Any direct comparison against `NULL` (such as `NULL <> 'Delivered'`) evaluates to `UNKNOWN`.
   - Since `WHERE` clauses strictly allow rows that evaluate to `TRUE`, rows with `NULL` status are dropped automatically.

3. **Defensive Filtering Best Practice:**
   - If business requirements dictate including unassigned or missing status orders, defensively write:
     `WHERE (order_status <> 'Delivered' OR order_status IS NULL)`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: The Silent NULL Drop:**
   - *Interviewer:* "If a newly placed order has an unassigned status (`order_status IS NULL`), will your query return it?"
   - *Defense:* No. In SQL's Three-Valued Logic, `NULL <> 'Delivered'` yields `UNKNOWN`. Because `WHERE` filters accept only `TRUE`, NULL rows are silently eliminated. In production pipelines, we defensively use `(order_status <> 'Delivered' OR order_status IS NULL)`.

2. **Trap: Multiple Status Exclusions:**
   - *Interviewer:* "If you also needed to exclude 'Cancelled' orders, how would you structure the condition?"
   - *Defense:* Use `order_status NOT IN ('Delivered', 'Cancelled')`. However, if the `NOT IN` subquery or list contains a `NULL`, the entire predicate evaluates to `UNKNOWN`. We must ensure the column or list is non-null.
