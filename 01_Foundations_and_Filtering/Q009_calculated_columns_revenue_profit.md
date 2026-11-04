# Q009: Net Revenue & Profit (`Calculated Columns`, Integer Division)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 009 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"E-commerce business mein completed orders par actual paisa kitna aaya (discount ke baad) aur kitna munafa (profit) hua, ye calculate karke do. Sabse zyada profit wale items top par aane chahiye."

---

## 📊 Sample Mock Table (`order_items`)

| item_id | item_name | unit_price | cost_price | quantity | discount_pct | order_status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Gaming Laptop | 80000.00 | 65000.00 | 2 | 10.00 | Completed |
| 2 | Wireless Mouse | 1500.00 | 800.00 | 5 | 0.00 | Completed |
| 3 | Mechanical Keyboard | 4500.00 | 3000.00 | 3 | 15.00 | Cancelled |
| 4 | 27-inch Monitor | 22000.00 | 17000.00 | 1 | 5.00 | Completed |
| 5 | USB-C Hub | 2500.00 | 1200.00 | 4 | 20.00 | Completed |
| 6 | Noise-Canceling Headset | 12000.00 | 9000.00 | 2 | 25.00 | Returned |

---

## 🎯 Expected Output Table

| item_id | item_name | net_revenue | profit |
| :--- | :--- | :--- | :--- |
| 1 | Gaming Laptop | 144000.00 | 14000.00 |
| 4 | 27-inch Monitor | 20900.00 | 3900.00 |
| 2 | Wireless Mouse | 7500.00 | 3500.00 |
| 5 | USB-C Hub | 8000.00 | 3200.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    item_id, 
    item_name, 
    (unit_price * quantity) * (1 - discount_pct / 100.0) AS net_revenue, 
    ((unit_price * quantity) * (1 - discount_pct / 100.0) - (cost_price * quantity)) AS profit 
FROM order_items 
WHERE order_status = 'Completed' 
ORDER BY profit DESC;
```

---

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, hum Completed orders filter karenge. Revenue ke liye `(unit_price * quantity) * (1 - discount_pct / 100.0)` karenge, aur Profit ke liye us Revenue mein se total cost `(cost_price * quantity)` minus karke `ORDER BY profit DESC` kar denge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar discount 10% hai aur tumne `discount / 100` likha (bina `.0` ke), toh kai databases mein kya gadbad ho sakti hai?"*

* **🛡️ Trap ka Counter-Jawab:**
  "Sir, kai databases mein do integer numbers ko divide karne par answer bhi integer ban jata hai. Jaise $10 / 100 = 0.1$ hone ki jagah $0$ ban jayega! Isse discount zero count ho jayega aur company ka revenue galat calculate hoga. Isliye hamesha decimal (`100.0`) se divide karte hain."
