# Q024: Regex Alphanumeric Validation (`REGEXP`, `RLIKE`, Anchors)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 024 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an Indian FinTech neo-bank KYC onboarding pipeline, customers submit their Income Tax Permanent Account Number (PAN). Standard Indian PAN cards adhere strictly to an exact 10-character structure: 5 uppercase letters, followed by 4 numeric digits, terminating in 1 uppercase letter (`[A-Z]{5}[0-9]{4}[A-Z]`). To protect downstream automated credit bureau API integration from failing, the risk compliance team requires isolating all submitted records (`submission_status = 'Submitted'`) that violate this structural specification so that users can be prompted for re-verification.

---

## 📊 Sample Mock Table (`kyc_verifications`)

| kyc_id | customer_name | pan_number | submission_status |
| :---: | :--- | :--- | :--- |
| 301 | Ramesh Gupta | ABCDE1234F | Submitted |
| 302 | Sunita Sen | 12345ABCDE | Submitted |
| 303 | Vikas Mehra | ABCD12345F | Submitted |
| 304 | Anita Roy | PQRST5678K | Draft |
| 305 | Tarun Das | XYZAB9901M | Submitted |
| 306 | Meena Jain | AB12CDE345 | Submitted |

---

## 🎯 Expected Output

| kyc_id | customer_name | pan_number | submission_status |
| :---: | :--- | :--- | :--- |
| 302 | Sunita Sen | 12345ABCDE | Submitted |
| 303 | Vikas Mehra | ABCD12345F | Submitted |
| 306 | Meena Jain | AB12CDE345 | Submitted |

---

## 💡 Production SQL Solution

```sql
SELECT 
    kyc_id, 
    customer_name, 
    pan_number, 
    submission_status 
FROM kyc_verifications 
WHERE submission_status = 'Submitted' 
  AND pan_number NOT REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$' 
ORDER BY kyc_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **The Critical Necessity of Anchors (`^` and `$`):**
   - The caret `^` anchors the evaluation to the very start of the string, while the dollar sign `$` anchors it to the exact end.
   - Without anchors (e.g. `[A-Z]{5}[0-9]{4}[A-Z]`), a malformed 15-character string like `'XXXXXABCDE1234FYYYY'` would return a false positive match because the substring exists internally! Anchors enforce exact boundary validation.

2. **Cross-Engine Regex Syntax Variations:**
   - **MySQL**: `REGEXP` or `RLIKE`
   - **PostgreSQL**: `~` (case-sensitive match), `~*` (case-insensitive), `!~` (negated match)
   - **Oracle**: `REGEXP_LIKE(pan_number, '^[A-Z]{5}[0-9]{4}[A-Z]$')`
   - **SQL Server (T-SQL)**: Lacks native regex engine; developers use wildcard character classes `LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]'`.

3. **Case Sensitivity in Regular Expressions:**
   - In MySQL with binary collations or PostgreSQL (`~`), lowercased entries like `'abcde1234f'` fail regex match unless `[a-zA-Z]` is specified or the column is normalized with `UPPER()`.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Omission of Anchors (`^` and `$`):**
   - *Interviewer:* "What happens if someone enters `'ABCDE1234F_EXTRA_CHARS'` and you omit `^` and `$`?"
   - *Defense:* Without `^` and `$`, regex performs a partial substring search anywhere inside the string. It will incorrectly evaluate `'ABCDE1234F_EXTRA_CHARS'` as valid. Anchors guarantee that the string starts and terminates strictly across the 10 defined characters.

2. **Trap: T-SQL Regex Support Trap:**
   - *Interviewer:* "Can you run `REGEXP` in Microsoft SQL Server?"
   - *Defense:* No. SQL Server does not provide a native `REGEXP` keyword. Instead, developers emulate regex using character classes with `LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]'` or deploy CLR (Common Language Runtime) C# regular expression functions.
