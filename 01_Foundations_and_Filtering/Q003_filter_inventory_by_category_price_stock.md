# Q003: Set Membership (`IN`) & Inclusive Range (`BETWEEN`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 003 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
Category merchandising managers at a retail e-commerce platform are launching a festive campaign. They need an inventory report of all in-stock products (`stock_qty > 0`) belonging to either the 'Electronics' or 'Appliances' category, with unit prices falling between 1,000 and 10,000 (inclusive).

---

## 📊 Sample Mock Table (`products`)

| product_id | product_name | category | price | stock_qty |
| :---: | :--- | :--- | :---: | :---: |
| 1 | Wireless Earbuds | Electronics | 2499.00 | 45 |
| 2 | Cotton Bedsheet | Home | 899.00 | 120 |
| 3 | Microwave Oven | Appliances | 7500.00 | 12 |
| 4 | Smart Watch | Electronics | 12000.00 | 8 |
| 5 | Electric Kettle | Appliances | 1000.00 | 25 |
| 6 | Running Shoes | Footwear | 3499.00 | 60 |
| 7 | Blender Grinder | Appliances | 4200.00 | 0 |

---

## 🎯 Expected Output

| product_id | product_name | category | price | stock_qty |
| :---: | :--- | :--- | :---: | :---: |
| 1 | Wireless Earbuds | Electronics | 2499.00 | 45 |
| 3 | Microwave Oven | Appliances | 7500.00 | 12 |
| 5 | Electric Kettle | Appliances | 1000.00 | 25 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    product_id, 
    product_name, 
    category, 
    price, 
    stock_qty 
FROM products 
WHERE category IN ('Electronics', 'Appliances') 
  AND price BETWEEN 1000 AND 10000 
  AND stock_qty > 0;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why `IN` instead of chained `OR`?**
   - Writing `category IN ('Electronics', 'Appliances')` is not just syntactically cleaner; the database query optimizer creates an in-memory hash set lookup ($O(1)$) rather than evaluating sequential conditional branches.

2. **Inclusivity of `BETWEEN`:**
   - In ANSI SQL, `BETWEEN val1 AND val2` is strictly equivalent to:
     $$\text{price} \ge \text{val1 AND price} \le \text{val2}$$
   - Both the lower bound (1,000) and upper bound (10,000) are fully inclusive. The Electric Kettle priced at 1,000 is correctly preserved.

3. **SARGability and Index Efficiency:**
   - Both `IN` and `BETWEEN` are Search Argument Able (**SARGable**) predicates. Wrapping `price` in functions like `ROUND(price)` or `CAST(price AS INT)` would invalidate B-Tree index scans.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Boundary Value Exclusion Myth:**
   - *Interviewer:* "Will a product with price exactly 10,000 be included in `BETWEEN 1000 AND 10000`?"
   - *Defense:* Yes, `BETWEEN` is fully inclusive of both endpoints in standard SQL. If an exclusive range was required, we would write `price > 1000 AND price < 10000`.

2. **Trap: Inverted Range Ordering:**
   - *Interviewer:* "What happens if someone writes `BETWEEN 10000 AND 1000`?"
   - *Defense:* The query returns 0 rows! SQL evaluates this as `price >= 10000 AND price <= 1000`, which is a mathematical impossibility. The lower bound must always precede the upper bound.
