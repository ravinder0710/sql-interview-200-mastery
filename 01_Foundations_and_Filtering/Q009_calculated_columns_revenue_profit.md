# Q009: Calculated Columns, Arithmetic Precedence & Integer Division

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 009 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
During end-of-month financial reconciliation, an e-commerce finance team needs to calculate the net revenue (gross sales minus discounts) and net profit (net revenue minus total cost of goods sold) for all 'Completed' line items, sorted by total profit in descending order.

---

## 📊 Sample Mock Table (`order_items`)

| item_id | item_name | unit_price | cost_price | quantity | discount_pct | order_status |
| :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| 101 | Gaming Mouse | 2500.00 | 1400.00 | 2 | 10.00 | Completed |
| 102 | Mechanical Keyboard | 6000.00 | 3800.00 | 1 | 15.00 | Completed |
| 103 | USB-C Cable | 500.00 | 150.00 | 4 | 0.00 | Cancelled |
| 104 | 4K Monitor | 28000.00 | 19000.00 | 1 | 5.00 | Completed |
| 105 | Noise Cancelling Headphones | 12000.00 | 7500.00 | 2 | 20.00 | Completed |

---

## 🎯 Expected Output

| item_id | item_name | net_revenue | profit |
| :---: | :--- | :---: | :---: |
| 104 | 4K Monitor | 26600.00 | 7600.00 |
| 105 | Noise Cancelling Headphones | 19200.00 | 4200.00 |
| 101 | Gaming Mouse | 4500.00 | 1700.00 |
| 102 | Mechanical Keyboard | 5100.00 | 1300.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    item_id, 
    item_name, 
    (unit_price * quantity) * (1 - discount_pct / 100.0) AS net_revenue, 
    ((unit_price * quantity) * (1 - discount_pct / 100.0) - (cost_price * quantity)) AS profit 
FROM order_items 
WHERE order_status = 'Completed' 
ORDER BY profit DESC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Integer Division Truncation Danger:**
   - In SQL Server and PostgreSQL, dividing two integers (`15 / 100`) performs integer truncation, returning integer `0`.
   - Always divide by a decimal literal like `100.0` to force floating-point/decimal evaluation.

2. **Column Alias Scope of Visibility:**
   - In standard SQL, expressions inside a `SELECT` clause are evaluated concurrently. An alias declared on one column cannot be referenced inside an adjacent column expression in the same `SELECT`.
   - However, because `ORDER BY` executes after projection, aliases *can* be referenced inside `ORDER BY`.

3. **Explicit Multiplication Syntax:**
   - Unlike algebraic notation $(A)(B)$, SQL requires an explicit asterisk `*` between parenthesized terms: `(A) * (B)`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Why `100.0` over `100`?**
   - *Interviewer:* "Why did you write `discount_pct / 100.0` instead of `/ 100`?"
   - *Defense:* In many SQL dialects, integer division truncates fractions to zero. Writing `/ 100` would cause discounts to calculate as ₹0, severely inflating revenue and distorting financial reporting. `100.0` guarantees precise decimal math.

2. **Trap: Reusing Aliases Inside SELECT:**
   - *Interviewer:* "Can we write `profit = net_revenue - (cost_price * quantity)` inside the same SELECT?"
   - *Defense:* No. SQL projection evaluates columns in parallel, so `net_revenue` is not yet available in the scope of other expressions. We either repeat the formula or modularize the query using a Common Table Expression (CTE).
