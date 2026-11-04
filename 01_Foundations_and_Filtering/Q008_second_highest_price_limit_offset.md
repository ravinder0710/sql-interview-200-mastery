# Q008: Nth Highest Value via Pagination (`LIMIT 1 OFFSET N-1` + `DISTINCT`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 008 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Real estate analytics platform Bangalore city ke residential listings mein market benchmarking ke liye second highest property price find karna chahta hai (outlier / luxury penthouses ko exclude karke realistic top benchmark lene ke liye)."

---

## 📊 Sample Mock Table (`properties`)

| property_id | property_title | city | price | bhk |
| :--- | :--- | :--- | :--- | :--- |
| 101 | Prestige Villa | Bangalore | 45000000.00 | 4 |
| 102 | Sobha Penthouse | Bangalore | 45000000.00 | 4 |
| 103 | Brigade Heights | Bangalore | 28000000.00 | 3 |
| 104 | Godrej Woods | Bangalore | 19500000.00 | 2 |
| 105 | Puravankara Flat | Mumbai | 32000000.00 | 3 |
| 106 | Salarpuria Bliss | Bangalore | 15000000.00 | 2 |

---

## 🎯 Expected Output Table

| second_highest_price |
| :--- |
| 28000000.00 |

---

## 💡 Production SQL Solution

```sql
SELECT DISTINCT price AS second_highest_price 
FROM properties 
WHERE city = 'Bangalore' 
ORDER BY price DESC 
LIMIT 1 OFFSET 1;
```

---

## ⚙️ Execution Logic (Saral Bhasha Me)
General Nth value formula hota hai: $\mathbf{LIMIT \ 1 \ OFFSET \ (N - 1)}$. 2nd highest ke liye pehla record skip kiya (`OFFSET 1`) aur agla 1 record utha liya (`LIMIT 1`). `DISTINCT` duplicates ko pehle merge karta hai.

---

## ⚠️ Interviewer Trap Question
*"Agar table mein Top 2 properties ka price exact barabar (jaise dono 4.5 Cr) ho, aur tumne `DISTINCT` nahi lagaya toh kya output aayega? Aur agar table mein Bangalore city ka sirf 1 hi flat ho, toh `LIMIT 1 OFFSET 1` kya return karega?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, agar `DISTINCT` nahi lagaya toh top rank par dono duplicate records honge, aur `OFFSET 1` skip karne par wo wapas 4.5 Cr hi return karega, jo ki actual second highest price nahi balki highest price ka duplicate hoga. Isliye `DISTINCT` lagana compulsory hai.*  
> *Doosra trap: agar table mein sirf 1 hi record ho, toh `LIMIT 1 OFFSET 1` empty set (0 rows) return karta hai. Par LeetCode aur enterprise standard interview mein unhe single row with `NULL` chahiye hota hai. Uske liye hum query ko outer scalar SELECT mein wrap karte hain:*  
> `SELECT (SELECT DISTINCT price FROM properties WHERE city = 'Bangalore' ORDER BY price DESC LIMIT 1 OFFSET 1) AS second_highest_price;`*  
> *Isse agar koi record nahi hoga toh automatically single row NULL return hogi."*
