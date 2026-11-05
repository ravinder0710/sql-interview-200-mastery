# Q015: Date Difference & Recency SLA Analysis (`DATEDIFF`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 015 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In an e-commerce logistics fulfillment network, courier partners operate under a strict 5-day Service Level Agreement (SLA). The supply chain analytics team must generate an exceptions report of all fulfilled orders (`shipment_status = 'Delivered'`) where the total delivery turnaround time strictly exceeded 5 calendar days (`delivery_days > 5`). The output prioritizes the most severe delayed shipments for penalty benchmarking and courier contract review.

---

## 📊 Sample Mock Table (`shipment_tracking`)

| shipment_id | tracking_no | courier_partner | shipped_date | delivered_date | shipment_status |
| :---: | :--- | :--- | :---: | :---: | :--- |
| 601 | TRK-9901 | BlueDart | 2023-11-01 | 2023-11-04 | Delivered |
| 602 | TRK-9902 | Delhivery | 2023-11-02 | 2023-11-09 | Delivered |
| 603 | TRK-9903 | Ekart | 2023-11-05 | NULL | In Transit |
| 604 | TRK-9904 | BlueDart | 2023-11-03 | 2023-11-11 | Delivered |
| 605 | TRK-9905 | Delhivery | 2023-11-06 | 2023-11-11 | Delivered |
| 606 | TRK-9906 | Ekart | 2023-11-04 | 2023-11-12 | Delivered |

---

## 🎯 Expected Output

| shipment_id | tracking_no | courier_partner | delivery_days |
| :---: | :--- | :--- | :---: |
| 604 | TRK-9904 | BlueDart | 8 |
| 606 | TRK-9906 | Ekart | 8 |
| 602 | TRK-9902 | Delhivery | 7 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    shipment_id, 
    tracking_no, 
    courier_partner, 
    DATEDIFF(delivered_date, shipped_date) AS delivery_days 
FROM shipment_tracking 
WHERE shipment_status = 'Delivered' 
  AND DATEDIFF(delivered_date, shipped_date) > 5 
ORDER BY 
    delivery_days DESC, 
    shipment_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Cross-Engine `DATEDIFF` Syntax Differences:**
   - **MySQL**: Takes 2 parameters: `DATEDIFF(end_date, start_date)`. Notice that `end_date` comes **first** to produce a positive duration.
   - **SQL Server (T-SQL)**: Takes 3 parameters: `DATEDIFF(interval, start_date, end_date)` (e.g., `DATEDIFF(day, shipped_date, delivered_date)`).
   - **PostgreSQL**: Does not have a built-in `DATEDIFF()` function; you simply subtract dates: `(delivered_date - shipped_date) AS delivery_days`.

2. **Null Safety in Date Arithmetic:**
   - For shipments currently *In Transit*, `delivered_date` is `NULL`.
   - Any arithmetic operation involving `NULL` (`NULL - shipped_date` or `DATEDIFF(NULL, date)`) evaluates to `NULL`.
   - The filter `shipment_status = 'Delivered'` safely prevents active shipments with null delivery timestamps from reaching arithmetic computation.

3. **Strict Inequality vs Grace Period:**
   - The business criteria specifies *"exceeded 5 days"*. Shipment 605 took exactly 5 days (`2023-11-11 - 2023-11-06 = 5`). Using `> 5` correctly excludes on-time deliveries that met the 5-day ceiling.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Inverted Argument Order in MySQL:**
   - *Interviewer:* "What happens in MySQL if you write `DATEDIFF(shipped_date, delivered_date)`?"
   - *Defense:* MySQL calculates `date1 - date2`. Placing `shipped_date` first results in a negative integer (e.g., `-8`), causing the predicate `> 5` to fail completely. In MySQL, the later date (`delivered_date`) must always come first.

2. **Trap: T-SQL Parameter Order:**
   - *Interviewer:* "How does SQL Server's DATEDIFF differ from MySQL?"
   - *Defense:* In SQL Server, the date part interval comes first, followed by `start_date`, then `end_date`: `DATEDIFF(day, shipped_date, delivered_date)`. Inverting them in SQL Server returns a negative number.
