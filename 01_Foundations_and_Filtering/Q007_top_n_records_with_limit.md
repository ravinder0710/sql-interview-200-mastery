# Q007: Top-N Truncation & Dialects (`LIMIT`, `TOP`, `FETCH FIRST`)

## 📌 Metadata
- **Module:** Block 01: Foundations & Data Filtering
- **Question Number:** 007 / 200
- **Difficulty:** Basic
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

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

## 🎯 Expected Output

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

## 🧠 Interview Defense & Technical Takeaways

1. **Top-N Priority Heapsort Optimization:**
   - When `ORDER BY` is paired with `LIMIT n` and backed by an index, the database engine does not sort the entire table in memory. It maintains a bounded priority queue (heap) of size $n$, yielding near-instantaneous execution.

2. **Cross-Dialect Syntax Standards:**
   - **PostgreSQL / MySQL / SQLite**: `LIMIT 3`
   - **SQL Server (T-SQL)**: `SELECT TOP 3 ...`
   - **Oracle & ANSI SQL:2008**: `OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY`

3. **Execution Order of `LIMIT`:**
   - `LIMIT` executes as the final step in query lifecycle:
     $$\mathbf{FROM} \longrightarrow \mathbf{WHERE} \longrightarrow \mathbf{SELECT} \longrightarrow \mathbf{ORDER\ BY} \longrightarrow \mathbf{LIMIT}$$

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Non-Deterministic Tie Truncation:**
   - *Interviewer:* "What if the 3rd and 4th songs have identical streams? Which one does `LIMIT 3` return?"
   - *Defense:* Standard `LIMIT` breaks ties non-deterministically. To include all tied contenders in standard ANSI SQL, we utilize window ranking functions such as `DENSE_RANK()`, or in SQL Server we use `TOP 3 WITH TIES`.

2. **Trap: Omitting `ORDER BY`:**
   - *Interviewer:* "What happens if you run `SELECT * FROM songs LIMIT 3` without an `ORDER BY`?"
   - *Defense:* Relational databases treat tables as unordered mathematical sets. Without `ORDER BY`, the returned rows are non-deterministic and can vary on every execution depending on storage fragmentation or parallel scan order.
