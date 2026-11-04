# Q002: String Inequality (`<>` / `!=`) & The Famous NULL Trap

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 002 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"E-commerce logistics operations mein hume un sabhi prepaid (Online) orders ko track karna hai jo abhi tak customer tak deliver nahi hue hain (jaise Pending, Shipped, Processing, etc.) taaki dispatch team delayed orders par proactive action le sake."

---

## 📊 Sample Mock Table (`orders`)

| order_id | customer_name | order_status | payment_type | order_amount |
| :--- | :--- | :--- | :--- | :--- |
| 501 | Rahul Sen | Delivered | Online | 1499.00 |
| 502 | Kavita Rao | Shipped | Online | 2999.00 |
| 503 | Anuj Jain | Pending | Cash | 850.00 |
| 504 | Manisha Roy | Delivered | Cash | 1200.00 |
| 505 | Deepak Varma | Processing | Online | 4500.00 |
| 506 | Sonal Gill | Cancelled | Online | 999.00 |

---

## 🎯 Expected Output Table

| order_id | customer_name | order_status | order_amount |
| :--- | :--- | :--- | :--- |
| 502 | Kavita Rao | Shipped | 2999.00 |
| 505 | Deepak Varma | Processing | 4500.00 |
| 506 | Sonal Gill | Cancelled | 999.00 |

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

## ⚙️ Execution Logic (Saral Bhasha Me)
Query pehle `orders` table scan karti hai, `payment_type = 'Online'` check karti hai, aur `order_status <> 'Delivered'` ke through un records ko pass karti hai jinka status 'Delivered' nahi hai.

---

## ⚠️ Interviewer Trap Question
*"Maan lo ek naya order place hua jiska status system glitch ki wajah se abhi `NULL` reh gaya. Kya tumhari query us online order ko return karegi?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Nahi sir, SQL mein **Three-Valued Logic (3VL)** hoti hai—TRUE, FALSE, aur UNKNOWN. Jab hum kisi NULL value ko kisi string se compare karte hain (`NULL <> 'Delivered'`), toh uska result `UNKNOWN` aata hai.*  
> *Kyunki `WHERE` clause sirf strictly `TRUE` rows ko aage filter karti hai, isliye NULL status wale orders silently drop ho jayenge. Production mein agar unassigned ya NULL status orders ko bhi lena ho, toh safe practice yeh hoti hai ki hum explicit `WHERE (order_status <> 'Delivered' OR order_status IS NULL)` likhein."*
