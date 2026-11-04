# ⚡ SQL Interview Revision Cheat Sheet (Simple Human Language & Trap Defense)
### (Target: Data Analyst | 0 — 2 Years Experience)

> 💡 **Kaise Padhein:** Har question ko 4 hisson mein baanta gaya hai:
> 1. **Interviewer kaise puchega?** (Real Business Scenario)
> 2. **Hume normal zubaan me kya jawab dena hai?** (Simple English/Hinglish explanation bina kisi bhaari techwords ke)
> 3. **⚠️ Interviewer ka Trap / Cross-Question?** (Interviewer kahan fasayega)
> 4. **🛡️ Trap ka Counter-Jawab?** (Fasne se bach kar confidently kya bolna hai)

---

## 📌 Block 01: Foundations & Data Filtering (Q001 — Q010)

---

### 🔹 Q001: Salary Filter & Specific Columns (`WHERE >`, Column Selection)

* **Code:**
  ```sql
  SELECT emp_id, emp_name, department, salary 
  FROM employees 
  WHERE salary > 60000;
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Company ko un employees ki list chahiye jinki monthly salary 60,000 se zyada hai taaki unka tax slab check kar sakein. Mujhe sirf zaroori details (ID, Name, Dept, Salary) screen par dikhao."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum `employees` table se sirf 4 maange gaye columns select karenge aur `WHERE salary > 60000` lagayenge. Isse wahi employees aayenge jinki salary 60,000 se ek rupya bhi upar hai."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Dataset mein ek bande ki salary exact 60,000 hai. Kya wo tumhari query mein aayega? Aur agar tum `SELECT *` likh dete toh kya dikkat hoti?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "Nahi sir, kyunki aapne 'strictly greater than 60,000' bola tha, isliye humne `>` lagaya hai `>=` nahi, toh 60,000 wala banda filter ho jayega.
  Aur `SELECT *` isliye nahi likha kyunki production database mein table mein 50-60 columns hote hain. Faaltu columns load karne se server slow ho jata hai, isliye sirf wahi maango jo report mein chahiye."

---

### 🔹 Q002: Undelivered Orders & NULL Trap (`<>`, `IS NULL`)

* **Code:**
  ```sql
  SELECT order_id, customer_name, order_status, order_amount 
  FROM orders 
  WHERE order_status <> 'Delivered' 
    AND payment_type = 'Online';
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Operations team ko dekhna hai ki online payment wale kitne orders abhi tak Deliver nahi hue (jaise In-Transit, Cancelled ya Pending) taaki unhe track kiya ja sake."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum `WHERE order_status <> 'Delivered' AND payment_type = 'Online'` lagayenge. Isse Delivered wale chhod kar baaki sab statuses filter ho jayenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Maan lo kisi naye order ka status abhi system mein khali (NULL) pada hua hai. Kya wo tumhari is query mein aayega?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "Nahi sir, SQL mein NULL ka matlab 'unknown' hota hai, toh `<> 'Delivered'` use bhi list se bahar phek dega. Agar business ko wo orders bhi dekhne hain jinka status abhi enter nahi hua, toh hume query mein safe tareeke se likhna padega: `WHERE (order_status <> 'Delivered' OR order_status IS NULL)`."

---

### 🔹 Q003: Category List aur Budget Range (`IN`, `BETWEEN`)

* **Code:**
  ```sql
  SELECT product_id, product_name, category, price, stock_qty 
  FROM products 
  WHERE category IN ('Electronics', 'Appliances') 
    AND price BETWEEN 1000 AND 10000 
    AND stock_qty > 0;
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "E-commerce website ke homepage par sale chalani hai. Sirf 'Electronics' aur 'Appliances' category ke wo products dikhao jinka price 1,000 se 10,000 ke beech ho aur stock mein kam se kam 1 item bacha ho."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, multiple categories ke liye hum `category IN ('Electronics', 'Appliances')` use karenge, budget ke liye `price BETWEEN 1000 AND 10000`, aur out-of-stock hatane ke liye `stock_qty > 0` lagayenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar kisi item ka price exact 1,000 ya exact 10,000 ho, toh kya `BETWEEN` use chhod dega? Aur `IN` ki jagah multiple `OR` kyu nahi likha?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "`BETWEEN` dono border values (1000 aur 10000) ko include karta hai sir, toh wo product zaroor aayega.
  Aur multiple `OR` likhne se code lamba aur confuse karne wala ho jata hai, `IN` lagane se code saaf dikhta hai aur database bhi use fast search kar leta hai."

---

### 🔹 Q004: Text Search & Wildcards (`LIKE '%...'`, `NOT LIKE`)

* **Code:**
  ```sql
  SELECT customer_id, customer_name, email, city 
  FROM customers 
  WHERE customer_name LIKE 'A%' 
    AND email LIKE '%@gmail.com' 
    AND email NOT LIKE '%test%';
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Marketing team ko email campaign bhejna hai. Hume wo customers chahiye jinka naam 'A' se shuru hota ho, email Gmail ka ho, lekin kisi tester ya fake email (`test`) pe mail nahi jana chahiye."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, naam ke liye `customer_name LIKE 'A%'`, Gmail confirm karne ke liye `email LIKE '%@gmail.com'`, aur fake emails hatane ke liye `email NOT LIKE '%test%'` lagayenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar 1 crore customers ka data ho, toh `LIKE 'A%'` aur `LIKE '%@gmail.com'` mein se kaunsi line database ko slow kar sakti hai?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "`LIKE '%@gmail.com'` slow karegi sir. Kyunki uske aage `%` laga hai, database ko pata hi nahi string kahan se shuru ho rahi hai, toh use puri table ke har ek row ko check karna padega (Full Table Scan). Jabki `A%` mein pehla letter pata hai, toh database seedha 'A' pe jump kar sakta hai."

---

### 🔹 Q005: Missing Commission & Bracket Trap (`IS NULL`, Brackets `()`)

* **Code:**
  ```sql
  SELECT rep_id, rep_name, salary, commission_pct, manager_id 
  FROM sales_reps 
  WHERE salary >= 50000 
    AND is_active = TRUE 
    AND (commission_pct IS NULL OR manager_id IS NULL);
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Audit team un active sales reps ko dhoondh rahi hai jinki salary kam se kam 50,000 ho, lekin ya toh unka commission set nahi hua hai ya unka koi manager assign nahi hai."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum `salary >= 50000 AND is_active = TRUE` ke saath `AND (commission_pct IS NULL OR manager_id IS NULL)` lagayenge. Dono missing fields ko pakadne ke liye `OR` ko brackets mein band karenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar tum `(commission_pct IS NULL OR manager_id IS NULL)` ke aage-peeche ka bracket hata do, toh result par kya asar padega?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "Sir, SQL mein `AND` pehle chalta hai aur `OR` baad mein. Agar bracket hata diya, toh aisa koi bhi sales rep aa jayega jiska manager NULL ho — chahe uski salary 5,000 hi kyu na ho aur chahe wo inactive ho chuka ho! Isliye dono condition ko combine karne ke liye bracket lagana compulsory hai."

---

### 🔹 Q006: Doctor Priority Sorting (`ORDER BY` Multi-column)

* **Code:**
  ```sql
  SELECT appointment_id, patient_name, doctor_id, priority_score, appointment_time 
  FROM patient_appointments 
  WHERE status = 'Waiting' 
  ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC;
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Hospital OPD mein waiting patients ki line lagani hai. Pehle doctor ke hisab se group ho, fir sabse emergency (high priority) patient pehle dekha jaye, aur agar do logon ki priority barabar ho toh jo pehle aaya wo pehle jaye."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum `WHERE status = 'Waiting'` lagayenge, aur sorting mein teen cheezein denge: `ORDER BY doctor_id ASC, priority_score DESC, appointment_time ASC`. Isse doctor-wise high score pehle aayega, aur tie hone par purana appointment pehle."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar main `ORDER BY doctor_id, priority_score, appointment_time` likh doon bina ASC/DESC lagaye, toh kya hoga?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "Sir, SQL by default sabko `ASC` (chhote se bada) maan leta hai. Toh emergency patient (score 10 wala) sabse aakhri mein chala jayega aur normal sardi-zukham (score 1 wala) pehle aa jayega. Isliye priority ke aage `DESC` likhna mandatory hai."

---

### 🔹 Q007: Top 3 Songs (`LIMIT` / `TOP`)

* **Code:**
  ```sql
  SELECT song_id, title, artist, total_streams 
  FROM songs 
  WHERE release_year >= 2023 
  ORDER BY total_streams DESC 
  LIMIT 3;
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Music app ke billboard banner ke liye 2023 ya uske baad release hue sabse zyada sune gaye top 3 gaane nikaal kar do."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, pehle `WHERE release_year >= 2023` se naye gaane filter karenge, fir unhe streams ke hisab se bade se chhota sort karenge `ORDER BY total_streams DESC`, aur aakhri mein `LIMIT 3` laga kar top 3 utha lenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar 3rd aur 4th number ke gaane ke streams bilkul barabar hon (tie ho), toh `LIMIT 3` kisko dikhayega? Aur SQL Server mein ye kaise likhoge?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "`LIMIT 3` bina kisi rule ke koi bhi ek utha lega sir, jo business ke hisab se unfair ho sakta hai. Production mein tie handle karne ke liye hum aage gaane ka ID ya release date laga dete hain, ya `DENSE_RANK()` use karte hain.
  Aur SQL Server / MS Access mein `LIMIT` nahi chalta, wahan `SELECT TOP 3` likhte hain."

---

### 🔹 Q008: Second Highest Price (`DISTINCT`, `OFFSET`)

* **Code:**
  ```sql
  SELECT DISTINCT price 
  FROM properties 
  WHERE city = 'Bangalore' 
  ORDER BY price DESC 
  LIMIT 1 OFFSET 1;
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "Real-estate portal par Bangalore city ke andar sabse mehenge flat ke baad jo doosra sabse mehenga price hai wo pata karna hai."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum duplicate prices hatayenge `SELECT DISTINCT price`, Bangalore filter karenge, price ko descending sort karenge, aur `LIMIT 1 OFFSET 1` laga kar pehle ko skip karke doosra utha lenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar do alag-alag properties ka price same ho (jaise top dono 1.50 Crore ki hon), aur tumne `DISTINCT` na lagaya ho toh kya output aayega?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "Sir, agar `DISTINCT` nahi lagaya toh 1.50 Crore hi do baar aa jayega, aur `OFFSET 1` doosre number pe bhi 1.50 Crore hi utha lega — jabki hume second highest price chahiye tha. Isliye duplicate price hatane ke liye `DISTINCT` lagana compulsory hai."

---

### 🔹 Q009: Net Revenue & Profit (`Calculated Columns`, Integer Division)

* **Code:**
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

* **Interviewer kaise puchega (Business Scenario)?**
  "E-commerce business mein completed orders par actual paisa kitna aaya (discount ke baad) aur kitna munafa (profit) hua, ye calculate karke do. Sabse zyada profit wale items top par aane chahiye."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum Completed orders filter karenge. Revenue ke liye `(unit_price * quantity) * (1 - discount_pct / 100.0)` karenge, aur Profit ke liye us Revenue mein se total cost `(cost_price * quantity)` minus karke `ORDER BY profit DESC` kar denge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar discount 10% hai aur tumne `discount / 100` likha (bina `.0` ke), toh kai databases mein kya gadbad ho sakti hai?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "Sir, kai databases mein do integer numbers ko divide karne par answer bhi integer ban jata hai. Jaise $10 / 100 = 0.1$ hone ki jagah $0$ ban jayega! Isse discount zero count ho jayega aur company ka revenue galat calculate hoga. Isliye hamesha decimal (`100.0`) se divide karte hain."

---

### 🔹 Q010: Loan EMI & Interest (`ROUND`, `CEIL` Rounding)

* **Code:**
  ```sql
  SELECT 
      loan_id, 
      borrower_name, 
      ROUND(principal_amount * (annual_rate / (12 * 100.0)) * tenure_months, 2) AS total_interest, 
      ROUND(principal_amount * (1 + (annual_rate / (12 * 100.0)) * tenure_months), 2) AS total_repayment, 
      CEIL(ROUND(principal_amount * (1 + (annual_rate / (12 * 100.0)) * tenure_months), 2) / tenure_months) AS monthly_emi 
  FROM loan_application 
  WHERE loan_status = 'Approved' 
  ORDER BY monthly_emi;
  ```

* **Interviewer kaise puchega (Business Scenario)?**
  "FinTech loan app ke liye approved loans ka total interest, total repayment, aur monthly EMI calculate karni hai, jisme customer se paise round-off karke aage wale poore rupaye mein lene hain."

* **Hume kya jawab dena hai (Normal Bol-chaal me)?**
  "Sir, hum simple interest formula use karenge. 2 decimal places tak paison ko sahi rakhne ke liye `ROUND(..., 2)` karenge, aur monthly EMI ke liye total repayment ko tenure se divide karke `CEIL(...)` lagayenge taaki 1 paisa bhi kam na kate."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"`ROUND()` aur `CEIL()` mein kya fark hai? EMI mein `ROUND()` kyu nahi lagaya?"*

* **🛡️ Trap ka Counter-Jawab (Human Language me):**
  "`ROUND()` nearest number dekhta hai (agar .50 se kam ho toh piche, zyada ho toh aage). Lekin bank aur loan mein agar ₹10,416.20 ki EMI bani aur humne use ₹10,416 round kar diya, toh aakhri mein bank ka 20-30 paisa loss ho jayega.
  `CEIL()` hamesha upar ke agle rupaye pe le jata hai (jaise ₹10,416.20 ko seedha ₹10,417 kar dega), jisse bank ka recovery target poora rehta hai."
