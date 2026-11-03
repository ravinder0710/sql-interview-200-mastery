/*
===============================================================================
Question ID: Q007
Category: 01_Basic / 01_Basic_Easy
Topic: Top-N Truncation (LIMIT / TOP / FETCH FIRST) and Dialect Variations
Difficulty: Easy
SQL Standard: ANSI SQL & Dialect Specific (PostgreSQL, MySQL, SQL Server)
===============================================================================

PROBLEM STATEMENT:
A music streaming analytics team wants to feature the Top 3 most-streamed songs 
released in or after the year 2023 (release_year >= 2023). 
Display song ID, title, artist, and total streams, ordered from highest to lowest.

TABLE SCHEMA:
songs (
    song_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    artist VARCHAR(100) NOT NULL,
    release_year INT NOT NULL,
    total_streams BIGINT NOT NULL
);

SAMPLE DATA:
INSERT INTO songs (song_id, title, artist, release_year, total_streams) VALUES
(701, 'Kesariya',    'Arijit Singh', 2022, 850000000),
(702, 'Chaleya',     'Arijit Singh', 2023, 520000000),
(703, 'Heeriye',     'Jasleen Royal',2023, 610000000),
(704, 'Husn',        'Anuv Jain',    2023, 430000000),
(705, 'Tauba Tauba', 'Karan Aujla',  2024, 480000000),
(706, 'Pasoori',     'Ali Sethi',    2022, 720000000),
(707, 'O Maahi',     'Arijit Singh', 2023, 390000000);

EXPECTED OUTPUT:
song_id | title       | artist        | total_streams
--------+-------------+---------------+--------------
703     | Heeriye     | Jasleen Royal | 610000000
702     | Chaleya     | Arijit Singh  | 520000000
705     | Tauba Tauba | Karan Aujla   | 480000000
===============================================================================
*/

-- 🚀 SOLUTION (PostgreSQL / MySQL / SQLite):
SELECT 
    song_id, 
    title, 
    artist, 
    total_streams 
FROM songs 
WHERE release_year >= 2023 
ORDER BY total_streams DESC 
LIMIT 3;

-- 💡 ALTERNATIVE SYNTAX (SQL Server / T-SQL):
-- SELECT TOP 3 song_id, title, artist, total_streams 
-- FROM songs WHERE release_year >= 2023 ORDER BY total_streams DESC;

-- 💡 ALTERNATIVE SYNTAX (Oracle 12c+ / ANSI SQL:2008):
-- SELECT song_id, title, artist, total_streams 
-- FROM songs WHERE release_year >= 2023 ORDER BY total_streams DESC 
-- FETCH FIRST 3 ROWS ONLY;

/*
===============================================================================
INTERVIEW & PERFORMANCE NOTES:
1. Dialect Portability:
   - PostgreSQL/MySQL/SQLite: `LIMIT n`
   - SQL Server: `SELECT TOP n ...` (or `TOP n WITH TIES`)
   - Oracle / ANSI Standard: `OFFSET 0 ROWS FETCH NEXT n ROWS ONLY`

2. The Ties Problem:
   `LIMIT n` blindly truncates at row n. If row n and row n+1 share identical values, 
   one is dropped non-deterministically unless `WITH TIES` or window ranking is used.

3. Optimizer Execution:
   `LIMIT` is evaluated as the final step after `ORDER BY`. With an index on 
   `(release_year, total_streams DESC)`, the engine can execute an Index Scan 
   and stop early after encountering 3 qualifying rows (Top-N Heapsort).
===============================================================================
*/
