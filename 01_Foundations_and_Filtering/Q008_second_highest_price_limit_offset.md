# Q008: Nth Highest Value via Pagination (LIMIT 1 OFFSET N-1 with DISTINCT)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 008 / 150
- **Company Tag:** MagicBricks / 99acres / Housing Real Estate Analytics
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A real estate analytics platform needs to determine the second highest unique property price in 'Bangalore' to benchmark luxury housing tiers without skew from maximum pricing outliers. 

Retrieve exactly one column named `second_highest_price`.

---

## 📊 Sample Mock Table (`properties`)

| property_id | property_name | city | price |
| :--- | :--- | :--- | :--- |
| 801 | Prestige Golfshire | Bangalore | 45000000.00 |
| 802 | Godrej Woods | Noida | 38000000.00 |
| 803 | Sobha Dream Acres | Bangalore | 45000000.00 |
| 804 | Brigade Gateway | Bangalore | 32000000.00 |
| 805 | DLF Magnolias | Gurgaon | 95000000.00 |
| 806 | Purva Palm Beach | Bangalore | 28000000.00 |
| 807 | Total Environment | Bangalore | 41000000.00 |

---

## 🎯 Expected Output Table

| second_highest_price |
| :--- |
| 41000000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT DISTINCT price AS second_highest_price 
FROM properties 
WHERE city = 'Bangalore' 
ORDER BY price DESC 
LIMIT 1 OFFSET 1;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Deduplication before Offsetting**:
   - Without `DISTINCT`, if multiple records share the maximum price, `OFFSET 1` returns the duplicate maximum price rather than the true second highest tier.

2. **Nth-Value Pagination Formula**:
   - `ORDER BY col DESC LIMIT 1 OFFSET (N - 1)`.

3. **Scalar Subquery Wrapping for NULL Handling (LeetCode 176)**:
   - When a dataset contains fewer than N records, `LIMIT 1 OFFSET (N-1)` returns an empty result set (0 rows).
   - Wrapping the query in an outer `SELECT ( ... ) AS nth_val` forces the engine to return `NULL` when the subquery produces no rows.
