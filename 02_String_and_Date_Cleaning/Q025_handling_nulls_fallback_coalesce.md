# Q025: Handling NULLs & Multi-Tier Fallback Imputation (`COALESCE`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 025 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an enterprise CRM and omnichannel communication gateway, transactional notification alerts (such as payment receipts and OTP dispatches) must reach high-value customers. However, customer contact profiles frequently contain missing attributes. The engineering team requires implementing a prioritized fallback mechanism: attempt delivery to `primary_phone`; if missing, fall back to `alternate_phone`; if still missing, fall back to `email_id`; and if all contact channels are absent, assign a standard label `'No Contact Available'`. The report focuses strictly on active `Premium` accounts.

---

## 📊 Sample Mock Table (`customer_contacts`)

| contact_id | customer_name | primary_phone | alternate_phone | email_id | account_type |
| :---: | :--- | :--- | :--- | :--- | :--- |
| 101 | Amit Sharma | 9876543210 | 9123456789 | amit@gmail.com | Premium |
| 102 | Sneha Rao | NULL | 9988776655 | sneha@yahoo.com | Premium |
| 103 | Rohan Varma | NULL | NULL | rohan@tech.co | Standard |
| 104 | Priya Das | NULL | NULL | priya@gmail.com | Premium |
| 105 | Kunal Sen | NULL | NULL | NULL | Premium |
| 106 | Pooja Jain | 9765432198 | NULL | NULL | Premium |

---

## 🎯 Expected Output

| contact_id | customer_name | preferred_contact | account_type |
| :---: | :--- | :--- | :--- |
| 101 | Amit Sharma | 9876543210 | Premium |
| 102 | Sneha Rao | 9988776655 | Premium |
| 104 | Priya Das | priya@gmail.com | Premium |
| 105 | Kunal Sen | No Contact Available | Premium |
| 106 | Pooja Jain | 9765432198 | Premium |

---

## 💡 Production SQL Solution

```sql
SELECT 
    contact_id, 
    customer_name, 
    COALESCE(primary_phone, alternate_phone, email_id, 'No Contact Available') AS preferred_contact, 
    account_type 
FROM customer_contacts 
WHERE account_type = 'Premium' 
ORDER BY contact_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why `COALESCE()` Instead of `IFNULL()` or `NVL()`?**
   - `IFNULL()` (MySQL) and `NVL()` (Oracle) only take strictly **two** arguments (`col, default_val`). They cannot handle multi-tier fallback hierarchies without awkward, deeply nested function calls: `IFNULL(a, IFNULL(b, IFNULL(c, d)))`.
   - `COALESCE(...)` is an official **ANSI SQL standard** function that accepts an infinite number of comma-separated arguments, evaluating sequentially until it encounters the **first non-null value**.

2. **Short-Circuit Evaluation in `COALESCE`:**
   - Database engines evaluate `COALESCE` lazily from left to right.
   - For Amit Sharma (Contact 101), because `primary_phone` is non-null, the engine immediately returns it without ever reading or evaluating `alternate_phone` or `email_id` from memory.

3. **Data Type Precedence Rule:**
   - In standard SQL engines, all arguments inside `COALESCE` must be either of identical data types or implicitly coercible to a shared target data type. Passing mixed incompatible types (such as integers and unquoted dates) can trigger implicit conversion exceptions.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Nested `IFNULL` vs `COALESCE`:**
   - *Interviewer:* "Can you achieve the exact same 4-tier fallback using `IFNULL()`?"
   - *Defense:* Yes, by writing `IFNULL(primary_phone, IFNULL(alternate_phone, IFNULL(email_id, 'No Contact Available')))`. However, this is an anti-pattern: it degrades query readability, increases syntactic error risk, and is non-portable outside MySQL/SQLite. `COALESCE` is ANSI compliant and handles n-arguments natively.

2. **Trap: Empty String `''` vs `NULL` Trap:**
   - *Interviewer:* "What if a user has `primary_phone = ''` (an empty string, not NULL)? What does `COALESCE('', alternate_phone)` return?"
   - *Defense:* It returns `''` (the empty string)! In SQL, an empty string is a valid non-null character value. To treat empty strings as NULLs in dirty legacy data, we wrap the column with `NULLIF(primary_phone, '')` before passing to `COALESCE`.
