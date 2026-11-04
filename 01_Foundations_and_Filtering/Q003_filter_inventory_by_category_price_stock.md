# Q003: Set Membership (IN) & Inclusive Range (BETWEEN)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 003 / 150
- **Company Tag:** Flipkart / Amazon Inventory / Retail Supply Chain
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
The warehouse inventory manager requires a filtered catalog of products belonging to either 'Electronics' or 'Appliances' categories, with unit prices ranging between 1,000 and 10,000 (inclusive), and strictly having available stock (`stock_qty > 0`).

---

## 📊 Sample Mock Table (`products`)

| product_id | product_name | category | price | stock_qty |
| :--- | :--- | :--- | :--- | :--- |
| 201 | Wireless Earbuds | Electronics | 1999.00 | 45 |
| 202 | Smart Watch | Electronics | 999.00 | 12 |
| 203 | Electric Kettle | Appliances | 1450.00 | 0 |
| 204 | Induction Cooktop | Appliances | 3200.00 | 18 |
| 205 | Running Shoes | Apparel | 2499.00 | 30 |
| 206 | Microwave Oven | Appliances | 9999.00 | 5 |
| 207 | 4K LED TV | Electronics | 34999.00 | 8 |

---

## 🎯 Expected Output Table

| product_id | product_name | category | price | stock_qty |
| :--- | :--- | :--- | :--- | :--- |
| 201 | Wireless Earbuds | Electronics | 1999.00 | 45 |
| 204 | Induction Cooktop | Appliances | 3200.00 | 18 |
| 206 | Microwave Oven | Appliances | 9999.00 | 5 |

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

1. **Inclusive Boundaries**:
   - `BETWEEN low AND high` evaluates as `>= low AND <= high`, preserving boundary items (1,000 and 10,000).

2. **Optimizer Set Lookup**:
   - `IN (...)` is cleaner than cascaded OR statements and maps to an efficient in-memory hash set lookup.

3. **SARGability**:
   - Both `IN` and `BETWEEN` are SARGable predicates that support B-Tree index seeks.
