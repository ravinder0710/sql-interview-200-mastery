# Q002: String Inequality (`<>` / `!=`) & The NULL Trap

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 002 / 200
- **Company Tag:** Amazon, Swiggy, Zomato
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **`FROM` Phase**: Scans the `orders` table.
2. **`WHERE` Phase**: Combines two predicates using logical `AND`:
   - `order_status <> 'Delivered'` eliminates delivered orders.
   - `payment_type = 'Online'` isolates prepaid transactions.
3. **`SELECT` Phase**: Emits the designated operational attributes.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Three-Valued Logic (3VL) & Silent NULL Elimination**:
   - In SQL, comparisons involving `NULL` evaluate to `UNKNOWN` rather than `TRUE` or `FALSE`.
   - If an order's status is `NULL` (e.g., due to an ingestion lag), `NULL <> 'Delivered'` yields `UNKNOWN`. Because `WHERE` filters only accept `TRUE`, these records are dropped silently.
2. **Defensive Production Coding**:
   - When missing or unassigned statuses must be included, always write:
     `WHERE (order_status <> 'Delivered' OR order_status IS NULL)`.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"In ANSI SQL, inequality operators like `<>` evaluate against Three-Valued Logic. Comparing any string literal to a NULL value results in `UNKNOWN`, causing the WHERE filter to discard those rows silently. In production data pipelines where newly ingested orders may carry a NULL status, we defensively encapsulate the condition as `(order_status <> 'Delivered' OR order_status IS NULL)` to prevent data loss."*
