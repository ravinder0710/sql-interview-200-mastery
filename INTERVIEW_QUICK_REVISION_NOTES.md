# 🎯 SQL Interview Master Guide (Top 200)
> **Role:** Data Analyst / SQL Developer (1–2 Years Experience)  
> **Format:** Clean Professional Hinglish — Real Business Scenario, Core Theory, and Exact Interviewer Traps with Verbal IT Delivery Scripts.

---

# 🟢 BLOCK 1: FOUNDATIONS & DATA FILTERING

---

## 📌 Q001: Strict Numeric Boundary (`>` vs `>=`) & Column Projection

### 💡 Production SQL:
```sql
SELECT 
    emp_id, 
    emp_name, 
    department, 
    salary 
FROM employees 
WHERE salary > 60000;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Hamare paas `employees` table hai. Finance team ko annual compensation audit ke liye un sabhi employees ki list chahiye jinki monthly salary 60,000 se upar hai taaki higher tax bracket audit ho sake. Query kaise likhoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `employees` table se strictly required columns (`emp_id`, `emp_name`, `department`, `salary`) select karenge aur `WHERE salary > 60000` lagayenge taaki sirf wahi employees aayein jinki salary 60k threshold se strictly upar hai."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Execution Order:** SQL engine pehle `FROM` evaluate karta hai, fir `WHERE` filter chalata hai, aur sabse aakhri me `SELECT` ke specified columns memory me load karta hai.
* **Covering Index (Index-Only Scan):** Production tables me 40-50 columns hote hain. Explicit columns mangne se database physical data pages padhe bina direct B-Tree index se hi fast data return kar deta hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: `SELECT *` kyu nahi likha?**
  * *Interviewer:* *"Quick report banani hai, toh `SELECT *` kyu nahi use kiya?"*
  * *Aapka Jawab:* *"Sir, enterprise databases me lakho rows par `SELECT *` chalane se excessive disk I/O, network bandwidth waste, aur buffer cache bloat hota hai. Specific columns project karne se database optimizer Index-Only Scan use kar pata hai jo query ko 5-10 guna fast chalata hai."*
* **Trap 2: Boundary value (60,000) inclusion trap:**
  * *Interviewer:* *"Agar kisi employee ki salary exact 60,000 hui, toh kya wo output me aayegi?"*
  * *Aapka Jawab:* *"Nahi sir, question me 'strictly greater than 60,000' bola gaya tha, isliye humne `>` lagaya hai `>=` nahi. Exact 60,000 boundary match filter out ho jayegi, jisse audit report accurate rahegi."*

---

## 📌 Q002: String Inequality (`<>`) & The NULL Trap

### 💡 Production SQL:
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

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"E-commerce operations me hume un prepaid (Online) orders ko track karna hai jo abhi customer tak deliver nahi hue hain (Pending, Shipped, Processing, etc.) taaki support team delayed orders ko expedite kar sake. Query kaise design karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `payment_type = 'Online'` ke saath inequality filter `order_status <> 'Delivered'` use karenge taaki Delivered orders exclude ho jayein aur baki sabhi active states capture ho sakein."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Three-Valued Logic (3VL):** SQL me teen boolean states hote hain: `TRUE`, `FALSE`, aur `UNKNOWN`.
* Jab kisi `NULL` value ko compare kiya jata hai (`NULL <> 'Delivered'`), toh answer `UNKNOWN` aata hai. Kyunki `WHERE` sirf strictly `TRUE` rows allow karta hai, isliye NULL status wale orders drop ho jate hain.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: The Silent NULL Drop:**
  * *Interviewer:* *"Maan lo naye order ka status ingestion pipeline delay ki wajah se `NULL` reh gaya, kya wo report me dikhega?"*
  * *Aapka Jawab:* *"Nahi sir, 3VL logic ki wajah se NULL rows silently drop ho jayengi. Agar unassigned status wale orders bhi include karne hon, toh defensive production code me `WHERE (order_status <> 'Delivered' OR order_status IS NULL)` likhna standard practice hai."*
* **Trap 2: `!=` vs `<>` standard:**
  * *Interviewer:* *"Kya `!=` aur `<>` me koi difference hai?"*
  * *Aapka Jawab:* *"Dono kaam same karte hain, par `<>` official ANSI SQL standard operator hai jo sabhi databases (Oracle, PostgreSQL, SQL Server, MySQL) me 100% portable hota hai."*

---

## 📌 Q003: Set Membership (`IN`) & Range (`BETWEEN`)

### 💡 Production SQL:
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

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Festive campaign ke liye category managers ko mid-budget products (₹1,000 se ₹10,000) chahiye jo 'Electronics' ya 'Appliances' category me aate hon aur jinka warehouse me stock available ho. Kaise filter karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `category IN ('Electronics', 'Appliances')` ke saath `price BETWEEN 1000 AND 10000` aur `stock_qty > 0` lagayenge taaki accurate campaign inventory filter ho jaye."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* `IN (...)` multiple `OR` conditions ka clean aur fast alternative hai. Optimizer iska in-memory hash set banata hai.
* `BETWEEN low AND high` hamesha **inclusive** hota hai ($\text{price} \ge 1000 \text{ AND } \text{price} \le 10000$).
* Dono **SARGable** predicates hain jo B-Tree index range scans ko support karte hain.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Boundaries include hongi ya nahi?**
  * *Interviewer:* *"Kya 1,000 aur 10,000 ka item report me aayega?"*
  * *Aapka Jawab:* *"Haan sir, `BETWEEN` dono lower aur upper bounds ko include karta hai. Agar boundary hatani hoti toh hum strictly `price > 1000 AND price < 10000` likhte."*
* **Trap 2: SARGability break hona:**
  * *Interviewer:* *"Agar main `WHERE CAST(price AS INT) BETWEEN 1000 AND 10000` likh doon toh kya issue hai?"*
  * *Aapka Jawab:* *"Sir, column par function wrap karne se predicate non-SARGable ho jata hai. Database B-Tree index use nahi kar pata aur poori table ka Full Scan karna padta hai jo query ko slow kar deta hai."*

---

## 📌 Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`)

### 💡 Production SQL:
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

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Marketing automation team ko promotional blast bhejna hai valid Gmail users ko jinka naam 'A' se start hota ho, par QA aur test accounts (`%test%`) drop karne hain taaki email credits waste na hon."*
* **Aapka Professional Jawab:**
  > *"Sir, hum `customer_name LIKE 'A%'` se initial anchor match karenge, `email LIKE '%@gmail.com'` se domain check karenge, aur `email NOT LIKE '%test%'` se dummy QA accounts eliminate kar denge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* `%` 0 ya multiple characters match karta hai.
* `_` exact single character placeholder hota hai.
* Trailing wildcard (`'A%'`) index seek karta hai, jabki leading wildcard (`'%@gmail.com'`) index bypass kar deta hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Leading wildcard performance:**
  * *Interviewer:* *"1 crore rows par `LIKE '%@gmail.com'` slow kyu chalega?"*
  * *Aapka Jawab:* *"Kyunki string ka starting character unknown hai, isliye B-Tree index seek nahi ho pata aur database ko Full Table Scan karna padta hai. Production me aise searches ke liye Trigram Index (`pg_trgm`) ya Reverse Index lagaya jata hai."*
* **Trap 2: Case sensitivity:**
  * *Interviewer:* *"PostgreSQL me `LIKE` case-insensitive hota hai kya?"*
  * *Aapka Jawab:* *"Nahi sir, PostgreSQL me `LIKE` case-sensitive hota hai. Case-insensitive matching ke liye hum `ILIKE` use karte hain."*

---

## 📌 Q005: Missing Data (`IS NULL`) & Operator Precedence

### 💡 Production SQL:
```sql
SELECT 
    rep_id, 
    rep_name, 
    salary, 
    commission_pct, 
    manager_id 
FROM sales_reps 
WHERE salary >= 50000 
  AND is_active = TRUE 
  AND (commission_pct IS NULL OR manager_id IS NULL);
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Sales audit me un active high-earning reps (salary >= 50k) ko nikalna hai jinka ya toh commission set nahi hua hai ya jinko koi manager assign nahi hai."*
* **Aapka Professional Jawab:**
  > *"Sir, hum base filters (`salary >= 50000 AND is_active = TRUE`) ke saath compound condition `(commission_pct IS NULL OR manager_id IS NULL)` ko parentheses me wrap karke execute karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* Logical precedence hierarchy: $\mathbf{NOT} \longrightarrow \mathbf{AND} \longrightarrow \mathbf{OR}$.
* `AND` operator `OR` se pehle bind hota hai. Parentheses lagana mandatory hota hai compound logic isolate karne ke liye.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Brackets hata dene ka nateeja:**
  * *Interviewer:* *"Agar brackets hata diye jayein toh kya impact aayega?"*
  * *Aapka Jawab:* *"Sir, query ka logic break ho jayega! Query ban jayegi `(Salary >= 50k AND Active AND Comm IS NULL) OR (manager_id IS NULL)`. Nateeja yeh hoga ki har wo employee jiska manager NULL hai output me aa jayega—chahe wo inactive ho ya salary 10,000 ho!"*
* **Trap 2: `= NULL` likhna:**
  * *Interviewer:* *"Kya `WHERE commission_pct = NULL` likh sakte hain?"*
  * *Aapka Jawab:* *"Nahi sir, SQL me NULL unknown hota hai, isliye `col = NULL` hamesha UNKNOWN evaluate hota hai aur 0 rows deta hai. Strictly `IS NULL` use hota hai."*

---

## 📌 Q006: Multi-Column Priority Sorting (`ORDER BY`)

### 💡 Production SQL:
```sql
SELECT 
    appointment_id, 
    patient_name, 
    doctor_id, 
    priority_score, 
    appointment_time 
FROM patient_appointments 
WHERE status = 'Waiting' 
ORDER BY 
    doctor_id ASC, 
    priority_score DESC, 
    appointment_time ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Hospital OPD queue me patients ko triage karna hai: pehle Doctor ke hisab se group ho, fir sabse critical patient (priority score high) pehle aaye, aur tie hone par arrival time se resolve ho."*
* **Aapka Professional Jawab:**
  > *"Sir, hum multi-column `ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC` use karenge jisse doctor line-up ke andar clinical priority aur arrival tie-breaking follow ho."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* Multi-column sorting hierarchical hoti hai. Agle columns sirf tabhi evaluate hote hain jab pehle wale columns ki values identical (tie) hon.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Positional references (`ORDER BY 3, 4 DESC, 5`):**
  * *Interviewer:* *"Short me column number likhna safe hai kya?"*
  * *Aapka Jawab:* *"Nahi sir, production me positional references strict anti-pattern hain. Agar SELECT me column sequence change ho gaya, toh poori sorting galat business metrics par shift ho jayegi."*
* **Trap 2: NULL sorting cross-database difference:**
  * *Interviewer:* *"ASC sorting me NULL values upar aati hain ya niche?"*
  * *Aapka Jawab:* *"MySQL aur SQL Server me ASC order me NULL values top par (`NULLS FIRST`) aati hain, jabki PostgreSQL me NULL last me (`NULLS LAST`) aati hain. Standard consistency ke liye explicit `NULLS LAST` specify karna chahiye."*

---

## 📌 Q007: Top-N Truncation (`LIMIT` / `TOP`) & Dialects

### 💡 Production SQL:
```sql
SELECT 
    song_id, 
    title, 
    artist, 
    total_streams 
FROM songs 
WHERE release_year >= 2023 
ORDER BY total_streams DESC 
LIMIT 3;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Music app ke homepage banner par 2023 ke baad ke Top 3 most-streamed tracks feature karne hain."*
* **Aapka Professional Jawab:**
  > *"Sir, hum `release_year >= 2023` filter karke `ORDER BY total_streams DESC LIMIT 3` lagayenge taaki highest streamed top 3 songs return ho sakein."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* Top-N heapsort optimization: Bounded priority queue use karke engine without full dataset sort fast result deta hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Ties par data drop hona:**
  * *Interviewer:* *"Agar 3rd aur 4th song ke streams exact barabar hue toh `LIMIT 3` kya karega?"*
  * *Aapka Jawab:* *"Sir, `LIMIT 3` arbitrarily kisi ek gaane ko truncate kar dega. Agar business ko tied ranks bhi show karne hain, toh standard SQL me window ranking function `DENSE_RANK()` use karte hain, aur SQL Server me `TOP 3 WITH TIES`."*
* **Trap 2: Dialect differences:**
  * *Interviewer:* *"SQL Server aur Oracle me LIMIT kaise chalta hai?"*
  * *Aapka Jawab:* *"SQL Server me `SELECT TOP 3 ...` use hota hai, jabki Oracle aur ANSI standard me `OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY` likha jata hai."*

---

## 📌 Q008: Nth Highest Value (`LIMIT 1 OFFSET N-1` + `DISTINCT`)

### 💡 Production SQL:
```sql
SELECT DISTINCT price AS second_highest_price 
FROM properties 
WHERE city = 'Bangalore' 
ORDER BY price DESC 
LIMIT 1 OFFSET 1;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Real estate portal par Bangalore city ke properties me luxury outlier ko filter karke second highest price find karna hai pricing benchmark set karne ke liye."*
* **Aapka Professional Jawab:**
  > *"Sir, hum unique prices ko `DISTINCT` karke descending order me sort karenge aur Nth value formula `LIMIT 1 OFFSET (N-1)` use karenge: 2nd highest ke liye `LIMIT 1 OFFSET 1`."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* Mathematical pagination rule: $\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$.
* Deduplication via `DISTINCT` zaroori hai taaki tied maximum prices 2nd rank occupy na karein.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: `DISTINCT` na lagane ka risk:**
  * *Interviewer:* *"Agar do top properties ka price same ho aur DISTINCT na lagayein toh?"*
  * *Aapka Jawab:* *"Sir, `OFFSET 1` skip karne par wapas wahi highest duplicate price aa jayega. Isliye true distinct second-tier value ke liye `DISTINCT` compulsory hai."*
* **Trap 2: Empty set vs NULL (LeetCode 176):**
  * *Interviewer:* *"Agar table me sirf 1 hi property ho toh query kya degi?"*
  * *Aapka Jawab:* *"Direct query 0 rows (empty set) degi. Par standard requirement me single row `NULL` chahiye hoti hai, jiske liye query ko outer scalar SELECT me wrap karte hain: `SELECT (SELECT DISTINCT price ... LIMIT 1 OFFSET 1) AS second_highest`."*

---

## 📌 Q009: Calculated Columns & Integer Division Prevention

### 💡 Production SQL:
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

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Finance reconciliation me har completed order line item ka discount deduct karke Net Revenue aur Cost of Goods Sold minus karke Net Profit calculate karna hai."*
* **Aapka Professional Jawab:**
  > *"Sir, hum decimal literal `100.0` use karke discount factor `(1 - discount_pct / 100.0)` nikalenge, gross sales se multiply karenge net revenue ke liye, aur total cost minus karke profit derive karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* Integer division hazard: SQL Server aur PostgreSQL me `15 / 100 = 0` ho jata hai. `100.0` decimal calculation enforce karta hai.
* Column aliases projection pass me simultaneously evaluate hote hain, isliye usi SELECT me alias reuse nahi ho sakta.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: `/ 100` vs `/ 100.0`:**
  * *Interviewer:* *"Agar simple integer 100 se divide karein toh kya hoga?"*
  * *Aapka Jawab:* *"Integer division truncation ki wajah se answer 0 ho jayega aur discount ₹0 calculate hoga, jisse revenue galat aur inflated ho jayega. `100.0` likhne se precision preserve rehti hai."*
* **Trap 2: SELECT alias reuse:**
  * *Interviewer:* *"Kya hum usi SELECT me `profit = net_revenue - cost` likh sakte hain?"*
  * *Aapka Jawab:* *"Nahi sir, SQL expressions parallel me evaluate hote hain isliye alias scope available nahi hota. Clean architecture ke liye CTE use ki jaati hai."*

---

## 📌 Q010: Scalar Math Functions (`ROUND`, `CEIL`) & CTE Decomposition

### 💡 Production SQL:
```sql
WITH loan_calc AS (
    SELECT 
        loan_id, 
        borrower_name, 
        tenure_months,
        ROUND(principal_amount * (annual_rate / (12.0 * 100.0)) * tenure_months, 2) AS total_interest,
        principal_amount
    FROM loan_applications 
    WHERE loan_status = 'Approved'
)
SELECT 
    loan_id, 
    borrower_name, 
    total_interest, 
    (principal_amount + total_interest) AS total_repayment, 
    CEIL((principal_amount + total_interest) / tenure_months) AS monthly_emi 
FROM loan_calc 
ORDER BY monthly_emi DESC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Lending portal me approved micro-loans ka interest, total repayment obligation, aur monthly installment (EMI) schedule generate karna hai without any penny-loss."*
* **Aapka Professional Jawab:**
  > *"Sir, hum CTE ke andar interest calculate karenge, aur outer query me total repayment nikal kar monthly EMI par `CEIL()` lagayenge taaki fractional shortfall avoid ho sake."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* `CEIL(val)` hamesha next higher integer par round-up karta hai.
* CTE (`WITH` clause) complex multi-step arithmetic ko clean modular architecture me separate karta hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Financial rounding me `ROUND()` vs `CEIL()`:**
  * *Interviewer:* *"EMI par ROUND lagane ke bajaye CEIL kyu lagaya?"*
  * *Aapka Jawab:* *"Sir, financial systems me agar EMI decimal me aaye aur round-down ho jaye, toh loan tenure ke end par bank ko kuch paison ya rupaye ka shortfall ho jata hai. `CEIL()` round-up karke guarantee karta hai ki complete recovery ho."*
* **Trap 2: CTE performance overhead:**
  * *Interviewer:* *"Kya CTE use karne se query execution slow hoti hai?"*
  * *Aapka Jawab:* *"Nahi sir, modern database optimizers non-recursive CTEs ko internally inline kar dete hain. Zero overhead ke saath hume modular aur readable code milta hai."*

---
*(Curriculum continues with Q011 to Q015...)*
