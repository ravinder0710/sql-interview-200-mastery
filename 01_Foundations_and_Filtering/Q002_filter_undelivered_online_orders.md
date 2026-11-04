# Q002: Undelivered Orders & The Famous NULL Trap

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 002 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Operations team ko dekhna hai ki online payment wale kitne orders abhi tak Deliver nahi hue (jaise In-Transit, Cancelled ya Pending) taaki unka delivery follow-up kiya ja sake."

---

## 📊 Sample Mock Table (`orders`)

| order_id | customer_name | order_status | payment_type | order_amount |
| :--- | :--- | :--- | :--- | :--- |
| 1001 | Rahul Sen | Delivered | Online | 1200.00 |
| 1002 | Meera Nair | In-Transit | Online | 2500.00 |
| 1003 | Arjun Kapoor | Cancelled | COD | 800.00 |
| 1004 | Swati Singh | Pending | Online | 3400.00 |
| 1005 | Vikas Jain | Delivered | COD | 1500.00 |
| 1006 | Priya Dhar | Returned | Online | 2100.00 |

---

## 🎯 Expected Output Table

| order_id | customer_name | order_status | order_amount |
| :--- | :--- | :--- | :--- |
| 1002 | Meera Nair | In-Transit | 2500.00 |
| 1004 | Swati Singh | Pending | 3400.00 |
| 1006 | Priya Dhar | Returned | 2100.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    order_id, 
    customer_name, 
    order_status, 
    order_amount 
FROM orders 
WHERE order_status <> 'Delivered' 
  AND payment_type = 'Online';
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum `WHERE order_status <> 'Delivered' AND payment_type = 'Online'` lagayenge. Isse Delivered wale chhod kar baaki sab orders filter ho jayenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Maan lo kisi naye order ka status abhi system mein khali (NULL) pada hua hai. Kya wo tumhari is query mein aayega?"*

* **🛡️ Trap ka Counter-Jawab:**
  "Nahi sir, SQL mein NULL ka matlab 'unknown' hota hai, toh `<> 'Delivered'` use bhi list se bahar phek dega. Agar business ko wo orders bhi dekhne hain jinka status abhi enter nahi hua, toh hume query mein safe tareeke se likhna padega: `WHERE (order_status <> 'Delivered' OR order_status IS NULL)`."
