# Q016: Cleaning Inconsistent Phone Prefixes (`RIGHT`, `REPLACE`, `LENGTH`)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 016 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
A FinTech mobile banking platform integrates with an SMS OTP delivery gateway. During customer onboarding, users enter phone numbers with irregular formats, including country prefixes (`+91`), trunk dialing zeros (`0`), and internal hyphens (`-`). To ensure automated OTP dispatches do not fail, the engineering team requires sanitizing raw input into standardized 10-digit mobile numbers, filtering strictly for active accounts and excluding corrupted or truncated entries.

---

## 📊 Sample Mock Table (`user_profiles`)

| user_id | full_name | raw_phone | account_status |
| :---: | :--- | :--- | :--- |
| 101 | Amit Sharma | +91-9876543210 | Active |
| 102 | Sneha Rao | 09123456789 | Active |
| 103 | Rohan Varma | 99887-76655 | Active |
| 104 | Priya Das | 945612 | Active |
| 105 | Kunal Sen | +919765432198 | Suspended |
| 106 | Pooja Jain | 9876543210 | Active |

---

## 🎯 Expected Output

| user_id | full_name | clean_phone | account_status |
| :---: | :--- | :--- | :--- |
| 101 | Amit Sharma | 9876543210 | Active |
| 102 | Sneha Rao | 9123456789 | Active |
| 103 | Rohan Varma | 9988776655 | Active |
| 106 | Pooja Jain | 9876543210 | Active |

---

## 💡 Production SQL Solution

```sql
SELECT 
    user_id, 
    full_name, 
    RIGHT(REPLACE(raw_phone, '-', ''), 10) AS clean_phone, 
    account_status 
FROM user_profiles 
WHERE account_status = 'Active' 
  AND LENGTH(RIGHT(REPLACE(raw_phone, '-', ''), 10)) = 10 
ORDER BY user_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why Replace with Empty String `''` Instead of Space `' '`?**
   - Writing `REPLACE(raw_phone, '-', '')` strips the character completely, merging disconnected digit segments (e.g. `99887-76655` $\longrightarrow$ `9988776655`).
   - Replacing with a space `' '` leaves internal whitespace, causing the final 10 characters to retain spaces (`9887 76655`), which crashes downstream SMS APIs.

2. **The `RIGHT(..., 10)` Normalization Pattern:**
   - Regardless of whether the user inputs `+91-9876543210` (14 chars), `09876543210` (11 chars), or `9876543210` (10 chars), extracting the rightmost 10 characters reliably captures the standard national subscriber number.

3. **Defensive Length Verification:**
   - The predicate `LENGTH(RIGHT(REPLACE(raw_phone, '-', ''), 10)) = 10` acts as a data quality gate, discarding incomplete inputs (such as Priya Das's 6-digit number `'945612'`).

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Short Strings in `RIGHT()`:**
   - *Interviewer:* "If `raw_phone` is only 6 characters long (`945612`), what does `RIGHT(raw_phone, 10)` return in SQL?"
   - *Defense:* In standard SQL, if the requested length exceeds the string length, `RIGHT()` simply returns the entire string without throwing an error. That is why filtering on `LENGTH(...) = 10` is mandatory to catch and discard invalid short phone numbers.

2. **Trap: International Dialing Code Lengths:**
   - *Interviewer:* "What if international users sign up with 11-digit UK numbers or 9-digit numbers?"
   - *Defense:* Hardcoding `RIGHT(..., 10)` is strictly tailored to 10-digit national plans (such as India or the US NANP). For multi-national platforms, we store the ISO country code in a separate attribute and parse phone numbers via E.164 standardization libraries or regex patterns like `REGEXP_REPLACE()`.
