# Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 004 / 200
- **Company Tag:** Salesforce, HubSpot, CRM
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

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

## 🎯 Expected Output Table

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

## ⚙️ Execution Logic & Query Lifecycle
1. **Prefix Matching**: `customer_name LIKE 'A%'` anchors the search at the initial character 'A'.
2. **Domain Matching**: `email LIKE '%@gmail.com'` validates the ending domain.
3. **Negative Filter**: `email NOT LIKE '%test%'` eliminates sandbox and test records.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **Leading vs Trailing Wildcards & Index Invalidation**:
   - `LIKE 'A%'` (trailing wildcard) can leverage standard B-Tree indexes via an **Index Seek** because the initial key prefix is fixed.
   - `LIKE '%@gmail.com'` (leading wildcard) forces the query engine to perform an expensive **Full Table Scan** because the start of the string is non-deterministic.
2. **Production Mitigation**:
   - In production systems with millions of records, leading wildcard pattern matching is optimized using **Trigram Indexes (`pg_trgm`)** in PostgreSQL or Reverse Indexes.

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"Prefix pattern matching such as `LIKE 'A%'` is index-friendly and executes via B-Tree Index Range Seeks. However, leading wildcard predicates like `LIKE '%@gmail.com'` prevent index lookups, necessitating a Full Table Scan. In high-volume production databases, we support leading wildcard searches through Trigram GIN indexes or full-text catalog indexing to ensure sub-second response times."*
