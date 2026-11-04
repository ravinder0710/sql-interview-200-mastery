# ⚡ SQL Interview Quick Revision Notes (1-2 Yrs Analyst Prep)
### Target Role: Data Analyst / SQL Developer (0 — 2 Years Experience)
*Style: Clear, natural Hinglish with real business logic, exact interviewer traps, and mature candidate defense.*

---

## 📌 Block 01: Foundations & Data Filtering (Q001 — Q010)

---

### 🔹 Q001: Strict Numeric Boundary Filtering & Column Projection
* **SQL Query**:
  ```sql
  SELECT emp_id, emp_name, department, salary 
  FROM employees 
  WHERE salary > 60000;
  ```
* **🏢 Real Business Scenario**:
  HR compensation audit ya annual appraisal review chal raha hai jahan exact 60,000 threshold ke upar high-earning staff ka list finance team ko chahiye hota hai.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  SQL engine pehle `FROM employees` table par jata hai, fir `WHERE salary > 60000` check karke 60k se kam aur barabar walo ko bahar karta hai, aur sabse aakhri me sirf required 4 columns display karta hai.
* **⚠️ Interviewer Trap Question**:
  *"Maine dekha tumne `SELECT emp_id, emp_name...` likha, agar tum yahan `SELECT *` likh dete toh kya issue hota? Aur agar kisi employee ki salary exact 60,000 hui to wo aayegi ya nahi?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, agar production database me 50 lakh rows aur 40-50 columns ho, toh `SELECT *` likhne se hard disk se pura heavy data memory me load hoga aur network slow ho jayega. Jab hum specific columns mangte hain, toh database ka engine Index-Only Scan use karke query ko 5-10 guna fast chala deta hai. Aur question me bola tha 'strictly greater than 60,000', isliye `>` use kiya hai taaki exact 60,000 exclude rahe. Agar `>=` lagate toh audit report me galat numbers chale jaate."*

---

### 🔹 Q002: String Inequality (`<>` / `!=`) & The Famous NULL Trap
* **SQL Query**:
  ```sql
  SELECT order_id, customer_name, order_status, order_amount 
  FROM orders 
  WHERE order_status <> 'Delivered' 
    AND payment_type = 'Online';
  ```
* **🏢 Real Business Scenario**:
  E-commerce logistics operations me pending ya in-transit prepaid orders track karne hain jin par customer support aur dispatch team ko urgent action lena hai.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  Query sabhi online orders ko check karti hai aur 'Delivered' walo ko chhodkar baki sab ko leti hai. Par SQL me 3 values hoti hain: TRUE, FALSE, aur UNKNOWN (Three-Valued Logic).
* **⚠️ Interviewer Trap Question**:
  *"Maan lo ek naya order aaya jiska status abhi system me update nahi hua aur wo `NULL` hai. Kya tumhari query us order ko return karegi?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Nahi sir, SQL me jab hum kisi bhi value ko NULL se compare karte hain (`NULL <> 'Delivered'`), toh result FALSE nahi balki UNKNOWN aata hai. Aur `WHERE` clause sirf strictly TRUE rows ko allow karti hai, isliye NULL status wale orders silently drop ho jayenge. Agar business ko wo unassigned ya NULL records bhi dekhne hain, toh safe code likhne ke liye hume explicit `WHERE (order_status <> 'Delivered' OR order_status IS NULL)` lagana padega."*

---

### 🔹 Q003: Set Membership (`IN`) & Inclusive Range (`BETWEEN`)
* **SQL Query**:
  ```sql
  SELECT product_id, product_name, category, price, stock_qty 
  FROM products 
  WHERE category IN ('Electronics', 'Appliances') 
    AND price BETWEEN 1000 AND 10000 
    AND stock_qty > 0;
  ```
* **🏢 Real Business Scenario**:
  Retail / E-commerce festive sale campaign ke liye mid-range price (1,000 se 10,000) ke in-stock products filter karke marketing team ko banner promo ke liye list deni hai.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  `category IN (...)` categories match karta hai, `BETWEEN 1000 AND 10000` price range filter karta hai, aur `stock_qty > 0` out-of-stock items ko hata deta hai.
* **⚠️ Interviewer Trap Question**:
  *"Multiple OR conditions likhne ke badle `IN` lagane ka kya fayda hai? Aur kya `BETWEEN` me 1,000 aur 10,000 ka product include hoga ya bahar ho jayega?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, `BETWEEN` hamesha fully inclusive hota hai, yaani 1,000 aur 10,000 dono isme shamil honge (yeh `price >= 1000 AND price <= 10000` ke barabar hai). Aur multiple `OR` likhne ke badle jab hum `IN` use karte hain, toh code clean rehta hai aur database optimizer internal hash lookup banata hai jo execution ko fast karta hai. Saath hi price column par B-Tree index scan smoothly kaam karta hai."*

---

### 🔹 Q004: Wildcard Pattern Matching (`LIKE`, `%`, `_`, `NOT LIKE`)
* **SQL Query**:
  ```sql
  SELECT customer_id, customer_name, email, city 
  FROM customers 
  WHERE customer_name LIKE 'A%' 
    AND email LIKE '%@gmail.com' 
    AND email NOT LIKE '%test%';
  ```
* **🏢 Real Business Scenario**:
  CRM / Marketing team ko promotional campaigns bhejne ke liye valid Gmail users filter karne hain aur internal dummy/test accounts (`%test%`) ko clean karna hai taaki marketing credits waste na hon.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  `LIKE 'A%'` start match karta hai, `LIKE '%@gmail.com'` domain match karta hai, aur `NOT LIKE '%test%'` dummy accounts filter karta hai.
* **⚠️ Interviewer Trap Question**:
  *"Agar mere paas 1 crore customers ka data ho, toh `customer_name LIKE 'A%'` aur `email LIKE '%@gmail.com'` dono me se kaunsi condition slow chalegi aur kyu?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, `email LIKE '%@gmail.com'` wali condition slow chalegi. Kyunki isme aage percentage (leading wildcard) laga hai, toh database index ko nahi pata chal pata ki string kahan se shuru ho rahi hai, isliye wo har ek row ko line se check karta hai (Full Table Scan). Jabki `LIKE 'A%'` me starting letter pata hai, toh database seedha B-Tree Index Seek karke fast result nikal leta hai."*

---

### 🔹 Q005: Missing Data (`IS NULL`) & Operator Precedence (`AND` vs `OR`)
* **SQL Query**:
  ```sql
  SELECT rep_id, rep_name, salary, commission_pct, manager_id 
  FROM sales_reps 
  WHERE salary >= 50000 
    AND is_active = TRUE 
    AND (commission_pct IS NULL OR manager_id IS NULL);
  ```
* **🏢 Real Business Scenario**:
  Sales operations me un active high-salary reps ko identify karna jinke ya to incentives policy assign nahi hai ya unka reporting manager unassigned chhut gaya hai.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  BODMAS rule ki tarah SQL me pehle `AND` execute hota hai, fir `OR`. Isliye `(commission_pct IS NULL OR manager_id IS NULL)` ko brackets me band kiya gaya hai.
* **⚠️ Interviewer Trap Question**:
  *"Agar tum `(commission_pct IS NULL OR manager_id IS NULL)` se brackets `( )` hata do, toh query par kya asar padega? Kya result same aayega?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Bilkul nahi sir, result poora galat ho jayega! SQL me `AND` ki priority `OR` se zyada hoti hai. Agar hum brackets nahi lagayenge, toh query `[Salary >= 50k AND Active AND Comm IS NULL]` ko ek saath padhegi, aur `OR manager_id IS NULL` alag ho jayega. Nateeja yeh hoga ki har wo banda jiska manager NULL hai query me aa jayega—chahe uski salary 10,000 ho ya wo company chhod chuka ho! Isliye compound conditions me parentheses lagana mandatory hai."*

---

### 🔹 Q006: Multi-Column Sorting & Tie-Breaking (`ORDER BY`)
* **SQL Query**:
  ```sql
  SELECT appointment_id, patient_name, doctor_id, priority_score, appointment_time 
  FROM patient_appointments 
  WHERE status = 'Waiting' 
  ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC;
  ```
* **🏢 Real Business Scenario**:
  Hospital ER / OPD triage queue me pehle doctor assign karna, fir emergency priority score se patient line-up karna, aur tie hone par arrival time se resolve karna.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  Engine pehle column (`doctor_id`) se sort karta hai. Jab doctor same milta hai, tab second column (`priority_score DESC`) se line-up karta hai. Agar priority bhi barabar ho, tab third column (`appointment_time ASC`) tie-break karta hai.
* **⚠️ Interviewer Trap Question**:
  *"Log short me `ORDER BY 3, 4 DESC, 5` likh dete hain. Kya production me aisa column number likhna achhi practice hai? Aur agar kisi row me priority_score NULL ho toh wo kahan dikhega?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, production code me positional numbers (`ORDER BY 3, 4`) likhna strict bad practice (anti-pattern) hai. Kal ko agar kisi developer ne SELECT me columns ka sequence badal diya, toh poori sorting bina kisi warning ke galat metric par lag jayegi. Hamesha explicit column name likhna chahiye. Aur NULL values ke mamle me, MySQL/SQL Server ASC me NULL ko sabse pehle laate hain jabki PostgreSQL me NULL last me aata hai. Agar consistent rakhna ho toh hum explicit `NULLS LAST` specify karte hain."*

---

### 🔹 Q007: Top-N Truncation & Dialects (`LIMIT`, `TOP`, `FETCH FIRST`)
* **SQL Query**:
  ```sql
  SELECT song_id, title, artist, total_streams 
  FROM songs 
  WHERE release_year >= 2023 
  ORDER BY total_streams DESC 
  LIMIT 3;
  ```
* **🏢 Real Business Scenario**:
  Music streaming platform me 2023 ke baad ke top 3 highest streamed viral songs homepage banner par feature karne hain.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  Engine ordered data me se sirf shuru ke 3 records cut karke query stop kar deta hai.
* **⚠️ Interviewer Trap Question**:
  *"Agar 3rd aur 4th song ke total streams exact barabar (tie) ho gaye, toh `LIMIT 3` kya karega? Kya business ko dono gaane dikhane chahiye?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, `LIMIT 3` tie-break check nahi karta, wo bina bataye kisi bhi ek gaane ko arbitrarily cut kar dega aur doosra song bahar ho jayega. Agar business rule yeh kehta hai ki tie wale cases me sabhi top performers ko dikhana hai, toh SQL Server me `TOP 3 WITH TIES` use hota hai, aur standard SQL me hum window ranking function jaise `DENSE_RANK()` lagate hain taaki tied records miss na hon."*

---

### 🔹 Q008: Nth Highest Value via Pagination (`LIMIT 1 OFFSET N-1` + `DISTINCT`)
* **SQL Query**:
  ```sql
  SELECT DISTINCT price AS second_highest_price 
  FROM properties 
  WHERE city = 'Bangalore' 
  ORDER BY price DESC 
  LIMIT 1 OFFSET 1;
  ```
* **🏢 Real Business Scenario**:
  Real-estate platform par luxury properties me second highest listing price find karna (market benchmarking aur outlier filtering ke liye).
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  Formula hota hai: $\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$. 2nd highest ke liye pehla 1 record skip kiya (`OFFSET 1`) aur agla 1 record utha liya (`LIMIT 1`). `DISTINCT` lagane se pehle identical duplicate prices merge ho jaate hain.
* **⚠️ Interviewer Trap Question**:
  *"Agar do properties ka price exact barabar (jaise dono 4.5 Cr) ho, aur tumne `DISTINCT` nahi lagaya toh kya hoga? Aur agar table me sirf 1 hi property ho toh `LIMIT 1 OFFSET 1` kya return karega?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, agar `DISTINCT` nahi lagaya toh top rank par dono duplicate price honge, aur `OFFSET 1` skip karke wapas wahi 4.5 Cr laa dega jo ki 2nd highest nahi balki highest price ka hi duplicate hai. Isliye `DISTINCT` lagana zaroori hai. Doosri baat, agar table me sirf 1 hi record hai, toh `LIMIT 1 OFFSET 1` direct chalane par empty result (0 rows) deta hai. Interviewer ko typically single row with `NULL` chahiye hota hai, isliye hum query ko outer scalar SELECT me wrap karte hain: `SELECT (SELECT DISTINCT price FROM ... LIMIT 1 OFFSET 1) AS second_highest`."*

---

### 🔹 Q009: Calculated Columns, Arithmetic Precedence & Integer Division
* **SQL Query**:
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
* **🏢 Real Business Scenario**:
  E-commerce finance reconciliation me har completed order line item ka discount deduct karke net revenue aur final profit margin calculate karna.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  Maths ki tarah brackets me pehle discount percentage ka factor `(1 - discount_pct / 100.0)` calculate hota hai, fir gross amount se multiply hota hai, aur cost minus karke profit banta hai.
* **⚠️ Interviewer Trap Question**:
  *"Tumne discount formula me `100.0` kyu likha, simple `100` kyu nahi likha? Aur kya hum `(unit_price * quantity * ...) AS net_revenue` ko usi SELECT me profit ke andar direct reuse kar sakte hain?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, SQL Server aur PostgreSQL me agar hum do integers ko divide karein (jaise `15 / 100`), toh integer division ki wajah se answer 0.15 nahi balki seedha 0 ban jata hai! Isse discount ₹0 calculate hoga aur poora profit galat ho jayega. `100.0` likhne se engine floating-point decimal calculation karta hai. Aur rahi baat SELECT ke alias ki, SQL engine SELECT ke sabhi expressions ko parallel me process karta hai, isliye usi line me banaya gaya alias turant doosre column me use nahi ho sakta; ya toh formula repeat karna hota hai ya fir CTE / Subquery use karni hoti hai."*

---

### 🔹 Q010: Financial Rounding (`ROUND`, `CEIL`, `FLOOR`) & CTE Modularization
* **SQL Query**:
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
* **🏢 Real Business Scenario**:
  FinTech lending app me approved loans ke interest, total payable amount, aur monthly EMI calculate karna bina fractions ke penny loss ke.
* **⚙️ Execution Logic (Saral Bhasha Me)**:
  CTE (`WITH`) use karke pehle interest aur total amount calculate kiya gaya, fir outer query me us calculation ko clean tareeqe se reuse karke `CEIL()` lagaya gaya.
* **⚠️ Interviewer Trap Question**:
  *"EMI nikalte waqt `ROUND()` ke badle `CEIL()` lagane ka kya financial reason hai? Aur CTE use karne ka kya benefit mila?"*
* **💬 Candidate ka Perfect Jabab (1-2 Yrs Exp Style)**:
  *"Sir, banking aur lending me agar EMI decimal me aaye (jaise ₹8,333.33) aur hum normal `ROUND()` ya `FLOOR()` laga dein, toh tenure khatam hone par bank ko principal + interest se 50 paise ya ₹1 kam receive hoga. Isliye financial systems `CEIL()` (round-up) use karte hain taaki customer se aggregate recovery me koi shortfall na ho. Aur CTE use karne se humara lamba interest calculation formula ek separate step ban gaya, jisse code readable ho gaya aur formula ko baar-baar repeat karne ki zarurat nahi padi."*

---
*(Block 01 continues with Q011 to Q015...)*
