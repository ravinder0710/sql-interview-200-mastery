# Q003: Set Membership (`IN`) & Inclusive Range (`BETWEEN`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 003 / 200
- **Company Tag:** Flipkart, Amazon Inventory
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **Set Membership**: `category IN (...)` checks against a concise set rather than a chained sequence of `OR` clauses.
2. **Range Evaluation**: `price BETWEEN 1000 AND 10000` evaluates both bounds inclusively ($\text{price} \ge 1000 \text{ AND } \text{price} \le 10000$).
3. **Availability Filter**: `stock_qty > 0` ensures out-of-stock items (such as the Blender Grinder) are excluded from promotional listings.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Boundary Inclusivity in `BETWEEN`**:
   - `BETWEEN` is strictly inclusive of both boundary values (1,000 and 10,000). The Electric Kettle priced at exactly 1,000 is retained.
2. **SARGability & Performance**:
   - Both `IN` and `BETWEEN` are Search Argument Able (**SARGable**). Wrapping `price` in functions like `ROUND(price)` or `CAST(price AS INT)` would invalidate B-Tree index range scans.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"Both `IN` and `BETWEEN` operators are SARGable predicates that allow the database engine to execute high-efficiency B-Tree Index Range Scans instead of costly Full Table Scans. Under the hood, the optimizer constructs an in-memory hash set lookup for the `IN` list, while `BETWEEN` ensures deterministic, fully inclusive boundary filtering."*
