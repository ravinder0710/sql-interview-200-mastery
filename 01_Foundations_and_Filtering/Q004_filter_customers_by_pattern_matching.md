# Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 004 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
A marketing growth team is preparing an automated promotional email broadcast. They need a verified list of genuine customer accounts whose names start with the letter 'A', whose primary email uses the official `@gmail.com` domain, and where internal dummy, test, or QA accounts containing the word `'test'` anywhere in their email address are strictly filtered out.

---

## 📊 Sample Mock Table (`customers`)

| customer_id | customer_name | email | city |
| :---: | :--- | :--- | :--- |
| 201 | Amit Roy | amit.roy@gmail.com | Delhi |
| 202 | Ananya Sen | ananya_test@gmail.com | Mumbai |
| 203 | Bharat Kumar | bharat@gmail.com | Bangalore |
| 204 | Aradhana Nair | aradhana@yahoo.com | Chennai |
| 205 | Alok Gupta | alok.gupta@gmail.com | Kolkata |
| 206 | Aakash Test | aakash@testdomain.com | Hyderabad |

---

## 🎯 Expected Output

| customer_id | customer_name | email | city |
| :---: | :--- | :--- | :--- |
| 201 | Amit Roy | amit.roy@gmail.com | Delhi |
| 205 | Alok Gupta | alok.gupta@gmail.com | Kolkata |

---

## 💡 Production SQL Solution

```sql
SELECT 
    customer_id, 
    customer_name, 
    email, 
    city 
FROM customers 
WHERE customer_name LIKE 'A%' 
  AND email LIKE '%@gmail.com' 
  AND email NOT LIKE '%test%';
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Wildcard Character Semantics:**
   - `%` matches zero, one, or multiple arbitrary characters.
   - `_` (underscore) matches exactly one single character placeholder.
   - Combining `%` with negative operator `NOT LIKE` provides clean filtering against dummy data patterns.

2. **Index Seek vs Full Table Scan:**
   - `LIKE 'A%'` (trailing wildcard) is index-friendly. The database engine executes an **Index Range Seek** because the string's starting prefix is known.
   - `LIKE '%@gmail.com'` (leading wildcard) invalidates standard B-Tree indexes because the string prefix is variable, forcing an expensive **Full Table Scan**.

3. **Case Sensitivity Across Databases:**
   - In MySQL and SQL Server, string comparisons are case-insensitive by default.
   - In PostgreSQL, `LIKE` is case-sensitive; `ILIKE` must be used for case-insensitive matching.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Leading Wildcard Performance:**
   - *Interviewer:* "On a table with 10 million rows, why will `email LIKE '%@gmail.com'` degrade performance?"
   - *Defense:* Leading wildcards prevent B-Tree indexes from determining the starting seek location. The database must inspect every row via a Full Table Scan. In production, we optimize this using Trigram GIN indexes (`pg_trgm`) or Reverse String Indexes.

2. **Trap: Missing Wildcard on Domain Matching:**
   - *Interviewer:* "What if someone wrote `email LIKE '@gmail.com'` without the leading `%`?"
   - *Defense:* It would only match a literal string `@gmail.com` with zero preceding characters. The leading `%` is mandatory to capture the username prefix.
