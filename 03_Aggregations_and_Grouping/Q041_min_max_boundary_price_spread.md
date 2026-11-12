# Q041: Min/Max Boundary Aggregation & Price Spread (`MIN`, `MAX`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q041 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / E-Commerce Pricing Analyst (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In e-commerce retail and digital marketplace merchandising (e.g., Amazon, Flipkart, Blinkit, Walmart), category managers monitor **Price Spread / Volatility** ($P_{\text{spread}} = \text{Price}_{\max} - \text{Price}_{\min}$) to evaluate catalog structure and merchandising tiers.

A massive price spread within a single category indicates fragmented merchandising (e.g., ₹499 basic computer mice bundled together with ₹18,999 gaming monitors under generic 'Electronics'). Category managers isolate these categories to restructure them into sub-categories.

The Pricing Strategy Directorate requires an audited category catalog report where:
1. Only active items currently in stock are evaluated (`is_active = 1 AND stock_quantity > 0`).
2. Only categories featuring at least 2 in-stock products are evaluated (`total_products >= 2`).
3. Only categories with significant price spread ($\ge ₹1,000.00$) are retained.
4. Output displays total products, minimum price, maximum price, and calculated price spread rounded to 2 decimal places.
5. Sorted by `price_spread DESC, category_name ASC`.

---

## 📊 Sample Mock Table: `product_catalog`

| product_id | category_name | product_name | unit_price | stock_quantity | is_active |
|:---:|:---:|:---:|:---:|:---:|:---:|
| P101 | Electronics | Wireless Mouse | 499.00 | 50 | 1 |
| P102 | Electronics | Mechanical Keyboard | 3499.00 | 20 | 1 |
| P103 | Electronics | 4K Monitor | 18999.00 | 15 | 1 |
| P104 | Footwear | Running Shoes | 1299.00 | 30 | 1 |
| P105 | Footwear | Leather Boots | 2899.00 | 10 | 1 |
| P106 | Kitchen | Non-Stick Pan | 899.00 | 0 | 1 |
| P107 | Kitchen | Blender Mixer | 2499.00 | 12 | 1 |
| P108 | Books | SQL Guide | 450.00 | 100 | 1 |
| P109 | Books | Python Guide | 550.00 | 80 | 1 |

---

## 🎯 Expected Output Table

| category_name | total_products | min_price | max_price | price_spread |
|:---:|:---:|:---:|:---:|:---:|
| Electronics | 3 | 499.00 | 18999.00 | 18500.00 |
| Footwear | 2 | 1299.00 | 2899.00 | 1600.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    category_name, 
    COUNT(product_id) AS total_products, 
    MIN(unit_price) AS min_price, 
    MAX(unit_price) AS max_price, 
    ROUND(MAX(unit_price) - MIN(unit_price), 2) AS price_spread 
FROM product_catalog 
WHERE is_active = 1 
  AND stock_quantity > 0 
GROUP BY category_name 
HAVING COUNT(product_id) >= 2 
   AND (MAX(unit_price) - MIN(unit_price)) >= 1000.00 
ORDER BY price_spread DESC, category_name ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Arithmetic Between Aggregate Functions
- SQL permits mathematical operations directly between aggregate expressions within `SELECT` and `HAVING`:
  $$\text{ROUND}(\text{MAX}(unit\_price) - \text{MIN}(unit\_price), 2)$$
- The database accumulates group extrema into internal memory registers during the single-pass grouping scan, computing the difference on aggregate finalization.

### 2. The NULL Semantics of `MIN()` and `MAX()`
- `MIN()` and `MAX()` silently discard `NULL` values. They never evaluate `NULL` as the lowest or highest value.
- The functions return `NULL` strictly if every record in the clustered group evaluates to `NULL`.

### 3. Non-Numeric Extrema
- **Temporal Data Types (`DATE`, `DATETIME`)**: `MIN()` returns the oldest/earliest chronological point, while `MAX()` returns the latest/most recent timestamp.
- **String Types (`VARCHAR`, `TEXT`)**: `MIN()` and `MAX()` return lexicographical (alphabetical) extrema based on the database collation.

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Projecting Non-Aggregated Descriptive Columns with Extrema
- **Interviewer Query:** *"Can we add `product_name` to the `SELECT` list to display the name of the cheapest product alongside `MIN(unit_price)`?"*
- **Candidate Defense:**
  > *"No. Adding `product_name` without aggregating it violates `ONLY_FULL_GROUP_BY`. In standard SQL, `MIN(unit_price)` returns an atomic scalar value, but does not bind the remainder of that row's fields. To retrieve the product name associated with the minimum price, we must use a Window Function (`ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY unit_price ASC)`) or a self-join/correlated subquery."*

### Trap 2: Out-of-Stock Filtering Placement
- **Interviewer Query:** *"Why filter `stock_quantity > 0` in `WHERE` rather than checking it in `HAVING`?"*
- **Candidate Defense:**
  > *"Filtering in `WHERE` prunes out-of-stock items before `MIN()` and `MAX()` evaluate. If an out-of-stock item has the lowest price (e.g., Non-Stick Pan at ₹899), evaluating without `WHERE` would falsely skew the minimum price of active inventory."*
