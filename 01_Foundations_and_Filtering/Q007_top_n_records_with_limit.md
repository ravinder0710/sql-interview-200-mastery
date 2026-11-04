# Q007: Top-N Truncation & Dialects (`LIMIT`, `TOP`, `FETCH FIRST`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 007 / 200
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer Context)
"Music streaming app analytics dashboard par year 2023 ya uske baad release hue Top 3 highest-streamed viral tracks ko banner display ke liye extract karna hai."

---

## 📊 Sample Mock Table (`songs`)

| song_id | title | artist | release_year | total_streams |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Kesariya | Arijit Singh | 2022 | 850000000 |
| 2 | Chaleya | Arijit Singh | 2023 | 620000000 |
| 3 | Heeriye | Jasleen Royal | 2023 | 540000000 |
| 4 | Apna Bana Le | Arijit Singh | 2022 | 710000000 |
| 5 | Maan Meri Jaan | King | 2023 | 490000000 |
| 6 | Jawan Title | Anirudh | 2023 | 310000000 |

---

## 🎯 Expected Output Table

| song_id | title | artist | total_streams |
| :--- | :--- | :--- | :--- |
| 2 | Chaleya | Arijit Singh | 620000000 |
| 3 | Heeriye | Jasleen Royal | 540000000 |
| 5 | Maan Meri Jaan | King | 490000000 |

---

## 💡 Production SQL Solution

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

---

## ⚙️ Execution Logic (Saral Bhasha Me)
Data pehle `release_year >= 2023` par filter hota hai, phir `ORDER BY total_streams DESC` ke zariye highest streams ke basis par sort hota hai, aur aakhri stage par `LIMIT 3` top 3 rows ko cut kar leta hai.

---

## ⚠️ Interviewer Trap Question
*"Agar 3rd aur 4th song ke total streams exact barabar (tie) ho gaye, toh `LIMIT 3` kya karega? Aur agar company SQL Server ya Oracle use kar rahi ho toh yeh query kaise likhoge?"*

---

## 💬 Candidate ka Perfect Jabab (1-2 Yrs Experience Style)
> *"Sir, `LIMIT 3` ties ko consider nahi karta, wo arbitrarily kisi ek record ko pick karega aur doosre tied song ko drop kar dega. Agar business chahti hai ki ties include hon, toh SQL Server mein `SELECT TOP 3 WITH TIES` use hota hai, aur standard ANSI SQL mein hum `DENSE_RANK()` window function use karte hain.*  
> *Rahi baat alag databases ki: MySQL/PostgreSQL mein `LIMIT 3`, SQL Server (T-SQL) mein `SELECT TOP 3 ...`, aur Oracle / ANSI SQL:2008 mein standard syntax `OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY` likha jata hai."*
