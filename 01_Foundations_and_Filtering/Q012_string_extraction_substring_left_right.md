# Q012: String Parsing & Data Masking (`SUBSTRING`, `LEFT`, `RIGHT`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 012 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In a customer support ticketing portal, sensitive customer information (Personally Identifiable Information - PII) such as mobile numbers must be masked for data privacy compliance before being displayed on triage dashboards. Additionally, business operations require parsing ticket alphanumeric issue codes (`CAT-YEAR-SUB`) into granular dimensions: the leading category code and the 4-digit incident year.

---

## 📊 Sample Mock Table (`customer_tickets`)

| ticket_id | customer_name | phone_number | issue_code | priority |
| :---: | :--- | :--- | :--- | :--- |
| 901 | Rahul Verma | 9876543210 | BILL-2023-NET | High |
| 902 | Sneha Rao | 9123456789 | TECH-2024-WIFI | Medium |
| 903 | Aman Jain | 9988776655 | ACCT-2023-KYC | High |
| 904 | Priya Roy | 9456123789 | BILL-2022-ROAM | Low |
| 905 | Kunal Sen | 9765432198 | SIMC-2024-SWAP | High |

---

## 🎯 Expected Output

| ticket_id | customer_name | masked_phone | category_code | issue_year |
| :---: | :--- | :--- | :--- | :--- |
| 901 | Rahul Verma | XXXXXX3210 | BILL | 2023 |
| 903 | Aman Jain | XXXXXX6655 | ACCT | 2023 |
| 905 | Kunal Sen | XXXXXX2198 | SIMC | 2024 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    ticket_id, 
    customer_name, 
    CONCAT('XXXXXX', RIGHT(phone_number, 4)) AS masked_phone, 
    LEFT(issue_code, 4) AS category_code, 
    SUBSTRING(issue_code, 6, 4) AS issue_year 
FROM customer_tickets 
WHERE priority = 'High' 
ORDER BY ticket_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why `SUBSTRING()` Indexing Starts at 1?**
   - Unlike programming languages like Python, C++, or Java which use **0-based indexing**, SQL standard indexing is strictly **1-based**.
   - In string `BILL-2023-NET`:
     - Index 1 to 4 is `BILL`
     - Index 5 is `-`
     - Index 6 begins `2023`
   - Therefore, `SUBSTRING(issue_code, 6, 4)` starts at index 6 and extracts 4 characters.

2. **Function Specialization (`LEFT` & `RIGHT`):**
   - `LEFT(str, n)` is shorthand for `SUBSTRING(str, 1, n)`.
   - `RIGHT(str, n)` extracts the trailing $n$ characters regardless of total string length, making it ideal for PII masking (credit cards, bank accounts, phone numbers).

3. **ANSI SQL Equivalents (`SUBSTR`):**
   - Oracle and SQLite use `SUBSTR()` instead of `SUBSTRING()`.
   - PostgreSQL and MySQL support both `SUBSTR()` and `SUBSTRING()`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: 0-Based Indexing Mental Slip:**
   - *Interviewer:* "If you specify `SUBSTRING(issue_code, 5, 4)`, what will be returned?"
   - *Defense:* Because SQL is 1-indexed, index 5 is the hyphen (`-`). It would return `-202`, causing corrupt data extraction. Position 6 is the exact start of the year.

2. **Trap: Dynamic Delimiter Parsing:**
   - *Interviewer:* "What if the prefix is not fixed at 4 characters (e.g. `ACCOUNTING-2023-NET` vs `IT-2024-WIFI`)? Will `SUBSTRING(..., 6, 4)` still work?"
   - *Defense:* No. Fixed offsets fail on variable-length codes. For dynamic tokens, we use delimiter search functions like `INSTR()` (or `CHARINDEX()` / `POSITION()`) combined with `SUBSTRING()`, or regex functions like `REGEXP_SUBSTR()`.
