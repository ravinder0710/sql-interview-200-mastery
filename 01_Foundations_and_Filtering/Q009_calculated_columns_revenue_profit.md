# Q009: Calculated Columns, Arithmetic Precedence & Integer Division Prevention

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 009 / 150
- **Company Tag:** Amazon / Retail E-Commerce Unit Economics
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A retail enterprise finance manager requires a profitability breakdown for all completed customer orders:
1. Net Revenue: `(unit_price * quantity) * (1 - discount_pct / 100.0)`
2. Total Profit: `Net Revenue - (cost_price * quantity)`

Display item ID, item name, net revenue, and profit. 
Sort the results by profit in descending order.

---

## 📊 Sample Mock Table (`order_items`)

| item_id | item_name | unit_price | cost_price | quantity | discount_pct | order_status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 901 | Gaming Mouse | 2000.00 | 1200.00 | 2 | 10.00 | Completed |
| 902 | Mechanical Keyboard | 5000.00 | 3000.00 | 1 | 20.00 | Completed |
| 903 | USB-C Cable | 500.00 | 200.00 | 3 | 0.00 | Refunded |
| 904 | Wireless Headset | 4000.00 | 2500.00 | 2 | 15.00 | Completed |
| 905 | Monitor Stand | 1500.00 | 900.00 | 1 | 5.00 | Pending |
| 906 | Mousepad RGB | 1000.00 | 400.00 | 4 | 0.00 | Completed |

---

## 🎯 Expected Output Table

| item_id | item_name | net_revenue | profit |
| :--- | :--- | :--- | :--- |
| 906 | Mousepad RGB | 4000.00 | 2400.00 |
| 904 | Wireless Headset | 6800.00 | 1800.00 |
| 901 | Gaming Mouse | 3600.00 | 1200.00 |
| 902 | Mechanical Keyboard | 4000.00 | 1000.00 |

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

1. **Integer Division Truncation**:
   - Dividing integers by `100` truncates decimals to zero in engines like SQL Server and PostgreSQL. Dividing by `100.0` guarantees floating/decimal precision.

2. **Alias Evaluation Order**:
   - Expressions in the `SELECT` clause are logically evaluated in parallel. An alias created on line 3 cannot be referenced on line 4 within the same projection list. To eliminate expression duplication in production, Common Table Expressions (CTEs) are preferred.

3. **ORDER BY on Computed Aliases**:
   - Because `ORDER BY` is evaluated after `SELECT` in standard SQL execution pipelines, referencing computed column aliases (e.g. `ORDER BY profit DESC`) is standard ANSI compliant behavior.
