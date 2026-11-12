# Q037: Category Diversity & Distinct Counting (`COUNT(DISTINCT)`, `SUM`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q037 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In digital retail and marketplace platforms (e.g., Amazon, Flipkart, Target, Walmart), customer cross-selling and category exploration are vital indicators of high lifetime value (LTV). Customers who purchase across diverse merchandising verticals (e.g., Books, Electronics, Kitchen) exhibit significantly lower churn rates than single-category shoppers.

The Growth & Merchandising team is launching a cross-category loyalty tier. They require an audited customer summary of cross-category shoppers where:
1. The customer has purchased from at least 2 distinct merchandise categories (`distinct_categories_shopped >= 2`).
2. The customer's total gross order spend (`quantity * item_price`) across all lines reaches or exceeds ₹1,500.00 (`total_spend >= 1500.00`).
3. Summary displays the customer ID, total items purchased, count of unique categories, and total spend.
4. Output is sorted by `distinct_categories_shopped DESC, total_spend DESC, customer_id ASC`.

---

## 📊 Sample Mock Table: `order_line_items`

| item_id | customer_id | product_category | quantity | item_price |
|:---:|:---:|:---:|:---:|:---:|
| 1 | CUST_201 | Electronics | 1 | 1200.00 |
| 2 | CUST_201 | Fashion | 2 | 400.00 |
| 3 | CUST_202 | Grocery | 5 | 100.00 |
| 4 | CUST_202 | Grocery | 4 | 200.00 |
| 5 | CUST_203 | Books | 3 | 300.00 |
| 6 | CUST_203 | Electronics | 1 | 800.00 |
| 7 | CUST_203 | Home & Kitchen | 2 | 500.00 |
| 8 | CUST_204 | Fashion | 1 | 900.00 |
| 9 | CUST_204 | Books | 1 | 350.00 |

---

## 🎯 Expected Output Table

| customer_id | total_items_purchased | distinct_categories_shopped | total_spend |
|:---:|:---:|:---:|:---:|
| CUST_203 | 3 | 3 | 2700.00 |
| CUST_201 | 2 | 2 | 2000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    customer_id, 
    COUNT(item_id) AS total_items_purchased, 
    COUNT(DISTINCT product_category) AS distinct_categories_shopped, 
    SUM(quantity * item_price) AS total_spend 
FROM order_line_items 
GROUP BY customer_id 
HAVING COUNT(DISTINCT product_category) >= 2 
   AND SUM(quantity * item_price) >= 1500.00 
ORDER BY distinct_categories_shopped DESC, total_spend DESC, customer_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. The Core Triad: `COUNT(*)`, `COUNT(col)`, `COUNT(DISTINCT col)`
- **`COUNT(*)`**: Counts every physical record in the clustered group regardless of NULL presence.
- **`COUNT(product_category)`**: Counts all non-null occurrences of `product_category`, preserving duplicates.
- **`COUNT(DISTINCT product_category)`**: Evaluates unique cardinality by dropping duplicates and silently ignoring NULL values.

### 2. The NULL Semantics in `COUNT(DISTINCT)`
- If a customer purchased 1 `'Electronics'` item and 1 item where `product_category IS NULL`, `COUNT(DISTINCT product_category)` evaluates to **1**, not 2. ANSI SQL aggregate functions discard NULLs before deduping.

### 3. Expression Aggregation in `SUM()`
- `SUM(quantity * item_price)`: SQL evaluates scalar arithmetic (`quantity * item_price`) at the row level first, then aggregates the products into the group accumulator without needing a preliminary CTE or subquery.

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Using Aliases Inside `HAVING` Across Dialects
- **Interviewer Query:** *"Why write `HAVING COUNT(DISTINCT product_category) >= 2` instead of `HAVING distinct_categories_shopped >= 2`?"*
- **Candidate Defense:**
  > *"While MySQL's proprietary SQL extension permits aliases in `HAVING`, strict ANSI SQL engines (PostgreSQL, SQL Server, Oracle) reject them with an 'Invalid Column' error because `HAVING` executes prior to `SELECT` in the logical processing pipeline. Writing explicit aggregate expressions in `HAVING` guarantees 100% portable enterprise code."*

### Trap 2: Large-Scale Cardinality Performance
- **Interviewer Query:** *"On tables with 100M+ rows, `COUNT(DISTINCT)` consumes massive memory due to hash set allocations. How do modern cloud data warehouses optimize this?"*
- **Candidate Defense:**
  > *"In petabyte-scale distributed databases (Snowflake, BigQuery, Databricks), engineers utilize HyperLogLog probabilistic cardinality estimators, such as `APPROX_COUNT_DISTINCT()`. This achieves 99%+ statistical accuracy with orders of magnitude faster execution and constant $O(1)$ memory."*
