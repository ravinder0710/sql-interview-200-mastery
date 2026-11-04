# Q007: Top-N Truncation & Dialects (`LIMIT`, `TOP`, `FETCH FIRST`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 007 / 200
- **Company Tag:** Spotify, Netflix, YouTube
- **Target Role:** Data Analyst / SQL Developer (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A music streaming platform's analytics engineering team is building a curated homepage spotlight banner. The banner features the Top 3 most-streamed viral tracks released in the year 2023 or later (`release_year >= 2023`), ranked strictly by total lifetime streams in descending order.

---

## 📊 Sample Mock Table (`songs`)

| song_id | title | artist | release_year | total_streams |
| :---: | :--- | :--- | :---: | :---: |
| 1 | Kesariya | Arijit Singh | 2022 | 850000000 |
| 2 | Chaleya | Arijit Singh | 2023 | 620000000 |
| 3 | Heeriye | Jasleen Royal | 2023 | 540000000 |
| 4 | Apna Bana Le | Arijit Singh | 2022 | 710000000 |
| 5 | Maan Meri Jaan | King | 2023 | 490000000 |
| 6 | Jawan Title | Anirudh | 2023 | 310000000 |

---

## 🎯 Expected Output Table

| song_id | title | artist | total_streams |
| :---: | :--- | :--- | :---: |
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

## ⚙️ Execution Logic & Query Lifecycle
1. **Filter**: Isolates records meeting `release_year >= 2023`.
2. **Order**: Ranks rows using in-memory Top-N Priority Heapsort.
3. **Truncate**: Emits the first 3 records immediately upon reaching the limit threshold.

---

## ⚠️ Common Interview Traps & Edge Cases
1. **The Non-Deterministic Tie Hazard**:
   - If the 3rd and 4th songs share identical total stream counts, `LIMIT 3` drops one record arbitrarily without notice.
   - When business logic requires including ties, use `TOP 3 WITH TIES` in T-SQL or window ranking functions (`DENSE_RANK()`) in ANSI SQL.
2. **Dialect Compatibility Across RDBMS**:
   - **PostgreSQL / MySQL / SQLite**: `LIMIT 3`
   - **SQL Server (T-SQL)**: `SELECT TOP 3 ...`
   - **Oracle / ANSI SQL:2008**: `OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY`

---

## 💬 Candidate's Defense (1–2 Years Experience Style)
> *"When backed by an index on the sort key, `LIMIT` enables a fast Top-N heapsort without sorting the full physical dataset. However, because standard `LIMIT` truncates ties arbitrarily, enterprise production pipelines handling rankings typically leverage analytical window functions like `DENSE_RANK()` to ensure deterministic fairness."*
