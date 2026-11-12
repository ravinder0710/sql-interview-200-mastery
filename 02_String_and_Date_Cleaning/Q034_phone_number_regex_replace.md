# Q034: Phone Number Regex Standardization (`REGEXP_REPLACE`, `RIGHT`)

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q034 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / CRM Data Engineer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL 8.0+ (`REGEXP_REPLACE`), PostgreSQL (`REGEXP_REPLACE`), Snowflake (`REGEXP_REPLACE`), Oracle

---

## 🏢 Business Scenario
In CRM pipelines, lead capture forms, and telemarketing platforms (e.g., Salesforce, HubSpot, Exotel, Twilio SMS Gateways), phone numbers arrive in disparate, dirty formats populated with formatting noise: leading country codes (`+91`), parentheses, hyphens, prefixes (`0`), and whitespace (e.g., `+91 (987) 654-3210` or `09123-456-789`).

Downstream automated SMS and WhatsApp marketing gateways strictly require a standardized 10-digit mobile number format (`9876543210`). Discrepancies lead to campaign broadcast failures, SMS dispatch errors, and inaccurate CRM deduplication.

The Sales Operations lead requires a sanitized extract of qualified prospects where:
1. `lead_status = 'Qualified'`.
2. `lead_score >= 50`.
3. Non-digit punctuation and symbols are stripped, and the trailing 10 digits are extracted as `clean_phone_10digit`.
4. Invalid entries (e.g., text artifacts like `N/A-Invalid` having fewer than 10 digits) are filtered out.
5. Sorted by `lead_score DESC, lead_id ASC`.

---

## 📊 Sample Mock Table: `lead_contacts`

| lead_id | lead_name | raw_phone | lead_status | lead_score |
|:---:|:---:|:---:|:---:|:---:|
| 401 | Rohan Gupta | `+91 (987) 654-3210` | Qualified | 85 |
| 402 | Ananya Sen | `09123-456-789` | Qualified | 40 |
| 403 | Karan Malhotra | `+91 99887 76655` | Qualified | 92 |
| 404 | Pooja Nair | `98220-11223` | Contacted | 70 |
| 405 | Manish Joshi | `(981) 122-3344` | Qualified | 65 |
| 406 | Divya Rao | `N/A-Invalid` | Qualified | 78 |

---

## 🎯 Expected Output Table

| lead_id | lead_name | clean_phone_10digit | lead_status | lead_score |
|:---:|:---:|:---:|:---:|:---:|
| 403 | Karan Malhotra | `9988776655` | Qualified | 92 |
| 401 | Rohan Gupta | `9876543210` | Qualified | 85 |
| 405 | Manish Joshi | `9811223344` | Qualified | 65 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    lead_id, 
    lead_name, 
    RIGHT(REGEXP_REPLACE(raw_phone, '[^0-9]', ''), 10) AS clean_phone_10digit, 
    lead_status, 
    lead_score 
FROM lead_contacts 
WHERE lead_status = 'Qualified' 
  AND lead_score >= 50 
  AND LENGTH(REGEXP_REPLACE(raw_phone, '[^0-9]', '')) >= 10 
ORDER BY lead_score DESC, lead_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. The Negated Digit Regex Pattern `[^0-9]`
- `[^0-9]` is a negated character class matching any single character that is **not** a numeric digit from 0 through 9 (including spaces, hyphens `-`, parentheses `()`, plus signs `+`, and letters).
- `REGEXP_REPLACE(raw_phone, '[^0-9]', '')` replaces all matching non-digits with an empty string `''`, leaving a contiguous sequence of numbers.

### 2. Extracting Standard 10-Digit Domestic Numbers
- Phone entries often include variable-length prefixes (`+91`, `91`, `0`).
- Applying `RIGHT(..., 10)` captures the trailing 10 digits representing the standard national subscriber number, automatically bypassing international dialing codes.

### 3. Guarding Against Garbage Strings with `LENGTH()`
- Text artifacts like `'N/A-Invalid'` yield an empty string `''` after non-digit removal.
- Adding `LENGTH(REGEXP_REPLACE(raw_phone, '[^0-9]', '')) >= 10` in the `WHERE` clause protects against corrupt records and truncated phone numbers.

---

## 🚨 Common Interview Traps & Defense

### Trap 1: TRAI Mobile Series Validation (Indian Telecom)
- **Interviewer Query:** *"What if the stripped 10-digit number starts with an invalid digit like 0 or 1?"*
- **Candidate Defense:**
  > *"Under Indian telecommunication regulations (TRAI guidelines), mobile numbers must begin with digits 6, 7, 8, or 9. To guard against invalid numbers, we append a pattern check:
  > ```sql
  > AND RIGHT(REGEXP_REPLACE(raw_phone, '[^0-9]', ''), 10) REGEXP '^[6-9][0-9]{9}$'
  > ```
  > This enforces both length and valid mobile prefix compliance."*

### Trap 2: SQL Server (T-SQL) Compatibility
- **Interviewer Query:** *"Does Microsoft SQL Server support `REGEXP_REPLACE` natively?"*
- **Candidate Defense:**
  > *"No, T-SQL lacks native POSIX regular expression support unless CLR assemblies are enabled. In SQL Server environments, data engineers achieve character cleaning through repeated `REPLACE` chains, `TRANSLATE` functions, or perform regex sanitation upstream in Python/SSIS pipelines."*
