# Q036: Customer Lifetime Spend & Order Count (`GROUP BY`, `HAVING`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q036 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In e-commerce and retail analytics (e.g., Amazon, Flipkart, Myntra, Shopify), customer retention and loyalty programs target high-value repeat shoppers (VIP Customers). 

Marketing and CRM teams define a VIP customer as someone who has demonstrated genuine retention by:
1. Placing multiple completed purchases (excluding cancelled or refunded orders).
2. Generating substantial gross delivered revenue.

The Customer Lifecycle team has requested a consolidated customer-level report where:
1. Only completed orders are evaluated (`order_status = 'Delivered'`).
2. Customers must have placed at least 2 delivered orders (`total_orders >= 2`).
3. Total cumulative spend across delivered orders must reach or exceed ₹2,000.00 (`total_spent >= 2000.00`).
4. Output is sorted by `total_spent DESC, customer_id ASC`.

---

## 📊 Sample Mock Table: `customer_orders`

| order_id | customer_id | customer_name | order_status | order_amount |
|:---:|:---:|:---:|:---:|:---:|
| 5001 | CUST_101 | Aman Verma | Delivered | 1200.00 |
| 5002 | CUST_102 | Ritu Sen | Delivered | 3500.00 |
| 5003 | CUST_101 | Aman Verma | Delivered | 1800.00 |
| 5004 | CUST_103 | Deepak Roy | Cancelled | 5000.00 |
| 5005 | CUST_104 | Simran Kaur | Delivered | 800.00 |
| 5006 | CUST_104 | Simran Kaur | Delivered | 650.00 |
| 5007 | CUST_105 | Gaurav Shah | Delivered | 2200.00 |
| 5008 | CUST_105 | Gaurav Shah | Delivered | 1500.00 |

---

## 🎯 Expected Output Table

| customer_id | customer_name | total_orders | total_spent |
|:---:|:---:|:---:|:---:|
| CUST_105 | Gaurav Shah | 2 | 3700.00 |
| CUST_101 | Aman Verma | 2 | 3000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    customer_id, 
    customer_name, 
    COUNT(order_id) AS total_orders, 
    SUM(order_amount) AS total_spent 
FROM customer_orders 
WHERE order_status = 'Delivered' 
GROUP BY customer_id, customer_name 
HAVING COUNT(order_id) >= 2 
   AND SUM(order_amount) >= 2000.00 
ORDER BY total_spent DESC, customer_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. `WHERE` vs `HAVING`: The Fundamental Separation
- **`WHERE` (Pre-Aggregation Row Filter):** Evaluates row-by-row *before* the database clusters rows into groups. Here, `WHERE order_status = 'Delivered'` discards cancelled orders immediately, reducing CPU and memory overhead during grouping.
- **`HAVING` (Post-Aggregation Group Filter):** Evaluates *after* rows have been partitioned by `GROUP BY`. Conditions on summary metrics like `COUNT(...) >= 2` and `SUM(...) >= 2000.00` can **only** exist in `HAVING`.

### 2. SQL Query Logical Processing Sequence
Understanding query execution order prevents invalid syntax assumptions:
$$\text{FROM} \longrightarrow \mathbf{WHERE} \longrightarrow \mathbf{GROUP\ BY} \longrightarrow \mathbf{HAVING} \longrightarrow \mathbf{SELECT} \longrightarrow \mathbf{ORDER\ BY}$$

Because `HAVING` executes *before* `SELECT` in ANSI SQL, referencing column aliases like `total_orders` inside `HAVING` fails in strict engines like PostgreSQL and SQL Server. Repeating the aggregate expression (`HAVING COUNT(order_id) >= 2`) guarantees universal cross-dialect compatibility.

### 3. Including All Non-Aggregated Columns in `GROUP BY`
- Under ANSI SQL standards and MySQL `ONLY_FULL_GROUP_BY` mode, any column present in the `SELECT` list that is not enclosed within an aggregate function must be explicitly specified in the `GROUP BY` clause (`customer_id, customer_name`).

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Aggregates Inside `WHERE`
- **Interviewer Query:** *"Why can't we write `WHERE order_status = 'Delivered' AND SUM(order_amount) >= 2000`?"*
- **Candidate Defense:**
  > *"Because the `WHERE` clause operates on atomic, individual table rows prior to grouping. At the moment `WHERE` executes, aggregated metrics (`SUM`, `COUNT`, `AVG`) do not exist yet. Aggregated boundary checks must be placed in `HAVING`."*

### Trap 2: Using Column Aliases Inside `HAVING`
- **Interviewer Query:** *"Does writing `HAVING total_spent >= 2000` work across all databases?"*
- **Candidate Defense:**
  > *"No. MySQL permits aliases in `HAVING` as a proprietary extension, but standard ANSI SQL engines (PostgreSQL, SQL Server, Oracle) reject aliases in `HAVING` because `HAVING` runs before `SELECT` projects the aliases. Production-grade, portable SQL always writes `HAVING SUM(order_amount) >= 2000.00`."*
