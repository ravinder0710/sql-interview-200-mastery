# Q039: Multi-Column Grouping & Store Performance (`GROUP BY col1, col2`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q039 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Retail BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In retail chain management, supermarket operations, and FMCG merchandising (e.g., DMart, Reliance Retail, BigBasket, Walmart), store performance is evaluated at multi-dimensional intersections: **Geographic Territory (City)** and **Merchandise Category**.

Evaluating city performance in isolation obscures category-specific consumer demand (e.g., Electronics may surge in Mumbai while Grocery dominates Bengaluru). Regional leadership conducts hierarchical multi-column grouping to identify lucrative market clusters.

The Retail Operations Directorate requires an audited sales performance report where:
1. Only successful transaction payments are evaluated (`payment_method IN ('UPI', 'Card', 'Cash')`).
2. Multi-column grouping evaluates each unique `(store_city, product_category)` cluster.
3. The cluster must demonstrate minimum transaction velocity (`total_transactions >= 2`).
4. Total gross cluster revenue must reach or exceed ₹5,000.00 (`total_revenue >= 5000.00`).
5. Revenue and average transaction size (ticket size) are rounded to 2 decimal places.
6. Sorted by `total_revenue DESC, store_city ASC, product_category ASC`.

---

## 📊 Sample Mock Table: `store_sales_transactions`

| transaction_id | store_city | product_category | sales_amount | payment_method |
|:---:|:---:|:---:|:---:|:---:|
| 9001 | Mumbai | Electronics | 4500.00 | Card |
| 9002 | Mumbai | Electronics | 3500.00 | UPI |
| 9003 | Mumbai | Grocery | 1200.00 | Cash |
| 9004 | Bengaluru | Electronics | 6000.00 | UPI |
| 9005 | Bengaluru | Grocery | 2800.00 | Card |
| 9006 | Bengaluru | Grocery | 3200.00 | UPI |
| 9007 | Delhi | Fashion | 1500.00 | Cash |
| 9008 | Delhi | Fashion | 800.00 | Failed |
| 9009 | Delhi | Fashion | 2200.00 | UPI |

---

## 🎯 Expected Output Table

| store_city | product_category | total_transactions | total_revenue | avg_ticket_size |
|:---:|:---:|:---:|:---:|:---:|
| Mumbai | Electronics | 2 | 8000.00 | 4000.00 |
| Bengaluru | Grocery | 2 | 6000.00 | 3000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    store_city, 
    product_category, 
    COUNT(transaction_id) AS total_transactions, 
    ROUND(SUM(sales_amount), 2) AS total_revenue, 
    ROUND(AVG(sales_amount), 2) AS avg_ticket_size 
FROM store_sales_transactions 
WHERE payment_method IN ('UPI', 'Card', 'Cash') 
GROUP BY store_city, product_category 
HAVING COUNT(transaction_id) >= 2 
   AND SUM(sales_amount) >= 5000.00 
ORDER BY total_revenue DESC, store_city ASC, product_category ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Multi-Column `GROUP BY` Mechanics
- In SQL, specifying `GROUP BY store_city, product_category` creates a composite grouping key: $(C_i, K_j)$.
- The engine partitions rows such that all records sharing identical values across **both** columns collapse into a single summary record.
- Changing column order (`GROUP BY product_category, store_city`) produces mathematically identical groups.

### 2. The `ONLY_FULL_GROUP_BY` Standard
- Under ANSI SQL standards and MySQL default mode (`ONLY_FULL_GROUP_BY`), every non-aggregated column present in the `SELECT` list must be explicitly declared in the `GROUP BY` clause.
- Attempting to project unaggregated fields like `payment_method` without grouping or aggregating precipitates runtime rejection (`Error 1055`).

### 3. Row-Level vs Post-Aggregate Filtering
- `WHERE payment_method IN ('UPI', 'Card', 'Cash')`: Filters invalid rows prior to hashing, reducing the memory footprint of intermediate hash tables.
- `HAVING COUNT(...) >= 2 AND SUM(...) >= 5000.00`: Eliminates low-volume and low-revenue composite clusters after aggregations evaluate.

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Non-Aggregated Columns in `SELECT`
- **Interviewer Query:** *"Why did earlier versions of MySQL permit `SELECT payment_method` without placing it in `GROUP BY`?"*
- **Candidate Defense:**
  > *"Legacy MySQL versions possessed loose grouping behavior that arbitrarily selected a value from any non-deterministic row within the group. Because this produced unreliable, non-reproducible analytics, modern SQL engines enforce `ONLY_FULL_GROUP_BY` to prevent silent data corruption."*

### Trap 2: SARGability on Multi-Column Grouping
- **Interviewer Query:** *"What index structure would optimize this query's execution plan?"*
- **Candidate Defense:**
  > *"A composite covering index on `(payment_method, store_city, product_category, sales_amount, transaction_id)` optimizes the query completely. The engine performs an index seek on `payment_method`, streams the pre-sorted index keys directly into grouping accumulators, and completely avoids heap table reads or expensive temporary sort files."*
