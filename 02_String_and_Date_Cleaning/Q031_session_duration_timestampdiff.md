# Q031: User Session Duration & Engagement Time (`TIMESTAMPDIFF`)

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q031 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Product Analytics Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL (`TIMESTAMPDIFF`), PostgreSQL (`EXTRACT(EPOCH FROM ...)`), Snowflake (`DATEDIFF`), SQL Server (`DATEDIFF`)

---

## 🏢 Business Scenario
In digital entertainment, mobile gaming, and streaming media (e.g., Dream11, Chess.com, Disney+ Hotstar, Twitch), user session duration is a foundational North Star metric for measuring user engagement, feature stickiness, and daily active screen-time.

Session timestamps (`login_time` and `logout_time`) are recorded in application telemetry logs. Product analytics and trust-and-safety engineering teams frequently analyze long-running sessions to identify active gamers and detect abnormal bot-like screen-time patterns.

The Product Analytics team requires an audited extract of ended mobile/tablet sessions where:
1. The session is closed (`session_status = 'Ended'`).
2. The user accessed the service via handheld form factors (`device_type IN ('Mobile', 'Tablet')`).
3. Total active engagement spans at least 30 minutes (`duration_minutes >= 30`).
4. Output displays both login/logout timestamps alongside the derived integer `duration_minutes`.
5. Sorted by `duration_minutes DESC, session_id ASC`.

---

## 📊 Sample Mock Table: `user_game_sessions`

| session_id | user_id | login_time | logout_time | session_status | device_type |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 1001 | USER_901 | 2024-03-10 14:00:00 | 2024-03-10 14:45:00 | Ended | Mobile |
| 1002 | USER_902 | 2024-03-10 15:10:00 | 2024-03-10 15:22:00 | Ended | Mobile |
| 1003 | USER_903 | 2024-03-10 16:00:00 | 2024-03-10 17:30:00 | Ended | Desktop |
| 1004 | USER_904 | 2024-03-10 18:00:00 | 2024-03-10 19:15:00 | Ended | Tablet |
| 1005 | USER_905 | 2024-03-10 20:00:00 | NULL | Active | Mobile |
| 1006 | USER_906 | 2024-03-10 21:00:00 | 2024-03-10 21:30:00 | Ended | Mobile |

---

## 🎯 Expected Output Table

| session_id | user_id | login_time | logout_time | duration_minutes | device_type |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 1004 | USER_904 | 2024-03-10 18:00:00 | 2024-03-10 19:15:00 | 75 | Tablet |
| 1001 | USER_901 | 2024-03-10 14:00:00 | 2024-03-10 14:45:00 | 45 | Mobile |
| 1006 | USER_906 | 2024-03-10 21:00:00 | 2024-03-10 21:30:00 | 30 | Mobile |

---

## 💡 Production SQL Solution

```sql
SELECT 
    session_id, 
    user_id, 
    login_time, 
    logout_time, 
    TIMESTAMPDIFF(MINUTE, login_time, logout_time) AS duration_minutes, 
    device_type 
FROM user_game_sessions 
WHERE session_status = 'Ended' 
  AND device_type IN ('Mobile', 'Tablet') 
  AND TIMESTAMPDIFF(MINUTE, login_time, logout_time) >= 30 
ORDER BY duration_minutes DESC, session_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. `TIMESTAMPDIFF(unit, start, end)` Mechanics
- In MySQL, `TIMESTAMPDIFF` calculates the integer number of intervals between `start` and `end` timestamps.
- **Order of Parameters:** Unlike `DATEDIFF(end, start)`, `TIMESTAMPDIFF` expects `(unit, start_datetime, end_datetime)`. Reversing timestamps returns a negative integer.

### 2. SQL Logical Processing Order & The Alias Trap
- Candidate cannot write `WHERE duration_minutes >= 30` directly in the query.
- **SQL Execution Sequence:**
  $$\text{FROM} \longrightarrow \text{WHERE} \longrightarrow \text{GROUP BY} \longrightarrow \text{HAVING} \longrightarrow \text{SELECT} \longrightarrow \text{ORDER BY}$$
- Because `WHERE` evaluates prior to `SELECT`, column aliases generated in `SELECT` are unavailable in `WHERE`. However, `ORDER BY` executes after `SELECT`, permitting `duration_minutes DESC`.

### 3. Cross-Dialect Equivalents
- **PostgreSQL / Amazon Redshift**:
  ```sql
  ROUND(EXTRACT(EPOCH FROM (logout_time - login_time)) / 60) AS duration_minutes
  ```
- **Snowflake & SQL Server (T-SQL)**:
  ```sql
  DATEDIFF(minute, login_time, logout_time) AS duration_minutes
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: `TIMEDIFF` vs `TIMESTAMPDIFF`
- **Interviewer Query:** *"Why not use `TIMEDIFF(logout_time, login_time)` instead of `TIMESTAMPDIFF`?"*
- **Candidate Defense:**
  > *"`TIMEDIFF` returns a `TIME` string representation (`'01:15:00'`) rather than a scalar integer. Attempting mathematical or range comparisons like `>= 30` on `TIMEDIFF` introduces implicit string comparison hazards. Additionally, `TIMEDIFF` is constrained to an upper boundary of 838 hours, whereas `TIMESTAMPDIFF` handles unbounded intervals across years."*

### Trap 2: Active / In-Flight Sessions with NULL `logout_time`
- **Interviewer Query:** *"How would you calculate live duration for currently active sessions where `logout_time` is NULL?"*
- **Candidate Defense:**
  > *"We apply fallback imputation using `COALESCE(logout_time, NOW())`:
  > ```sql
  > TIMESTAMPDIFF(MINUTE, login_time, COALESCE(logout_time, NOW())) AS duration_minutes
  > ```
  > This dynamically computes the in-flight elapsed time up to the exact moment of query execution without returning NULL."*
