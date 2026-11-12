# Q035: Business Working Days SLA Calculation (Excluding Weekends)

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q035 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Operations BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server

---

## 🏢 Business Scenario
In enterprise B2B support desks, freight delivery networks, and IT Service Management platforms (e.g., Blue Dart B2B, Delhivery, ServiceNow, Jira Service Management), contractual **Service Level Agreements (SLAs)** govern ticket resolution and delivery turnaround times.

Contractual SLAs strictly exclude non-working weekend days (Saturdays and Sundays) when computing elapsed turnaround times. Relying solely on raw calendar days (`DATEDIFF`) artificially penalizes operational teams for weekend backlog buildup.

Operations leadership requires an SLA audit report of closed enterprise tickets where:
1. `resolution_status = 'Closed'`.
2. Priority is high-impact (`ticket_priority IN ('Critical', 'High')`).
3. Turnaround spans at least 3 business working days (`business_working_days >= 3`), where weekend days are mathematically deducted.
4. Output displays both total `calendar_days` and `business_working_days`.
5. Sorted by `business_working_days DESC, ticket_id ASC`.

---

## 📊 Sample Mock Table: `b2b_support_tickets`

| ticket_id | client_id | created_date | resolved_date | ticket_priority | resolution_status |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 6001 | CL_101 | 2024-03-01 | 2024-03-08 | Critical | Closed |
| 6002 | CL_102 | 2024-03-04 | 2024-03-06 | High | Closed |
| 6003 | CL_103 | 2024-03-01 | 2024-03-05 | Medium | Closed |
| 6004 | CL_104 | 2024-03-08 | 2024-03-15 | Critical | Closed |
| 6005 | CL_105 | 2024-03-11 | 2024-03-18 | High | Closed |
| 6006 | CL_106 | 2024-03-12 | 2024-03-14 | Critical | In Progress |

---

## 🎯 Expected Output Table

| ticket_id | client_id | created_date | resolved_date | calendar_days | business_working_days | ticket_priority |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 6001 | CL_101 | 2024-03-01 | 2024-03-08 | 7 | 5 | Critical |
| 6004 | CL_104 | 2024-03-08 | 2024-03-15 | 7 | 5 | Critical |
| 6005 | CL_105 | 2024-03-11 | 2024-03-18 | 7 | 5 | High |

---

## 💡 Production SQL Solution

```sql
SELECT 
    ticket_id, 
    client_id, 
    created_date, 
    resolved_date, 
    DATEDIFF(resolved_date, created_date) AS calendar_days, 
    DATEDIFF(resolved_date, created_date) - (FLOOR(DATEDIFF(resolved_date, created_date) / 7) * 2) AS business_working_days, 
    ticket_priority 
FROM b2b_support_tickets 
WHERE resolution_status = 'Closed' 
  AND ticket_priority IN ('Critical', 'High') 
  AND DATEDIFF(resolved_date, created_date) - (FLOOR(DATEDIFF(resolved_date, created_date) / 7) * 2) >= 3 
ORDER BY business_working_days DESC, ticket_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Mathematical Weekend Deduction Mechanics
- `DATEDIFF(resolved_date, created_date)` computes the absolute span of elapsed days.
- Dividing total days by 7 and applying `FLOOR(diff / 7)` identifies the exact count of completed 7-day weeks.
- Multiplying completed weeks by 2 (`* 2`) deducts Saturday and Sunday for each completed cycle.

### 2. SQL Logical Processing Order
- As demonstrated in earlier questions, column aliases computed in `SELECT` cannot be evaluated in the `WHERE` filter.
- Repeating the expression `DATEDIFF(...) - (FLOOR(...) * 2) >= 3` ensures compatibility across SQL dialect parsers without requiring a CTE.

### 3. Enterprise Production Alternatives: The `DimDate` Pattern
- While mathematical heuristics work well for multi-week spans, enterprise production environments handle statutory bank holidays and partial-week weekend bridges using a dedicated **Date Dimension Table (`dim_calendar`)**:
  ```sql
  SELECT 
      t.ticket_id, 
      COUNT(c.calendar_date) AS business_working_days
  FROM b2b_support_tickets t
  JOIN dim_calendar c 
    ON c.calendar_date >= t.created_date 
   AND c.calendar_date < t.resolved_date
  WHERE c.is_weekend = FALSE 
    AND c.is_bank_holiday = FALSE
  GROUP BY t.ticket_id;
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: The Partial-Week Weekend Bridge
- **Interviewer Query:** *"What if a ticket opens on Friday and closes on Monday (3 calendar days)? `FLOOR(3/7) = 0`, so the formula returns 3 days instead of 1 working day. How do you defend or resolve this?"*
- **Candidate Defense:**
  > *"Mathematical division works accurately for multi-week intervals or whole-week multiples. For short-interval micro-SLAs, enterprise systems avoid heuristics and join against an indexed `dim_calendar` dimension table or utilize BI functions such as DAX `NETWORKDAYS(start, end, holidays)` to evaluate individual weekday flags accurately."*

### Trap 2: SARGability on Date Comparisons
- **Interviewer Query:** *"How would you index this table to optimize resolution queries?"*
- **Candidate Defense:**
  > *"A composite index on `(resolution_status, ticket_priority, created_date, resolved_date)` satisfies the filtering predicates via index seeks and allows covering evaluation for `DATEDIFF` calculations without accessing the underlying heap storage."*
