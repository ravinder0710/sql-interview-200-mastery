# Q029: Credit Card & PII Data Masking (PCI-DSS Compliance)

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q029 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server

---

## 🏢 Business Scenario
In global FinTech payment gateways and banking platforms (e.g., Razorpay, Stripe, Paytm, HDFC), compliance standards like **PCI-DSS (Payment Card Industry Data Security Standard)** and privacy regulations strictly prohibit exposing unmasked 16-digit Primary Account Numbers (PAN) to unauthorized staff, BI analysts, or customer support dashboards.

To ensure compliance during analytics reporting, data engineers and analysts must redact sensitive card numbers by masking all leading characters with asterisks (`*`) while preserving only the final 4 digits for customer reference and receipt identification (e.g., `************1234`).

The Fraud & Risk team has requested a sanitized extract of active credit cards where:
1. `card_status = 'Active'`.
2. `card_type = 'Credit'`.
3. The card number is dynamically obfuscated into `masked_card_number`.
4. Output is sorted by `card_id ASC`.

---

## 📊 Sample Mock Table: `payment_cards`

| card_id | customer_name | card_number | card_type | card_status | credit_limit |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 501 | Rahul Sharma | 4532890123456789 | Credit | Active | 150000.00 |
| 502 | Priya Patel | 5123456789012345 | Debit | Active | 0.00 |
| 503 | Amit Verma | 4111222233334444 | Credit | Blocked | 75000.00 |
| 504 | Sneha Kulkarni | 3782822463100055 | Credit | Active | 200000.00 |
| 505 | Vikram Singh | 6011000990139424 | Credit | Expired | 50000.00 |
| 506 | Neha Mehta | 5500000012345678 | Credit | Active | 120000.00 |

---

## 🎯 Expected Output Table

| card_id | customer_name | masked_card_number | card_type | credit_limit |
|:---:|:---:|:---:|:---:|:---:|
| 501 | Rahul Sharma | `************6789` | Credit | 150000.00 |
| 504 | Sneha Kulkarni | `************0055` | Credit | 200000.00 |
| 506 | Neha Mehta | `************5678` | Credit | 120000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    card_id, 
    customer_name, 
    CONCAT(REPEAT('*', LENGTH(card_number) - 4), RIGHT(card_number, 4)) AS masked_card_number, 
    card_type, 
    credit_limit 
FROM payment_cards 
WHERE card_status = 'Active' 
  AND card_type = 'Credit' 
ORDER BY card_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Dynamic vs Static Masking Lengths
- Standard credit cards (Visa, Mastercard) are 16 digits, requiring 12 leading asterisks:
  ```sql
  CONCAT(REPEAT('*', 12), RIGHT(card_number, 4))
  ```
- **Enterprise Edge Case**: American Express (Amex) uses 15 digits; Diners Club uses 14 digits. Hardcoding `12` creates length discrepancies (`12 + 4 = 16`).
- Using `LENGTH(card_number) - 4` ensures dynamic padding regardless of card issuer length:
  ```sql
  CONCAT(REPEAT('*', LENGTH(card_number) - 4), RIGHT(card_number, 4))
  ```

### 2. Elegance with `LPAD`
- Many relational systems (MySQL, Oracle, PostgreSQL) support `LPAD`:
  ```sql
  LPAD(RIGHT(card_number, 4), LENGTH(card_number), '*') AS masked_card_number
  ```
  `LPAD` takes the 4 trailing characters and pads them on the left with asterisks until the total string length equals the original card length.

### 3. Dynamic Data Masking (DDM) in Enterprise SQL
- Modern RDBMS (SQL Server, Azure SQL, PostgreSQL 16+, Snowflake) feature native **Dynamic Data Masking (DDM)**:
  ```sql
  -- SQL Server DDM definition
  ALTER TABLE payment_cards 
  ALTER COLUMN card_number ADD MASKED WITH (FUNCTION = 'partial(0, "************", 4)');
  ```
  This applies masking automatically at the engine/user privilege level without modifying queries.

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Storing Plaintext PAN vs Presentation-Layer Obfuscation
- **Interviewer Query:** *"Why don't we store masked strings directly in the database table to save compute?"*
- **Candidate Defense:**
  > *"Operational payment processing pipelines (settlements, chargeback disputes, merchant webhooks) require the underlying token or encrypted PAN. Masking is strictly an egress/presentation layer security barrier enforced through SQL views, dynamic data masking, or column projection to maintain least-privilege access for analysts."*

### Trap 2: Numeric Data Types for Card Numbers
- **Interviewer Query:** *"What happens if `card_number` is defined as `BIGINT` instead of `VARCHAR(16)`?"*
- **Candidate Defense:**
  > *"Storing card numbers as integers causes two major failures:
  > 1. Leading zeroes (present in certain credit/debit bins) get dropped silently.
  > 2. String manipulation functions like `RIGHT()` or `LENGTH()` require implicit data type coercion, leading to performance degradation and formatting bugs. PII identifiers must always be stored as fixed-width alphanumeric strings (`VARCHAR(19)`)."*
