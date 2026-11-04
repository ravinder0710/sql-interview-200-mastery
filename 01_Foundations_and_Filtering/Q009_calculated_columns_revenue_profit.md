# Q009: Calculated Columns, Arithmetic Precedence & Integer Division

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 009 / 200
- **Company Tag:** Retail E-Commerce Unit Economics
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **Discount Factor**: Computes `(1 - discount_pct / 100.0)`.
2. **Gross vs Net**: Multiplies quantity and unit price by the discount multiplier.
3. **Margin Calculation**: Deducts total COGS (`cost_price * quantity`) to yield net profit.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **The Integer Division Truncation Trap**:
   - In SQL Server and PostgreSQL, dividing two integer types (`15 / 100`) truncates fractional components to integer zero (`0`). Using decimal literals (`100.0`) forces floating-point decimal division.
2. **Column Alias Reusability in the Same `SELECT`**:
   - Projections evaluate concurrently; an alias declared in column 3 (`net_revenue`) cannot be referenced inside column 4 within the same `SELECT`. For cleaner architecture, wrap in a CTE.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"We enforce explicit decimal precision using literals like `100.0` to avoid catastrophic integer division truncation. Furthermore, because column aliases in standard ANSI SQL are not accessible within the same projection pass, modularizing calculations with CTEs prevents formula duplication and ensures cleaner maintainability."*
