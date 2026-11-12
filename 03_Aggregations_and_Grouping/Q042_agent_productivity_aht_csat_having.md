# Q042: Call Center Agent Productivity & AHT SLA (`AVG`, `HAVING`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q042 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Operations & BPO BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In global customer support organizations, call center operations, and technical helpdesks (e.g., Amazon Customer Service, Teleperformance, Concentrix, Zendesk), agent performance is audited against stringent multi-dimensional **Service Level Agreements (SLAs)**.

Two foundational operational metrics dictate monthly performance bonuses:
1. **Average Handling Time (AHT)**: Measured in seconds, capturing the efficiency with which an agent resolves customer inquiries without keeping callers waiting.
2. **Customer Satisfaction Score (CSAT)**: A numeric customer rating (1.0 to 5.0) reflecting resolution quality.

High performers must demonstrate both speed and customer satisfaction across a meaningful sample size of handled interactions. Abandoned or disconnected calls (`call_status = 'Abandoned'`) reflect system or network drops and must be excluded from operational throughput metrics.

The Workforce Management (WFM) team requires an audited performance extract where:
1. Only successfully completed calls are evaluated (`call_status = 'Completed'`).
2. The agent handled at least 3 completed calls (`total_handled_calls >= 3`).
3. Average handling time does not exceed 300.00 seconds (`avg_handling_time_sec <= 300.00`).
4. Average CSAT rating meets or exceeds 4.00 (`avg_csat_score >= 4.00`).
5. All averages are rounded to 2 decimal places.
6. Sorted by `avg_csat_score DESC, avg_handling_time_sec ASC, agent_id ASC`.

---

## 📊 Sample Mock Table: `support_call_logs`

| call_id | agent_id | agent_name | call_duration_seconds | call_status | customer_rating |
|:---:|:---:|:---:|:---:|:---:|:---:|
| C101 | AG_01 | Rahul Sen | 240 | Completed | 5.0 |
| C102 | AG_01 | Rahul Sen | 280 | Completed | 4.0 |
| C103 | AG_01 | Rahul Sen | 260 | Completed | 5.0 |
| C104 | AG_02 | Priya Das | 420 | Completed | 4.5 |
| C105 | AG_02 | Priya Das | 380 | Completed | 4.0 |
| C106 | AG_02 | Priya Das | 150 | Abandoned | 1.0 |
| C107 | AG_03 | Amit Roy | 210 | Completed | 4.0 |
| C108 | AG_03 | Amit Roy | 190 | Completed | 4.5 |
| C109 | AG_03 | Amit Roy | 230 | Completed | 4.2 |
| C110 | AG_04 | Sneha Jha | 200 | Completed | 3.5 |
| C111 | AG_04 | Sneha Jha | 220 | Completed | 3.8 |
| C112 | AG_04 | Sneha Jha | 210 | Completed | 3.6 |

---

## 🎯 Expected Output Table

| agent_id | agent_name | total_handled_calls | avg_handling_time_sec | avg_csat_score |
|:---:|:---:|:---:|:---:|:---:|
| AG_01 | Rahul Sen | 3 | 260.00 | 4.67 |
| AG_03 | Amit Roy | 3 | 210.00 | 4.23 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    agent_id, 
    agent_name, 
    COUNT(call_id) AS total_handled_calls, 
    ROUND(AVG(call_duration_seconds), 2) AS avg_handling_time_sec, 
    ROUND(AVG(customer_rating), 2) AS avg_csat_score 
FROM support_call_logs 
WHERE call_status = 'Completed' 
GROUP BY agent_id, agent_name 
HAVING COUNT(call_id) >= 3 
   AND AVG(call_duration_seconds) <= 300.00 
   AND AVG(customer_rating) >= 4.00 
ORDER BY avg_csat_score DESC, avg_handling_time_sec ASC, agent_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Multi-Condition `HAVING` Predicates
- SQL supports compound boolean logic (`AND`, `OR`) across multiple independent aggregate functions inside `HAVING`.
- Placing `COUNT(call_id) >= 3`, `AVG(...) <= 300.00`, and `AVG(...) >= 4.00` in `HAVING` filters the summary partitions across multiple operational dimensions in a single query pass.

### 2. SQL Server (T-SQL) Integer Division Hazards
- While MySQL natively produces floating-point quotients for `AVG(int_col)`, **Microsoft SQL Server (T-SQL)** preserves integer division rules, truncating fractional values:
  $$\text{AVG}(240 + 281) = \text{AVG}(521) / 2 \implies 260 \text{ (not 260.5)}$$
- **Enterprise Portable Formulation**:
  ```sql
  ROUND(AVG(call_duration_seconds * 1.0), 2) AS avg_handling_time_sec
  ```

### 3. Missing CSAT Feedback & The NULL Trap
- `AVG(customer_rating)` ignores records where customers declined to leave feedback (`customer_rating IS NULL`).
- If corporate policy mandates treating unrated calls as neutral (3.0) or zero, the expression must explicitly impute missing values:
  ```sql
  AVG(COALESCE(customer_rating, 0))
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Abandoned Call Filter in `HAVING` vs `WHERE`
- **Interviewer Query:** *"Why not group all calls and filter abandoned records in `HAVING`?"*
- **Candidate Defense:**
  > *"Filtering in `WHERE` prunes non-qualifying calls prior to hashing, reducing memory consumption and preventing dropped calls from diluting agent AHT calculations. Furthermore, a B-Tree index on `call_status` allows index seek filtering before grouping begins."*

### Trap 2: SARGable Composite Indexing
- **Interviewer Query:** *"How would you index this table to optimize this report for millions of monthly call records?"*
- **Candidate Defense:**
  > *"A composite index on `(call_status, agent_id, agent_name, call_duration_seconds, customer_rating, call_id)` creates a covering index. The query filters on `call_status = 'Completed'` via index seek, aggregates `duration` and `rating` directly from index leaves, and completely avoids heap/table lookups."*
