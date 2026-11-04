# Q008: Nth Highest Value via Pagination (`LIMIT 1 OFFSET N-1` + `DISTINCT`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 008 / 200
- **Company Tag:** MagicBricks, 99acres
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A real estate valuation platform in Bangalore is creating an automated pricing benchmark model. To exclude extreme luxury penthouse outliers while establishing a realistic upper market baseline, the pricing algorithm requires identifying the distinct second-highest property price listed in the city.

---

## 📊 Sample Mock Table (`properties`)

| property_id | property_title | city | price | bhk |
| :---: | :--- | :--- | :---: | :---: |
| 101 | Prestige Villa | Bangalore | 45000000.00 | 4 |
| 102 | Sobha Penthouse | Bangalore | 45000000.00 | 4 |
| 103 | Brigade Heights | Bangalore | 28000000.00 | 3 |
| 104 | Godrej Woods | Bangalore | 19500000.00 | 2 |
| 105 | Puravankara Flat | Mumbai | 32000000.00 | 3 |
| 106 | Salarpuria Bliss | Bangalore | 15000000.00 | 2 |

---

## 🎯 Expected Output Table

| second_highest_price |
| :---: |
| 28000000.00 |

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

## ⚙️ Execution Logic & Query Lifecycle
1. **Deduplication**: `DISTINCT price` consolidates duplicate values before ranking.
2. **Sorting**: Orders unique prices in descending order.
3. **Offset & Limit**: The mathematical formula for the Nth highest value is $\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$. Skipping 1 row (`OFFSET 1`) and fetching 1 row (`LIMIT 1`) retrieves the exact second-highest benchmark.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **The Duplicate Rank Trap**:
   - Both Prestige Villa and Sobha Penthouse are priced at 4.5 Cr. Without `DISTINCT`, `OFFSET 1` would erroneously return 4.5 Cr again rather than the true second-highest tier (2.8 Cr).
2. **Empty Result Set vs NULL (LeetCode 176 Trap)**:
   - If the dataset contains fewer than $N$ qualifying records, `LIMIT 1 OFFSET 1` returns an empty set (0 rows). To guarantee returning a single row containing `NULL`, encapsulate the query within an outer scalar `SELECT`:
     ```sql
     SELECT (
         SELECT DISTINCT price 
         FROM properties 
         WHERE city = 'Bangalore' 
         ORDER BY price DESC 
         LIMIT 1 OFFSET 1
     ) AS second_highest_price;
     ```

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"Retrieving the true Nth highest metric requires pre-aggregating duplicates via `DISTINCT` to avoid returning redundant duplicate values. Wrapping the paginated query inside an outer scalar projection ensures that if fewer than N records exist, the database gracefully returns a single row with NULL rather than an empty result set."*
