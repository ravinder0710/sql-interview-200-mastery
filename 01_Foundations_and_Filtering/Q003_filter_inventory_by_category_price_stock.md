# Q003: Category List aur Budget Range (`IN`, `BETWEEN`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 003 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"E-commerce website ke homepage par sale chalani hai. Sirf 'Electronics' aur 'Appliances' category ke wo products dikhao jinka price 1,000 se 10,000 ke beech ho aur stock mein kam se kam 1 item bacha ho."

---

## 📊 Sample Mock Table (`products`)

| product_id | product_name | category | price | stock_qty |
| :--- | :--- | :--- | :--- | :--- |
| 501 | Wireless Mouse | Electronics | 1200.00 | 15 |
| 502 | Cotton T-Shirt | Fashion | 899.00 | 40 |
| 503 | Microwave Oven | Appliances | 7500.00 | 8 |
| 504 | Bluetooth Speaker | Electronics | 9999.00 | 0 |
| 505 | Smart Watch | Electronics | 4500.00 | 25 |
| 506 | Mixer Grinder | Appliances | 2800.00 | 12 |
| 507 | Running Shoes | Footwear | 3200.00 | 10 |

---

## 🎯 Expected Output Table

| product_id | product_name | category | price | stock_qty |
| :--- | :--- | :--- | :--- | :--- |
| 501 | Wireless Mouse | Electronics | 1200.00 | 15 |
| 503 | Microwave Oven | Appliances | 7500.00 | 8 |
| 505 | Smart Watch | Electronics | 4500.00 | 25 |
| 506 | Mixer Grinder | Appliances | 2800.00 | 12 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    product_id, 
    product_name, 
    category, 
    price, 
    stock_qty 
FROM products 
WHERE category IN ('Electronics', 'Appliances') 
  AND price BETWEEN 1000 AND 10000 
  AND stock_qty > 0;
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, multiple categories ke liye hum `category IN ('Electronics', 'Appliances')` use karenge, budget ke liye `price BETWEEN 1000 AND 10000`, aur out-of-stock hatane ke liye `stock_qty > 0` lagayenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar kisi item ka price exact 1,000 ya exact 10,000 ho, toh kya `BETWEEN` use chhod dega? Aur `IN` ki jagah multiple `OR` kyu nahi likha?"*

* **🛡️ Trap ka Counter-Jawab:**
  "`BETWEEN` dono border values (1000 aur 10000) ko include karta hai sir, toh wo product zaroor aayega.
  Aur multiple `OR` likhne se code lamba aur confuse karne wala ho jata hai, `IN` lagane se code saaf dikhta hai aur database bhi use fast search kar leta hai."
