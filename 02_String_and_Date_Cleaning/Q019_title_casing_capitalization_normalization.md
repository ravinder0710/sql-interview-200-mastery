# Q019: Title Casing & Capitalization Normalization (`CONCAT`, `UPPER`, `LOWER`, `SUBSTRING`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 019 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an e-commerce marketplace seller onboarding workflow, third-party merchants input product titles in inconsistent casings, such as all-uppercase (`'TABLET'`), inverted caps (`'lAPTOP'`), or camel-case variants (`'smartWATCH'`). For a clean user interface and standardized catalog presentation, the data platform requires converting product names into **Proper Title Case** (initial character capitalized and all trailing characters lowercased) for all active, premium inventory (`is_available = TRUE` and `unit_price >= 1000`).

---

## 📊 Sample Mock Table (`product_catalog`)

| product_id | raw_product_name | category | unit_price | is_available |
| :---: | :--- | :--- | :---: | :--- |
| 201 | lAPTOP | Electronics | 55000.00 | True |
| 202 | smartWATCH | Electronics | 4500.00 | True |
| 203 | cABLE | Accessories | 499.00 | True |
| 204 | TABLET | Electronics | 28000.00 | False |
| 205 | kETTLE | Appliances | 1200.00 | True |
| 206 | hEADPHONES | Audio | 3500.00 | True |

---

## 🎯 Expected Output

| product_id | clean_product_name | category | unit_price |
| :---: | :--- | :--- | :---: |
| 201 | Laptop | Electronics | 55000.00 |
| 202 | Smartwatch | Electronics | 4500.00 |
| 206 | Headphones | Audio | 3500.00 |
| 205 | Kettle | Appliances | 1200.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    product_id, 
    CONCAT(
        UPPER(LEFT(raw_product_name, 1)), 
        LOWER(SUBSTRING(raw_product_name, 2))
    ) AS clean_product_name, 
    category, 
    unit_price 
FROM product_catalog 
WHERE is_available = TRUE 
  AND unit_price >= 1000 
ORDER BY 
    unit_price DESC, 
    product_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Title Case Decomposition Formula:**
   - Because standard ANSI SQL and MySQL lack a built-in `PROPER()` or `INITCAP()` function (unlike Oracle and PostgreSQL), analysts construct proper casing by decomposing the string:
     $$\mathbf{CONCAT}\Big(\mathbf{UPPER}(\mathbf{LEFT}(\text{str}, 1)),\ \mathbf{LOWER}(\mathbf{SUBSTRING}(\text{str}, 2))\Big)$$
   - `LEFT(str, 1)` captures the first letter.
   - `SUBSTRING(str, 2)` extracts all remaining characters from position 2 to the end of the string.

2. **Cross-Engine `INITCAP()` Native Support:**
   - **PostgreSQL / Oracle / Snowflake**: Native function `INITCAP(raw_product_name)` capitalizes the first letter of each word automatically.
   - **MySQL / SQL Server**: Native `INITCAP()` is absent, making manual decomposition via `CONCAT + UPPER + LOWER` a high-frequency interview problem.

3. **Multi-Word String Limitations:**
   - The expression `SUBSTRING(..., 2)` works cleanly for single-word nouns. For complex multi-word titles (e.g. `'wireless noise cancelling headphones'`), capitalizing every distinct word in MySQL requires user-defined functions (UDF) or recursive CTE string splitting.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Misplaced Parenthesis in Substring:**
   - *Interviewer:* "What happens if someone writes `LOWER(SUBSTRING(col), 2))`?"
   - *Defense:* A syntax error is thrown because `SUBSTRING(col)` is closed prematurely without its mandatory starting index. The start offset `2` must reside inside the function call: `SUBSTRING(col, 2)`.

2. **Trap: Handling Leading Spaces Before Title Casing:**
   - *Interviewer:* "What happens if `raw_product_name` has a leading space (e.g. `' laptop'`)?"
   - *Defense:* `LEFT(col, 1)` captures the whitespace character, leaving the first actual letter lowercased (`' laptop'`). In production cleaning pipelines, we defensively apply `TRIM()` first:  
     `UPPER(LEFT(TRIM(raw_product_name), 1))`.
