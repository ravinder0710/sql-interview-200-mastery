# Q007: Top 3 Songs (`LIMIT` / `TOP`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 007 / 200
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario (Interviewer ki Zubaan Me)
"Music app ke billboard banner ke liye 2023 ya uske baad release hue sabse zyada sune gaye top 3 gaane nikaal kar do."

---

## 📊 Sample Mock Table (`songs`)

| song_id | title | artist | release_year | total_streams |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Kesariya | Arijit Singh | 2022 | 450000000 |
| 2 | Chaleya | Arijit Singh | 2023 | 380000000 |
| 3 | Apna Bana Le | Arijit Singh | 2022 | 310000000 |
| 4 | Heeriye | Jasleen Royal | 2023 | 290000000 |
| 5 | Satranga | Arijit Singh | 2023 | 240000000 |
| 6 | Arjan Vailly | Bhupinder Babbal | 2023 | 190000000 |
| 7 | O Maahi | Arijit Singh | 2024 | 180000000 |

---

## 🎯 Expected Output Table

| song_id | title | artist | total_streams |
| :--- | :--- | :--- | :--- |
| 2 | Chaleya | Arijit Singh | 380000000 |
| 4 | Heeriye | Jasleen Royal | 290000000 |
| 5 | Satranga | Arijit Singh | 240000000 |

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

## 🗣️ Human Language Interview Defense & Traps

* **Hume normal zubaan me kya bolna hai?**
  "Sir, pehle `WHERE release_year >= 2023` se naye gaane filter karenge, fir unhe streams ke hisab se bade se chhota sort karenge `ORDER BY total_streams DESC`, aur aakhri mein `LIMIT 3` laga kar top 3 utha lenge."

* **⚠️ Interviewer ka Trap / Cross-Question:**
  *"Agar 3rd aur 4th number ke gaane ke streams bilkul barabar hon (tie ho), toh `LIMIT 3` kisko dikhayega? Aur SQL Server mein ye kaise likhoge?"*

* **🛡️ Trap ka Counter-Jawab:**
  "`LIMIT 3` bina kisi rule ke koi bhi ek utha lega sir, jo business ke hisab se unfair ho sakta hai. Production mein tie handle karne ke liye hum aage gaane ka ID ya release date laga dete hain, ya `DENSE_RANK()` use karte hain.
  Aur SQL Server / MS Access mein `LIMIT` nahi chalta, wahan `SELECT TOP 3` likhte hain."
