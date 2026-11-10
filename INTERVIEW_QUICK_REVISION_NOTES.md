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

## 📌 Q011: String Manipulation & Length Filtering (`CONCAT`, `UPPER`, `CHAR_LENGTH`)

### 💡 Production SQL:
```sql
SELECT 
    emp_id, 
    UPPER(CONCAT(first_name, ' ', last_name)) AS full_name_upper, 
    LOWER(CONCAT(first_name, '.', last_name, '@company.com')) AS work_email, 
    CHAR_LENGTH(CONCAT(first_name, ' ', last_name)) AS name_length 
FROM employee_onboarding 
WHERE employment_type = 'Permanent' 
  AND CHAR_LENGTH(CONCAT(first_name, ' ', last_name)) >= 10 
ORDER BY name_length DESC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"HR on-boarding table me first_name aur last_name alag-alag aate hain. IT badge printing aur corporate email setup ke liye ek report banani hai: formal full name capital me ho, official email lowercase me ho, aur sirf un Permanent employees ko filter karna hai jinke naam ki length 10 ya usse zyada characters ho taaki badge margin test ho sake. Query kaise likhoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `CONCAT()` function use karke first aur last name ko space ke saath merge karenge, uppercase ke liye `UPPER()` aur lowercase email ke liye `LOWER()` lagayenge. Badge margin check ke liye `CHAR_LENGTH(...) >= 10` filter karenge aur highest length ke according descending order me sort kar denge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **`CHAR_LENGTH()` vs `LENGTH()`:** `LENGTH()` storage bytes count karta hai, jabki `CHAR_LENGTH()` exact visual characters count karta hai. Multi-byte UTF-8 strings me `CHAR_LENGTH()` hamesha accurate character count deta hai.
* **SQL Order of Operations:** `WHERE` clause `SELECT` projection se pehle chalta hai. Isliye `WHERE` clause me alias `name_length` direct use nahi ho sakta, wahan pura function expression evaluate karna padta hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: NULL concatenation trap:**
  * *Interviewer:* *"Agar kisi employee ka last_name NULL ho, toh concatenation par kya asar padega?"*
  * *Aapka Jawab:* *"Sir, standard SQL pipe operator `||` ya `+` me agar koi ek value bhi NULL ho toh pura result NULL ban jata hai. Modern `CONCAT()` function NULL ko automatically empty string treat karta hai jisse data corrupt nahi hota. Safe side ke liye hum `COALESCE(last_name, '')` bhi use kar sakte hain."*
* **Trap 2: WHERE clause me alias use karna:**
  * *Interviewer:* *"WHERE condition me direct `WHERE name_length >= 10` kyu nahi likha?"*
  * *Aapka Jawab:* *"Sir, SQL execution architecture me `WHERE` phase `SELECT` se pehle run hota hai. Is point par column alias create hi nahi hua hota, isliye alias likhne par 'Unknown Column' error aayega. Expression ko WHERE me repeat karna padta hai ya CTE use karni hoti hai."*

---

## 📌 Q012: String Parsing & Data Masking (`SUBSTRING`, `LEFT`, `RIGHT`)

### 💡 Production SQL:
```sql
SELECT 
    ticket_id, 
    customer_name, 
    CONCAT('XXXXXX', RIGHT(phone_number, 4)) AS masked_phone, 
    LEFT(issue_code, 4) AS category_code, 
    SUBSTRING(issue_code, 6, 4) AS issue_year 
FROM customer_tickets 
WHERE priority = 'High' 
ORDER BY ticket_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Customer support dashboard par PII compliance follow karni hai. Phone number ke sirf aakhri 4 digits show karne hain aage 'XXXXXX' mask karke. Saath hi alphanumeric code `BILL-2023-NET` se category code aur incident year parse karke report ready karni hai High priority tickets ke liye. Query kaise likhoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum phone number ke last 4 digits `RIGHT(phone_number, 4)` se nikal kar `CONCAT('XXXXXX', ...)` karenge. Category ke liye `LEFT(issue_code, 4)` use karenge, aur year ke liye SQL ke 1-based indexing rule ke hisab se `SUBSTRING(issue_code, 6, 4)` lagakar filter aur sort kar denge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **1-Based Indexing:** Python ya Java me indexing 0 se start hoti hai, par SQL me hamesha **1-based indexing** hoti hai. `BILL-2023-NET` me position 5 par hyphen `-` hai, aur position 6 se `2023` shuru hota hai.
* **`LEFT()` & `RIGHT()`:** `LEFT(col, n)` shuru ke $n$ characters uthata hai, aur `RIGHT(col, n)` hamesha end ke $n$ characters extract karta hai chahe string kitni bhi lambi ho.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: 0-based indexing slip:**
  * *Interviewer:* *"Agar main `SUBSTRING(issue_code, 5, 4)` likh doon toh kya aayega?"*
  * *Aapka Jawab:* *"Sir, SQL me indexing 1 se hoti hai, isliye 5th character hyphen `-` hai. Output me `-202` aa jayega jo galat year hai. Sahi position 6 hai."*
* **Trap 2: Variable length delimiter parsing:**
  * *Interviewer:* *"Agar category prefix variable length ho (jaise `ACCOUNTING-2023` vs `IT-2024`), toh fixed position 6 fail ho jayegi. Wahan kya use karoge?"*
  * *Aapka Jawab:* *"Sir, dynamic delimiters ke liye hum `INSTR()` ya `CHARINDEX()` / `POSITION()` se hyphen ka index dhoondhte hain aur `SUBSTRING()` ke saath combine karte hain, ya fir `REGEXP_SUBSTR()` use karte hain."*

---

## 📌 Q013: String Cleansing & Normalization (`REPLACE`, `TRIM`, `UPPER`)

### 💡 Production SQL:
```sql
SELECT 
    address_id, 
    customer_name, 
    TRIM(raw_address) AS cleaned_address, 
    REPLACE(UPPER(city_code), 'BLR', 'Bangalore') AS standard_city, 
    pin_code 
FROM customer_addresses 
WHERE pin_code LIKE '56%' 
ORDER BY address_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Courier delivery system me customer address ke aage-piche extra spaces hain jisse label printing distort hoti hai. Saath hi city abbreviations (jaise `BLR`) ko official full name `Bangalore` banana hai un PIN codes ke liye jo `56%` se shuru hote hain. Clean SQL solution kaise design karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `TRIM(raw_address)` se leading aur trailing spaces remove karenge. City abbreviation ko normalize karne ke liye `REPLACE(UPPER(city_code), 'BLR', 'Bangalore')` lagayenge taaki case-sensitivity ki wajah se match miss na ho, aur Bangalore PIN codes ke liye `WHERE pin_code LIKE '56%'` filter karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **`TRIM()` Scope:** `TRIM()` sirf string ke shuru aur aakhir ke spaces hatata hai. Words ke beech ke spaces ko touch nahi karta.
* **`REPLACE()` Case Sensitivity:** PostgreSQL aur Oracle me `REPLACE()` case-sensitive hota hai. Agar table me `BLR` hai aur function me `blr` likha, toh replace silently fail ho jayega. `UPPER()` wrap karna enterprise standard defensive coding hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Case-sensitivity in `REPLACE`:**
  * *Interviewer:* *"PostgreSQL me `REPLACE(city_code, 'blr', 'Bangalore')` chalane par agar data 'BLR' ho toh kya hoga?"*
  * *Aapka Jawab:* *"Sir, PostgreSQL me REPLACE strictly case-sensitive hota hai, isliye 'BLR' match nahi hoga aur string unreplaced reh jayegi. Cross-engine safe code ke liye hum `REPLACE(UPPER(city_code), 'BLR', 'Bangalore')` likhte hain."*
* **Trap 2: Internal spaces cleaning:**
  * *Interviewer:* *"Agar do words ke beech 4 extra spaces hon (`12th    Main`), kya `TRIM()` use remove karega?"*
  * *Aapka Jawab:* *"Nahi sir, `TRIM()` sirf outer boundary spaces hatata hai. Internal extra spaces ko collapse karne ke liye regex function `REGEXP_REPLACE(col, '\s+', ' ')` use kiya jata hai."*

---

## 📌 Q014: Date Part Extraction & Temporal Filtering (`YEAR`, `MONTH`, `EXTRACT`)

### 💡 Production SQL:
```sql
SELECT 
    order_id, 
    customer_name, 
    YEAR(order_date) AS order_year, 
    MONTH(order_date) AS order_month, 
    DAY(order_date) AS order_day, 
    order_amount 
FROM customer_orders 
WHERE payment_status = 'Paid' 
  AND YEAR(order_date) = 2023 
  AND MONTH(order_date) = 10 
ORDER BY 
    order_amount DESC, 
    order_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Retail finance audit team ko October 2023 Diwali campaign ke sabhi successful paid orders ki report chahiye jisme date se year, month aur day alag karke analysis ho sake aur sales amount ke hisab se sort ho. Kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `YEAR()`, `MONTH()`, aur `DAY()` functions use karke date breakdown karenge, `WHERE payment_status = 'Paid' AND YEAR(order_date) = 2023 AND MONTH(order_date) = 10` filter lagayenge, aur `order_amount DESC, order_id ASC` se multi-column tie-breaking sort karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **SARGable vs Non-SARGable:** Column ko `WHERE YEAR(order_date) = 2023` me wrap karne se column non-SARGable ho jata hai aur database index bypass karke Full Table Scan karta hai.
* **Production Index Optimization:** Index preservation ke liye production me range filter use karte hain:  
  `WHERE order_date >= '2023-10-01' AND order_date < '2023-11-01'`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Non-SARGable function call trap:**
  * *Interviewer:* *"Agar 50 million rows par `order_date` par B-Tree index laga hai, toh `YEAR(order_date) = 2023` query slow kyu karega?"*
  * *Aapka Jawab:* *"Sir, function wrap karne ki wajah se database optimizer index seek use nahi kar pata aur engine ko har row par function chala kar Full Table Scan karna padta hai. SARGable range `order_date >= '2023-10-01' AND order_date < '2023-11-01'` likhne se query index seek ke saath milliseconds me run hoti hai."*
* **Trap 2: Datetime boundary issue in `BETWEEN`:**
  * *Interviewer:* *"Agar column me time bhi store ho (e.g., `2023-10-31 22:30:00`), toh `BETWEEN '2023-10-01' AND '2023-10-31'` safe hai kya?"*
  * *Aapka Jawab:* *"Nahi sir, `'2023-10-31'` midnight `00:00:00` evaluate hota hai, isliye 31 October ke din ke baki saare orders drop ho jayenge. Safe pattern hamesha half-open interval hota hai: `>= '2023-10-01' AND < '2023-11-01'`."*

---

## 📌 Q015: Date Difference & Recency SLA Analysis (`DATEDIFF`)

### 💡 Production SQL:
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

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Courier fulfillment team ka delivery SLA 5 days ka hai. Unhe un sabhi Delivered orders ki report chahiye jinme SLA breach hua ho yaani delivery_days > 5, aur sabse zyada delayed orders pehle aayein. Kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `DATEDIFF(delivered_date, shipped_date)` se delivery turnaround days nikalenge, `WHERE shipment_status = 'Delivered' AND DATEDIFF(...) > 5` filter lagayenge taaki pending shipments exclude rahein aur strictly 5 din se zyada wale breach cases identify ho sakein."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Cross-Dialect Differences:**
  * **MySQL:** `DATEDIFF(end_date, start_date)` $\rightarrow$ Later date pehle aati hai.
  * **SQL Server (T-SQL):** `DATEDIFF(day, start_date, end_date)` $\rightarrow$ Datepart interval aage hota hai aur start date pehle hoti hai.
  * **PostgreSQL:** Direct date subtraction `(delivered_date - shipped_date)` integers days deta hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: MySQL me parameters ulte likh dena:**
  * *Interviewer:* *"MySQL me agar `DATEDIFF(shipped_date, delivered_date)` likh diya toh kya hoga?"*
  * *Aapka Jawab:* *"Sir, MySQL date1 - date2 karta hai, isliye shipped date pehle likhne par negative number (e.g. -8) aa jayega aur `> 5` condition fail ho kar 0 rows degi. MySQL me end_date pehle aana mandatory hai."*
* **Trap 2: In-transit orders par NULL calculation:**
  * *Interviewer:* *"Jo orders abhi raaste me hain ('In Transit'), unka delivered_date NULL hai. Agar status filter na lagayein toh kya dikkat hogi?"*
  * *Aapka Jawab:* *"Sir, NULL ke saath date difference evaluate karne par result NULL aata hai aur WHERE clause use drop kar deta hai, lekin report clarification ke liye explicit `shipment_status = 'Delivered'` lagana zaroori hai taaki in-progress shipments audit analysis me confuse na karein."*

---

# 🟢 BLOCK 2: STRING & DATE CLEANING (Q016 — Q035)

---

## 📌 Q016: Cleaning Inconsistent Phone Prefixes (`RIGHT`, `REPLACE`, `LENGTH`)

### 💡 Production SQL:
```sql
SELECT 
    user_id, 
    full_name, 
    RIGHT(REPLACE(raw_phone, '-', ''), 10) AS clean_phone, 
    account_status 
FROM user_profiles 
WHERE account_status = 'Active' 
  AND LENGTH(RIGHT(REPLACE(raw_phone, '-', ''), 10)) = 10 
ORDER BY user_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"FinTech app signup table me users alag-alag format me phone number daal dete hain (+91, trunk zero 0, hyphens). SMS OTP gateway ke liye clean 10-digit number extract karna hai un Active accounts ke liye jinka number 10 digits ka ho. Kaise sanitize karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `REPLACE(raw_phone, '-', '')` se pehle hyphens ko completely strip karenge. Uske baad `RIGHT(..., 10)` se last 10 digits extract karenge aur `WHERE account_status = 'Active' AND LENGTH(...) = 10` se filter karenge taaki corrupted short numbers drop ho sakein."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Empty String `''` vs Space `' '`:** Hyphen ko space `' '` se replace karne par string ke beech me whitespace reh jata hai jisse 10-digit extraction corrupt ho jati hai. Empty string `''` digits ko seamlessly combine karta hai.
* **`RIGHT()` Behavior on Short Strings:** Agar string 10 characters se chhoti ho (e.g. `'945612'`), toh `RIGHT(col, 10)` poori string return kar deta hai (error throw nahi karta). Isliye `LENGTH(...) = 10` lagana zaroori hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Short invalid numbers handle karna:**
  * *Interviewer:* *"Agar user ne 6-digit number dala ho, toh RIGHT(col, 10) kya dega?"*
  * *Aapka Jawab:* *"Sir, SQL me RIGHT function error throw nahi karta, balki poori 6-digit string hi return kar deta hai. Isliye validation filter `LENGTH(RIGHT(...)) = 10` lagana mandatory hota hai taaki truncated numbers reject ho jayein."*
* **Trap 2: International country codes:**
  * *Interviewer:* *"Kya RIGHT(..., 10) UK ya Europe ke numbers par chalega?"*
  * *Aapka Jawab:* *"Nahi sir, yeh logic India ya US jaise 10-digit national dialing plan ke liye optimized hai. Global multi-country platforms par country code alag column me store karte hain aur E.164 standardization ke liye regex patterns use karte hain."*

---

## 📌 Q017: Dynamic String Delimiter Splitting (`INSTR`, `SUBSTRING`, `LEFT`)

### 💡 Production SQL:
```sql
SELECT 
    subscriber_id, 
    full_name, 
    LEFT(email_address, INSTR(email_address, '@') - 1) AS username, 
    SUBSTRING(email_address, INSTR(email_address, '@') + 1) AS domain_name 
FROM subscribers 
WHERE is_verified = TRUE 
ORDER BY subscriber_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Marketing subscribers table me alag-alag length ke emails hain. Growth team ko domain distribution analyze karna hai. '@' delimiter locate karke username aur domain_name dynamically alag-alag columns me kaise extract karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, variable length strings ke liye hum `INSTR(email_address, '@')` se '@' ka dynamic 1-based index nikalenge. Username ke liye `LEFT(..., INSTR(...) - 1)` aur domain name ke liye `SUBSTRING(..., INSTR(...) + 1)` use karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Dynamic Offsets:** Static hardcoding fail ho jati hai variable emails me. `INSTR()` runtime par token position dhoondhta hai.
* **Dialect Variations:** MySQL me `INSTR(str, substr)`, SQL Server me `CHARINDEX('@', str)`, aur PostgreSQL me `POSITION('@' IN str)`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Missing '@' delimiter handling:**
  * *Interviewer:* *"Agar dirty data me email me '@' na ho, toh INSTR kya dega aur query par kya asar padega?"*
  * *Aapka Jawab:* *"Sir, delimiter na milne par INSTR() 0 return karta hai. Is case me `0 - 1 = -1` ban jayega jo runtime error ya empty string de sakta hai. Production me hum defensive filter `WHERE email_address LIKE '%@%'` add karte hain."*
* **Trap 2: Substring without length parameter:**
  * *Interviewer:* *"SUBSTRING me 3rd argument (length) pass kyu nahi kiya?"*
  * *Aapka Jawab:* *"MySQL aur PostgreSQL me `SUBSTRING(str, start_pos)` bina length parameter ke us position se lekar end of string tak poora data slice kar leta hai, jo domain extraction ke liye perfect hai."*

---

## 📌 Q018: String to Date Conversion & Formatting (`STR_TO_DATE`, `DATE_FORMAT`)

### 💡 Production SQL:
```sql
SELECT 
    txn_id, 
    customer_name, 
    STR_TO_DATE(raw_txn_date, '%d/%m/%Y') AS standard_date, 
    amount, 
    txn_status 
FROM legacy_transactions 
WHERE txn_status = 'Success' 
  AND STR_TO_DATE(raw_txn_date, '%d/%m/%Y') BETWEEN '2023-10-01' AND '2023-12-31' 
ORDER BY 
    standard_date DESC, 
    txn_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Legacy banking CSV feed se dates string text format 'DD/MM/YYYY' me aati hain. Agar direct text filter ya sort karein toh galat results aate hain. Audit ke liye Q4 2023 ke successful transactions extract karne hain. Date casting aur filtering kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, string text dates alphabetical order me sort hoti hain, chronological order me nahi. Hum `STR_TO_DATE(raw_txn_date, '%d/%m/%Y')` use karke use true SQL Date data type me cast karenge aur `BETWEEN '2023-10-01' AND '2023-12-31'` se Q4 quarter filter karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Lexicographical vs Chronological:** String format `'28/09/2023'` ASCII value me `'15/10/2023'` se badi hoti hai kyunki `'2'` > `'1'`. Date conversion zaroori hai taaki calendar order follow ho.
* **Dialect Differences:** MySQL me `STR_TO_DATE(str, '%d/%m/%Y')`, PostgreSQL me `TO_DATE(str, 'DD/MM/YYYY')`, aur SQL Server me `CONVERT(DATE, str, 103)`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Capital '%Y' vs Small '%y':**
  * *Interviewer:* *"Format specifier me '%y' aur '%Y' me kya difference hai?"*
  * *Aapka Jawab:* *"Sir, `%Y` (capital) 4-digit year (2023) expect karta hai, jabki `%y` (small) 2-digit year (23) expect karta hai. Agar 4-digit year par `%y` laga diya toh parsing fail ho kar NULL ya wrong century evaluate karega."*
* **Trap 2: Alias in ORDER BY vs WHERE:**
  * *Interviewer:* *"ORDER BY me direct `standard_date` alias chal jata hai par WHERE me kyu nahi?"*
  * *Aapka Jawab:* *"SQL execution lifecycle me `WHERE` phase `SELECT` se pehle run hota hai, isliye filter phase par alias exist nahi karta. Jabki `ORDER BY` execution ke bilkul end me chalta hai, isliye projection ke declare kiye gaye aliases ORDER BY me fully accessible hote hain."*

---

## 📌 Q019: Title Casing & Capitalization Normalization (`CONCAT`, `UPPER`, `LOWER`)

### 💡 Production SQL:
```sql
SELECT 
    product_id, 
    CONCAT(
        UPPER(LEFT(raw_product_name, 1)), 
        LOWER(SUBSTRING(raw_product_name, 2))
    ) AS clean_product_name, 
    category, 
    unit_price 
FROM product_catalog 
WHERE is_available = TRUE 
  AND unit_price >= 1000 
ORDER BY 
    unit_price DESC, 
    product_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Product catalog me sellers ne random casings me names enter kiye hain (e.g. 'lAPTOP', 'smartWATCH'). Display consistency ke liye hume Proper Case (Pehla letter Capital, baaki sab Small) chahiye un available products ke liye jinka price >= 1000 ho. Kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, standard SQL aur MySQL me native INITCAP function na hone ki wajah se hum string decomposition formula use karte hain: `UPPER(LEFT(str, 1))` se pehla character capital karenge aur `LOWER(SUBSTRING(str, 2))` se baaki characters ko small karke `CONCAT` kar denge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **String Decomposition:** First letter at index 1 ko isolate karna aur position 2 se end tak slice karke lowercase karna universal cross-engine pattern hai.
* **Native Functions:** PostgreSQL aur Oracle me direct `INITCAP(str)` function available hota hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Leading space hazard in proper casing:**
  * *Interviewer:* *"Agar product name ke aage accidental space ho (' laptop'), toh kya yeh formula kaam karega?"*
  * *Aapka Jawab:* *"Nahi sir, `LEFT(col, 1)` space ko pick kar lega aur actual word lowercase hi reh jayega. Isliye production cleaning me hum pehle `TRIM()` apply karte hain: `UPPER(LEFT(TRIM(col), 1))`."*
* **Trap 2: Multi-word titles:**
  * *Interviewer:* *"Kya yeh formula 'wireless gaming mouse' ke sabhi words ko capitalize karega?"*
  * *Aapka Jawab:* *"Nahi sir, `SUBSTRING(..., 2)` position 2 ke baad sab kuch lowercase bana deta hai, isliye yeh single-word titles ke liye direct chalta hai. Multi-word strings ke liye PostgreSQL me `INITCAP()` best hai, jabki MySQL me string splitting ya regex approach lagti hai."*

---

## 📌 Q020: Date Addition & Expiry/Warranty Tracking (`DATE_ADD`, `INTERVAL`)

### 💡 Production SQL:
```sql
SELECT 
    warranty_id, 
    customer_name, 
    device_type, 
    DATE_ADD(purchase_date, INTERVAL warranty_months MONTH) AS expiry_date, 
    service_status 
FROM device_warranties 
WHERE service_status = 'Active' 
  AND DATE_ADD(purchase_date, INTERVAL warranty_months MONTH) < '2024-01-01' 
ORDER BY 
    expiry_date ASC, 
    warranty_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Electronics customer service table me purchase_date aur dynamic warranty_months (e.g. 6, 12, 24) diye hain. Cut-off date '2024-01-01' se pehle expire ho chuki active warranties ki report kaise nikaloge?"*
* **Aapka Professional Jawab:**
  > *"Sir, dynamic month addition ke liye hum `DATE_ADD(purchase_date, INTERVAL warranty_months MONTH)` use karke expiry date compute karenge. `WHERE service_status = 'Active' AND DATE_ADD(...) < '2024-01-01'` se filter karenge aur `expiry_date ASC, warranty_id ASC` se sort karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Dynamic Interval Arithmetic:** Static number ke badle column reference (`warranty_months MONTH`) dynamically har row ke hisab se calculate karta hai.
* **Cross-Dialect Differences:** MySQL me `DATE_ADD(date, INTERVAL n MONTH)`, SQL Server me `DATEADD(month, n, date)`, aur PostgreSQL me `date + (n || ' month')::interval`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Dialect syntax difference:**
  * *Interviewer:* *"SQL Server (T-SQL) me DATE_ADD kaise likhte hain?"*
  * *Aapka Jawab:* *"Sir, SQL Server me `DATEADD` (bina underscore) use hota hai aur unit first argument banti hai: `DATEADD(month, warranty_months, purchase_date)`. MySQL me `DATE_ADD` ke saath `INTERVAL` keyword lagta hai."*
* **Trap 2: End-of-month calendar handling:**
  * *Interviewer:* *"Agar purchase date 31 January ho aur 1 month add karein toh leap year me kya result aayega?"*
  * *Aapka Jawab:* *"Database engines automatically month length adjust karte hain. 31 January me 1 month add karne par leap year me `2024-02-29` aur non-leap year me `2023-02-28` return hota hai bina kisi error ke."*

---

## 📌 Q021: Feedback Sentiment Keyword Tagging (`CASE WHEN`, `LIKE`, CTE)

### 💡 Production SQL:
```sql
WITH feedback_data AS (
    SELECT 
        review_id, 
        customer_name, 
        review_text, 
        rating_stars, 
        CASE 
            WHEN LOWER(review_text) LIKE '%cold%' 
              OR LOWER(review_text) LIKE '%late%' 
              OR LOWER(review_text) LIKE '%worst%' 
            THEN 'Negative'
            WHEN LOWER(review_text) LIKE '%great%' 
              OR LOWER(review_text) LIKE '%loved%' 
            THEN 'Positive'
            ELSE 'Neutral'
        END AS feedback_tag 
    FROM customer_reviews
)
SELECT 
    review_id, 
    customer_name, 
    review_text, 
    rating_stars, 
    feedback_tag 
FROM feedback_data 
WHERE feedback_tag = 'Negative' 
ORDER BY 
    rating_stars ASC, 
    review_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Customer feedback free-text me negative keywords ('cold', 'late', 'worst') detect karke escalation queue banani hai lowest ratings pehle rakh kar. Alias ko WHERE me direct filter kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum CTE (`WITH feedback_data AS ...`) use karenge jisme `CASE WHEN` ke through keywords classify karke `feedback_tag` banayenge. Outer query me direct `WHERE feedback_tag = 'Negative'` filter lagayenge taaki lamba formula repeat na karna pade."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Sequential Short-Circuiting:** `CASE WHEN` upar se niche line-by-line evaluate hota hai aur pehla matching condition milte hi ruk jata hai. Isliye priority complaints (negative) ko top branches par rakhna zaroori hai.
* **CTE Modularization:** CTE use karne se code maintainable rehta hai aur same statement me projection alias filter ho pata hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Conflicting keywords in single review:**
  * *Interviewer:* *"Agar customer ne likha 'late but great', toh kaunsa tag lagega?"*
  * *Aapka Jawab:* *"Sir, kyunki negative condition branch pehle likhi hai, engine 'late' match hote hi turant 'Negative' assign kar dega aur agle branches skip kar dega. Operations triage me negative escalations ko priority di jaati hai."*
* **Trap 2: Double wildcard performance:**
  * *Interviewer:* *"5 crore reviews par `LIKE '%cold%'` slow kyu hoga aur production me iska alternative kya hai?"*
  * *Aapka Jawab:* *"Leading aur trailing wildcards B-Tree index ko completely invalidate kar dete hain aur Full Table Scan hota hai. High-volume production systems me relational LIKE ke badle PostgreSQL Full-Text Search (`tsvector` with GIN index) ya Elasticsearch integrate kiya jata hai."*

---

## 📌 Q022: Exact Age Calculation & Senior Citizen KYC (`TIMESTAMPDIFF`)

### 💡 Production SQL:
```sql
SELECT 
    holder_id, 
    customer_name, 
    date_of_birth, 
    TIMESTAMPDIFF(YEAR, date_of_birth, '2024-01-01') AS customer_age, 
    policy_status 
FROM policy_holders 
WHERE policy_status = 'Active' 
  AND TIMESTAMPDIFF(YEAR, date_of_birth, '2024-01-01') >= 60 
ORDER BY 
    customer_age DESC, 
    holder_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Health insurance policyholders table me date_of_birth di hai. Benchmark date '2024-01-01' par exact completed age calculate karke un Active senior citizens (age >= 60) ko filter karna hai jinka birthday cross ho chuka ho. Query kaise likhoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, simple calendar year minus karne (`YEAR - YEAR`) se birthday month ignore ho jata hai aur galat age nikalti hai. Hum `TIMESTAMPDIFF(YEAR, date_of_birth, '2024-01-01')` use karenge jo check karta hai ki target date tak birthday complete hua hai ya nahi. `WHERE policy_status = 'Active' AND TIMESTAMPDIFF(...) >= 60` se senior citizens filter karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Completed Birthday vs Year Crossing:** Agar banda 25 March 1964 ko born hua hai, toh 1 Jan 2024 ko uski real age 59 hai (60 nahi), kyunki uska birthday March me aayega. `TIMESTAMPDIFF` exact day tak calendar validity maintain karta hai.
* **Dialect Differences:** MySQL me `TIMESTAMPDIFF(YEAR, dob, target)`, PostgreSQL me `EXTRACT(YEAR FROM AGE(target, dob))`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Year subtraction fallacy:**
  * *Interviewer:* *"Hum `YEAR('2024-01-01') - YEAR(date_of_birth)` kyu nahi use karte?"*
  * *Aapka Jawab:* *"Sir, yeh formula sirf saal ka difference leta hai aur months/days ignore kar deta hai. Agar kisi ka birthday saal ke aakhir me hai, toh yeh formula use pehle hi 1 saal bada show kar dega, jisse insurance premium ya audit me severe financial discrepancy create hoti hai."*
* **Trap 2: T-SQL DATEDIFF boundary trap:**
  * *Interviewer:* *"SQL Server me `DATEDIFF(year, dob, target)` directly chalane me kya dikkat aati hai?"*
  * *Aapka Jawab:* *"Sir, SQL Server ka DATEDIFF sirf calendar year boundary count karta hai. Example: 31 Dec 2023 aur 1 Jan 2024 ke beech DATEDIFF(year) ka answer 1 aayega (jabki actual gap sirf 1 din ka hai). Isliye SQL Server me adjustment logic lagana padta hai."*

---

## 📌 Q023: Hour & Minute Extraction for Peak Traffic (`HOUR`, `MINUTE`, `DATETIME`)

### 💡 Production SQL:
```sql
SELECT 
    trip_id, 
    rider_name, 
    pickup_time, 
    HOUR(pickup_time) AS pickup_hour, 
    MINUTE(pickup_time) AS pickup_minute, 
    trip_distance_km 
FROM delivery_trips 
WHERE trip_status = 'Completed' 
  AND HOUR(pickup_time) BETWEEN 19 AND 21 
  AND trip_distance_km >= 5.0 
ORDER BY 
    pickup_time DESC, 
    trip_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Quick-commerce / Ride-hailing delivery trips me evening surge pricing (7:00 PM se 9:59 PM) verify karni hai un completed trips ke liye jo 5 km se lambi hain. Time filtering aur extraction kaise design karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, SQL me 24-hour military clock follow hota hai. 7:00 PM `19` aur 9:59 PM `21` hota hai. Hum `HOUR(pickup_time)` aur `MINUTE(pickup_time)` extract karenge, `WHERE trip_status = 'Completed' AND HOUR(pickup_time) BETWEEN 19 AND 21 AND trip_distance_km >= 5.0` se filter karenge, aur latest trips pehle display karne ke liye `pickup_time DESC` sort karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **24-Hour Time Mechanics:** `HOUR()` 0 se 23 tak integer deta hai. 7 PM = 19, 8 PM = 20, 9 PM = 21, 10 PM = 22.
* **Dialect Differences:** MySQL me `HOUR(col)`, PostgreSQL me `EXTRACT(HOUR FROM col)`, aur SQL Server me `DATEPART(hour, col)`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: 9:59 PM vs 10 PM boundary trap:**
  * *Interviewer:* *"Agar surge 9:59 PM tak hai, toh kya hum `BETWEEN 19 AND 22` likh sakte hain?"*
  * *Aapka Jawab:* *"Nahi sir, `HOUR = 22` ka matlab 10:00 PM se 10:59:59 PM hota hai. `BETWEEN 19 AND 22` likhne se poora 10 baje ka ghanta bhi shamil ho jayega aur surge overpay ho jayega. Exact 9:59 PM tak ke liye `BETWEEN 19 AND 21` hi likhna zaroori hai."*
* **Trap 2: UTC vs Local Timezone skew:**
  * *Interviewer:* *"Agar server timestamps UTC me store ho aur surge IST (UTC+5:30) par depend karta ho toh kya dikkat aayegi?"*
  * *Aapka Jawab:* *"Sir, direct UTC par HOUR() nikalne se 5.5 hours ka shift aa jayega aur dopehar ki trips surge me calculate ho jayengi. Production me hum pehle timezone convert karte hain: `CONVERT_TZ(pickup_time, '+00:00', '+05:30')`."*

---

## 📌 Q024: Regex Alphanumeric Validation (`REGEXP`, `RLIKE`, Anchors)

### 💡 Production SQL:
```sql
SELECT 
    kyc_id, 
    customer_name, 
    pan_number, 
    submission_status 
FROM kyc_verifications 
WHERE submission_status = 'Submitted' 
  AND pan_number NOT REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$' 
ORDER BY kyc_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"FinTech banking KYC me Indian PAN Card format strictly 5 letters + 4 numbers + 1 letter (`ABCDE1234F`) hona chahiye. Fraud aur validation failure se bachne ke liye un Submitted records ko kaise extract karoge jinka PAN format invalid hai?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum regular expression use karenge exact boundary anchors ke saath: `'^[A-Z]{5}[0-9]{4}[A-Z]$'`. Invalid formats ko isolate karne ke liye `WHERE submission_status = 'Submitted' AND pan_number NOT REGEXP ...` filter lagayenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Anchors (`^` aur `$`) ki Ahmiyat:** `^` string ke start aur `$` string ke end ko lock karta hai. Bina inke regex poori string me kahin bhi match dhoondhta hai aur `'INVALID_ABCDE1234F_EXTRA'` ko bhi valid maan leta hai!
* **Cross-Dialect Differences:** MySQL me `REGEXP` / `RLIKE`, PostgreSQL me `!~` (negated regex), aur Oracle me `NOT REGEXP_LIKE()`. SQL Server me native regex nahi hota, wahan `LIKE '[A-Z]...'` pattern use hota hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Anchors na lagane ka nuksan:**
  * *Interviewer:* *"Agar regex me `^` aur `$` na lagayein toh kya problem aayegi?"*
  * *Aapka Jawab:* *"Sir, bina anchors ke regex partial match (substring) allow karta hai. 15-character ka invalid input bhi valid maan liya jayega agar uske beech me 10 valid characters hon. Strict 10-character validation ke liye anchors mandatory hain."*
* **Trap 2: T-SQL me regex support:**
  * *Interviewer:* *"Kya SQL Server (T-SQL) me `REGEXP` keyword chalta hai?"*
  * *Aapka Jawab:* *"Nahi sir, SQL Server native REGEXP keyword support nahi karta. Wahan character classes ke saath `LIKE '[A-Z][A-Z]...'` likhna padta hai ya CLR integration use karni hoti hai."*

---

## 📌 Q025: Handling NULLs & Multi-Tier Fallback Imputation (`COALESCE`)

### 💡 Production SQL:
```sql
SELECT 
    contact_id, 
    customer_name, 
    COALESCE(primary_phone, alternate_phone, email_id, 'No Contact Available') AS preferred_contact, 
    account_type 
FROM customer_contacts 
WHERE account_type = 'Premium' 
ORDER BY contact_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Customer contact table me numbers missing hote hain. Marketing gateway ke liye priority order me pehla non-null contact address (Primary Phone -> Alternate Phone -> Email -> 'No Contact Available') nikalna hai un Premium accounts ke liye. Query kaise likhoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, multi-tier fallback ke liye ANSI standard `COALESCE(primary_phone, alternate_phone, email_id, 'No Contact Available')` use karenge jo left-to-right evaluate karke pehli non-null value pick karta hai. `WHERE account_type = 'Premium'` filter lagakar `contact_id ASC` se sort kar denge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **`COALESCE` vs `IFNULL` / `NVL`:** `IFNULL()` sirf 2 arguments leta hai. 4-level hierarchy ke liye 3 nested IFNULL likhne padenge jo anti-pattern hai. `COALESCE` unlimited arguments leta hai aur ANSI compliant hai.
* **Short-Circuit Evaluation:** `COALESCE` pehla non-null milte hi aage ke columns evaluate karna band kar deta hai, jo CPU resources bachaata hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Empty string `''` vs NULL trap:**
  * *Interviewer:* *"Agar customer profile me `primary_phone = ''` (empty string) ho, toh `COALESCE('', alternate_phone)` kya dega?"*
  * *Aapka Jawab:* *"Sir, SQL me empty string `''` NULL nahi hota balki ek valid character string hota hai, isliye COALESCE empty string hi return kar dega aur alternate phone tak nahi jayega! Isse bachne ke liye dirty data me hum `NULLIF(primary_phone, '')` use karte hain jo empty string ko NULL me convert kar deta hai."*
* **Trap 2: Data type compatibility:**
  * *Interviewer:* *"Kya COALESCE ke andar alag-alag data types pass kar sakte hain?"*
  * *Aapka Jawab:* *"Nahi sir, ANSI SQL me COALESCE ke sabhi arguments compatible data types ke hone chahiye, warna database type mismatch error ya unexpected implicit conversion karta hai."*

---

## 📌 Q026: Day Name Extraction & Weekend Surge Analysis (`DAYNAME`, `CASE WHEN`)

### 💡 Production SQL:
```sql
SELECT 
    sale_id, 
    store_location, 
    sale_date, 
    DAYNAME(sale_date) AS day_of_week, 
    CASE 
        WHEN DAYNAME(sale_date) IN ('Saturday', 'Sunday') THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS day_type, 
    gross_amount 
FROM store_sales 
WHERE gross_amount >= 5000 
  AND DAYNAME(sale_date) IN ('Saturday', 'Sunday') 
ORDER BY 
    gross_amount DESC, 
    sale_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"Retail store sales table me transaction date di hai. Weekend (Saturday & Sunday) par hue high-ticket transactions (gross_amount >= 5000) ko extract karna hai human-readable day name aur 'Weekend'/'Weekday' cohort tag ke saath. Kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `DAYNAME(sale_date)` se full day name extract karenge. `CASE WHEN DAYNAME(...) IN ('Saturday', 'Sunday') THEN 'Weekend' ELSE 'Weekday' END` se cohort classification karenge aur `WHERE gross_amount >= 5000 AND DAYNAME(...) IN ('Saturday', 'Sunday')` se filter karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **`DAYNAME` vs `DAYOFWEEK`:** `DAYNAME()` string return karta hai ('Sunday'), jabki `DAYOFWEEK()` integer index deta hai (1 = Sunday, 7 = Saturday). Internationalization me numeric extraction (`DAYOFWEEK`) server locale change hone par bhi fail nahi hoti.
* **Dialect Variations:** PostgreSQL me `TO_CHAR(date, 'FMDay')` use hota hai, aur SQL Server me `DATENAME(weekday, date)`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: PostgreSQL blank space padding trap:**
  * *Interviewer:* *"PostgreSQL me `TO_CHAR(sale_date, 'Day') = 'Saturday'` match kyu fail hota hai?"*
  * *Aapka Jawab:* *"Sir, PostgreSQL ka `TO_CHAR(..., 'Day')` blank spaces add karta hai 9 characters ('Wednesday') match karne ke liye ('Saturday '). Isse exact equality fail ho jati hai. Isse bachne ke liye Fill-Mode modifier `FMDay` use karte hain: `TO_CHAR(sale_date, 'FMDay')`."*
* **Trap 2: `DAYOFWEEK()` vs `WEEKDAY()` indexing difference:**
  * *Interviewer:* *"MySQL me `DAYOFWEEK()` aur `WEEKDAY()` me kya difference hai?"*
  * *Aapka Jawab:* *"Sir, `DAYOFWEEK()` ODBC standard follow karta hai jisme 1 = Sunday aur 7 = Saturday hota hai. Jabki `WEEKDAY()` ISO/Python standard follow karta hai jisme 0 = Monday aur 6 = Sunday hota hai. Galat function use karne se day shift ho jata hai."*

---

## 📌 Q027: Nullifying Sentinel Dummy Values (`NULLIF`)

### 💡 Production SQL:
```sql
SELECT 
    reading_id, 
    sensor_location, 
    NULLIF(temperature_celsius, -999.00) AS clean_temperature, 
    battery_level_pct 
FROM sensor_telemetry 
WHERE battery_level_pct >= 20 
  AND NULLIF(temperature_celsius, -999.00) IS NOT NULL 
ORDER BY 
    clean_temperature DESC, 
    reading_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"IoT sensor network me hardware disconnection par temperature -999.00 (sentinel dummy code) record ho jata hai. Agar uncleaned data par AVG() nikalein toh poori analytics crash/distort ho jayegi. -999.00 ko NULL me convert karke valid readings kaise nikaloge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `NULLIF(temperature_celsius, -999.00)` use karenge jo matching sentinel value ko NULL bana deta hai. `WHERE battery_level_pct >= 20 AND NULLIF(...) IS NOT NULL` filter lagakar invalid records eliminate karenge aur `clean_temperature DESC` sort karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **`NULLIF` Mechanism:** `NULLIF(A, B)` check karta hai: agar $A = B$ toh return `NULL`, warna return $A$. Yeh shorthand hai: `CASE WHEN A = B THEN NULL ELSE A END`.
* **Aggregate Protection:** SQL ke aggregate functions (`AVG`, `SUM`, `MIN`, `MAX`) automatically NULLs ko ignore karte hain. Sentinel -999 ko NULL banane se average calculations 100% accurate ho jati hain.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: `COALESCE` vs `NULLIF`:**
  * *Interviewer:* *"COALESCE aur NULLIF me exact kya difference hai?"*
  * *Aapka Jawab:* *"Sir, dono ek doosre ke mirror opposites hain: `COALESCE` NULL ko non-null value me convert karta hai, jabki `NULLIF` kisi target non-null value ko NULL me convert karta hai."*
* **Trap 2: Division-by-Zero prevention:**
  * *Interviewer:* *"SQL me division-by-zero error rokne ke liye NULLIF kaise use hota hai?"*
  * *Aapka Jawab:* *"Sir, denominator me `revenue / NULLIF(units_sold, 0)` lagane se agar units 0 honge toh denominator NULL ban jayega, aur kisi bhi number ko NULL se divide karne par error crash hone ke badle safely NULL return ho jata hai."*

---

## 📌 Q028: Date Truncation & Cohort Normalization (`DATE_FORMAT` / `DATE_TRUNC`)

### 💡 Production SQL:
```sql
SELECT 
    payment_id,
    customer_id,
    payment_date,
    DATE_FORMAT(payment_date, '%Y-%m-01') AS cohort_month,
    plan_name,
    amount_paid
FROM subscription_payments
WHERE payment_status = 'Success'
  AND amount_paid >= 500.00
  AND plan_name IN ('Monthly', 'Annual')
ORDER BY cohort_month DESC, payment_id ASC;
```

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"SaaS / OTT retention cohort analysis me users kisi bhi random date par subscribe karte hain. Monthly retention aur churn curves calculate karne ke liye har payment date ko uske month ki 1st date (`YYYY-MM-01`) par normalize kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, hum `DATE_FORMAT(payment_date, '%Y-%m-01')` use karenge jo year aur month ko format karte hue day ko static '01' par lock kar deta hai. Business filters `payment_status = 'Success'`, `amount_paid >= 500.00`, aur `plan_name IN ('Monthly', 'Annual')` apply karke cohort timeline ke hisab se `cohort_month DESC, payment_id ASC` sort karenge."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Temporal Cohorting:** Random transaction dates ko 1st-of-month anchor par align karna mandatory hota hai taaki cohort retention matrix (Month 0, Month 1, Month 2...) reliably compute ho sake.
* **Dialect Differences:**
  * **MySQL:** `DATE_FORMAT(date, '%Y-%m-01')` (string) ya `DATE_SUB(date, INTERVAL DAY(date)-1 DAY)` (native DATE).
  * **PostgreSQL / Snowflake / BigQuery:** `DATE_TRUNC('month', date)`.
  * **SQL Server:** `DATEFROMPARTS(YEAR(date), MONTH(date), 1)`.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Text `YYYY-MM` vs Date `YYYY-MM-01`:**
  * *Interviewer:* *"Hum directly `YYYY-MM` (jaise '2024-03') string format me group kyu nahi karte?"*
  * *Aapka Jawab:* *"Sir, downstream BI tools (Power BI, Tableau) me continuous Date hierarchy aur Calendar dimension tables ke saath join karne ke liye true DATE data type chahiye hota hai. 'YYYY-MM-01' real date format maintain karta hai jisse time-intelligence functions work karte hain."*
* **Trap 2: `OR` Operator Precedence Leak:**
  * *Interviewer:* *"Agar `WHERE plan_name = 'Monthly' OR plan_name = 'Annual' AND payment_status = 'Success'` likhein toh kya galat hoga?"*
  * *Aapka Jawab:* *"Sir, `AND` ki precedence `OR` se high hoti hai. Isliye query evaluate karegi `(plan_name = 'Annual' AND Success)` aur `plan_name = 'Monthly'` akele condition ban jayegi, jisse Failed monthly payments bhi leak ho jayenge. Isse bachne ke liye `IN ('Monthly', 'Annual')` ya parentheses lagana zaroori hai."*

---

## 📌 Q029: Credit Card & PII Data Masking (`REPEAT`, `RIGHT`, `LPAD`)

### 💡 Production SQL:
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

### 🏢 Business Scenario (Interviewer kaise puchega & Aapko kya bolna hai):
* **Interviewer:** *"FinTech banking audit me PCI-DSS compliance ke tahat customer ka raw 16-digit card number expose nahi kar sakte. Reporting analysts ke liye pehle digits ko asterisks (`*`) se mask karke sirf aakhri 4 digits visible kaise karoge?"*
* **Aapka Professional Jawab:**
  > *"Sir, dynamic masking ke liye hum `CONCAT(REPEAT('*', LENGTH(card_number) - 4), RIGHT(card_number, 4))` use karenge. Isse 16-digit (Visa/Mastercard), 15-digit (Amex), ya 14-digit (Diners) kisi bhi card ki length preserve rehti hai aur last 4 digits dikhte hain. Alternate approach me `LPAD(RIGHT(card_number, 4), LENGTH(card_number), '*')` bhi use kiya ja sakta hai."*

### 🧠 Deep Concept (Jo dimag me clear hona chahiye):
* **Dynamic Length Handling:** Static 12 asterisks hardcode karne ke bajaye `LENGTH(col) - 4` use karna chahiye taaki non-standard length cards break na hon.
* **Storage vs Egress Masking:** Raw PAN database me plain text me store nahi hota (tokenized ya AES-256 encrypted hota hai). Masking presentation/view layer par RBAC access control ke liye use hoti hai.

### 🚨 Common Interview Traps (Counter-Questions & IT Answers):
* **Trap 1: Hardcoding 12 asterisks:**
  * *Interviewer:* *"Agar Amex 15-digit card par `REPEAT('*', 12)` lagaya toh kya hoga?"*
  * *Aapka Jawab:* *"Sir, card ki total length 12 + 4 = 16 ban jayegi jo data integrity distort kar degi. Hamesha dynamic `LENGTH(card_number) - 4` ya `LPAD` use karna best practice hai."*
* **Trap 2: BIGINT vs VARCHAR storage:**
  * *Interviewer:* *"Card numbers ko BIGINT me store kyu nahi karna chahiye?"*
  * *Aapka Jawab:* *"Sir, do reasons hain: pehla, card numbers par koi math calculation (+, -) nahi hoti. Doosra, kuch cards me leading zeros hote hain jo BIGINT me drop ho jate hain. Isliye identifiers ko hamesha VARCHAR me rakha jata hai."*

---
*(Curriculum continues with Q030 to Q035...)*
