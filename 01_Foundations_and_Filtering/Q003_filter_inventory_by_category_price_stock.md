# Q003: Set Membership (`IN`) & Inclusive Range (`BETWEEN`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 003 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Retail e-commerce category managers festive promotion campaign launch kar rahe hain. Unhe 'Electronics' aur 'Appliances' categories ke mid-segment products (MRP between 1,000 and 10,000 inclusive) ki list chahiye jinka warehouse stock available ho (`stock_qty > 0`)."

---

## 📊 Sample Mock Table (`products`)

| product_id | product_name | category | price | stock_qty |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Wireless Earbuds | Electronics | 2499.00 | 45 |
| 2 | Cotton Bedsheet | Home | 899.00 | 120 |
| 3 | Microwave Oven | Appliances | 7500.00 | 12 |
| 4 | Smart Watch | Electronics | 12000.00 | 8 |
| 5 | Electric Kettle | Appliances | 1000.00 | 25 |
| 6 | Running Shoes | Footwear | 3499.00 | 60 |
| 7 | Blender Grinder | Appliances | 4200.00 | 0 |

---

## 🎯 Expected Output Table

| product_id | product_name | category | price | stock_qty |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Wireless Earbuds | Electronics | 2499.00 | 45 |
| 3 | Microwave Oven | Appliances | 7500.00 | 12 |
| 5 | Electric Kettle | Appliances | 1000.00 | 25 |

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

## ⚙️ Execution Logic (Saral Bhasha Me)
Engine `category IN (...)` ke through matching rows check karta hai, `price BETWEEN 1000 AND 10000` inclusive filter lagata hai, aur `stock_qty > 0` se out-of-stock items ko eliminate karta hai.

---

## ⚠️ Interviewer Trap Question
*"Multiple `OR` likhne ke badle `IN` lagane ka database level par kya benefit hai? Aur agar kisi product ka price exact 1,000 ya 10,000 ho toh kya wo `BETWEEN` mein aayega?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, `BETWEEN` ANSI SQL standard mein fully inclusive hota hai (`price >= 1000 AND price <= 10000`). Isliye 1,000 aur 10,000 dono boundaries result mein shamil rahengi.*  
> *Doosri baat, multiple `OR` likhne ke bajaye `IN` operator use karne se SQL Query Optimizer internal **Hash Set Lookup** construct karta hai jo fast execution deta hai. Saath hi yeh ek **SARGable predicate** hai jo price column ke B-Tree Index Range Scan ko preserve rakhta hai."*
