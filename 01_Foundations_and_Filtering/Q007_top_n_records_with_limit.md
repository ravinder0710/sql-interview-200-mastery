# Q007: Top-N Truncation & Dialect Variations (LIMIT, TOP, FETCH FIRST)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 007 / 150
- **Company Tag:** Spotify / Netflix / YouTube Content Leaderboards
- **Target Role:** Data Analyst (0 — 2 Years Experience)

---

## 🏢 Business Scenario
A music streaming platform needs to populate its homepage hero banner with the Top 3 most-streamed songs released in or after the year 2023 (`release_year >= 2023`). 

Display song ID, title, artist, and total streams, ordered from highest stream count to lowest.

---

## 📊 Sample Mock Table (`songs`)

| song_id | title | artist | release_year | total_streams |
| :--- | :--- | :--- | :--- | :--- |
| 701 | Kesariya | Arijit Singh | 2022 | 850000000 |
| 702 | Chaleya | Arijit Singh | 2023 | 520000000 |
| 703 | Heeriye | Jasleen Royal | 2023 | 610000000 |
| 704 | Husn | Anuv Jain | 2023 | 430000000 |
| 705 | Tauba Tauba | Karan Aujla | 2024 | 480000000 |
| 706 | Pasoori | Ali Sethi | 2022 | 720000000 |
| 707 | O Maahi | Arijit Singh | 2023 | 390000000 |

---

## 🎯 Expected Output Table

| song_id | title | artist | total_streams |
| :--- | :--- | :--- | :--- |
| 703 | Heeriye | Jasleen Royal | 610000000 |
| 702 | Chaleya | Arijit Singh | 520000000 |
| 705 | Tauba Tauba | Karan Aujla | 480000000 |

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

## 🧠 Interview Defense & Technical Takeaways

1. **Dialect Portability**:
   - PostgreSQL/MySQL/SQLite: `LIMIT n`
   - SQL Server (T-SQL): `SELECT TOP n ...`
   - Oracle / ANSI Standard: `OFFSET 0 ROWS FETCH NEXT n ROWS ONLY`

2. **The Ties Hazard**:
   - `LIMIT n` truncates rows without tie awareness. If row n and row n+1 share identical values, one is omitted non-deterministically unless `WITH TIES` (SQL Server) or analytical window ranking (`DENSE_RANK()`) is utilized.

3. **Top-N Optimizer Heapsort**:
   - Backed by an index on `(release_year, total_streams DESC)`, the query engine executes an optimized Top-N heapsort, halting execution as soon as 3 matching rows are collected without sorting the entire table.
