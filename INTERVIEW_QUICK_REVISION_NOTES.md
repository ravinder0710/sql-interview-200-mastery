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
*(Curriculum continues with Q017 to Q035...)*
