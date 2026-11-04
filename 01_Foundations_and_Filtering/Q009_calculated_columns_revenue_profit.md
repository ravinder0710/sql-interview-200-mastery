# Q009: Calculated Columns, Arithmetic Precedence & Integer Division

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 009 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"E-commerce finance reconciliation report mein 'Completed' order line items ka net revenue (discount deduct karke) aur net profit (cost price minus karke) compute karna hai, aur report ko highest profit ke basis par sort karna hai."

---

## 📊 Sample Mock Table (`order_items`)

| item_id | item_name | unit_price | cost_price | quantity | discount_pct | order_status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | Gaming Mouse | 2500.00 | 1400.00 | 2 | 10.00 | Completed |
| 102 | Mechanical Keyboard | 6000.00 | 3800.00 | 1 | 15.00 | Completed |
| 103 | USB-C Cable | 500.00 | 150.00 | 4 | 0.00 | Cancelled |
| 104 | 4K Monitor | 28000.00 | 19000.00 | 1 | 5.00 | Completed |
| 105 | Noise Cancelling Headphones | 12000.00 | 7500.00 | 2 | 20.00 | Completed |

---

## 🎯 Expected Output Table

| item_id | item_name | net_revenue | profit |
| :--- | :--- | :--- | :--- |
| 104 | 4K Monitor | 26600.00 | 7600.00 |
| 105 | Noise Cancelling Headphones | 19200.00 | 4200.00 |
| 101 | Gaming Mouse | 4500.00 | 1700.00 |
| 102 | Mechanical Keyboard | 5100.00 | 1300.00 |

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

## ⚙️ Execution Logic (Saral Bhasha Me)
Maths calculation standard BODMAS follow karti hai: pehle brackets `(1 - discount_pct / 100.0)` calculate hota hai, phir gross revenue se multiply hoke net revenue banta hai, aur aakhir mein cost deduct karke net profit derive hota hai.

---

## ⚠️ Interviewer Trap Question
*"Tumne formula mein `100.0` kyu likha, simple integer `100` kyu nahi likha? Aur kya hum usi SELECT statement ke andar `net_revenue - (cost_price * quantity)` karke seedha `net_revenue` alias reuse kar sakte hain?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, SQL Server aur PostgreSQL jaise databases mein agar hum do integers ko divide karein (jaise `15 / 100`), toh integer division ki wajah se answer 0.15 nahi balki seedha 0 ban jata hai! Isse discount ₹0 ho jayega aur company ka financial figure distort ho jayega. `100.0` likhne se engine floating-point decimal calculation karta hai.*  
> *Doosri baat, SQL engine SELECT projection ke sabhi expressions ko simultaneously evaluate karta hai. Isliye same SELECT clause mein declare kiya gaya column alias doosre column expression mein direct reuse nahi ho sakta. Ya toh hume formula repeat karna padta hai, ya fir clean enterprise code ke liye CTE (`WITH` clause) use karni hoti hai."*
