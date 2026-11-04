# Q004: Customer Segmentation via Pattern Matching (LIKE, %, NOT LIKE)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 004 / 150
- **Company Tag:** Salesforce / HubSpot / CRM Marketing Startups
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A CRM marketing team is launching a promotional onboarding campaign. They need to extract genuine customer accounts:
1. Customer name begins with the letter 'A' (`LIKE 'A%'`).
2. Email domain belongs strictly to Gmail (`LIKE '%@gmail.com'`).
3. Exclude internal QA, staging, and dummy accounts where email contains 'test' (`NOT LIKE '%test%'`).

---

## 📊 Sample Mock Table (`customers`)

| customer_id | customer_name | email | city |
| :--- | :--- | :--- | :--- |
| 301 | Amit Sharma | amit.sharma@gmail.com | Delhi |
| 302 | Anjali Verma | anjali_test@gmail.com | Mumbai |
| 303 | Rohit Kumar | rohit.k@gmail.com | Pune |
| 304 | Aarti Patel | aarti.patel@yahoo.com | Ahmedabad |
| 305 | Alok Gupta | alok.gupta@gmail.com | Kolkata |
| 306 | Akash Roy | akash123@hotmail.com | Bangalore |
| 307 | test_user | ajay.test@gmail.com | Chennai |

---

## 🎯 Expected Output Table

| customer_id | customer_name | email | city |
| :--- | :--- | :--- | :--- |
| 301 | Amit Sharma | amit.sharma@gmail.com | Delhi |
| 305 | Alok Gupta | alok.gupta@gmail.com | Kolkata |

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

1. **Anchor Wildcard vs Leading Wildcard**:
   - `LIKE 'A%'` anchors at the beginning and utilizes standard B-Tree index range scans.
   - `LIKE '%@gmail.com'` contains a leading wildcard, forcing an engine-level table scan unless specialized trigram (`pg_trgm`) or functional expression indexes are configured.

2. **Negative Filtering (`NOT LIKE`)**:
   - Eliminates false-positive test/staging accounts to protect email deliverability scores and reduce campaign spend.
