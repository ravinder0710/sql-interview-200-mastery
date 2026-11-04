# Q008: Nth Highest Value via Pagination (`LIMIT 1 OFFSET N-1` + `DISTINCT`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 008 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

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

## 🎯 Expected Output

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

## 🧠 Interview Defense & Technical Takeaways

1. **The Nth Highest Mathematical Formula:**
   - The general pagination formula to retrieve the Nth distinct record is:
     $$\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$$
   - To find the 2nd highest: `OFFSET 1` skips the top record, and `LIMIT 1` retrieves the immediately following record.

2. **Why `DISTINCT` is Compulsory:**
   - If two or more properties share the top price (e.g., both Prestige Villa and Sobha Penthouse are 4.5 Cr), sorting without `DISTINCT` causes `OFFSET 1` to return the duplicate 4.5 Cr instead of the true 2nd tier price (2.8 Cr).

3. **Enterprise Robustness with Scalar Subqueries:**
   - Wrapping the query in an outer `SELECT ( ... ) AS second_highest_price` guarantees returning a single row containing `NULL` if fewer than $N$ qualifying records exist, strictly satisfying edge cases.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: The Duplicate Rank Trap:**
   - *Interviewer:* "What happens if both top properties are priced at 4.5 Cr and you omit `DISTINCT`?"
   - *Defense:* The query would return 4.5 Cr again, which is a duplicate of the highest price rather than the distinct second highest. Pre-aggregating unique values via `DISTINCT` is essential.

2. **Trap: Empty Result Set vs NULL (LeetCode 176):**
   - *Interviewer:* "If the table only contains 1 property in Bangalore, what does `LIMIT 1 OFFSET 1` return?"
   - *Defense:* It returns an empty result set (0 rows). If an enterprise pipeline or interviewer expects a single-row `NULL`, we encapsulate it: `SELECT (SELECT DISTINCT price FROM properties WHERE city = 'Bangalore' ORDER BY price DESC LIMIT 1 OFFSET 1) AS second_highest_price;`.
