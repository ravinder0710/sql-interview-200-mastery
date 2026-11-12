# Q046: Multiple Conditional Counts & Funnel Drop-off (`COUNT(DISTINCT CASE ...)`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q046 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Product Growth Analytics (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In SaaS product-led growth (PLG) applications and mobile user onboarding (e.g., Canva, Notion, Slack, Figma), product analytics teams track user progression through sequential milestone funnels:
1. `Signed_Up` (Baseline Ingestion)
2. `Completed_Profile` (Account Activation)
3. `Created_First_Project` (Core Value Realization)
4. `Upgraded_To_Paid` (Monetization Conversion)

Telemetry event tables log each user action as an atomic event row. In fast-paced growth environments, users frequently trigger repeated milestone events (e.g., updating a profile multiple times).

Evaluating funnel conversion rates by summing raw event occurrences falsely inflates user counts. Instead, growth analysts must compute **deduplicated user-level funnel stages** partitioned by acquisition channel.

The Growth Directorate requires an audited channel funnel report where:
1. Each acquisition channel displays total unique signed-up users and unique users reaching each milestone stage.
2. Events are evaluated strictly at the unique user level (`COUNT(DISTINCT user_id)`).
3. Only channels with meaningful baseline acquisition volume (`total_users >= 3`) and at least 1 paid conversion are reported.
4. Output is sorted by `paid_converted_users DESC, total_users DESC, acquisition_channel ASC`.

---

## 📊 Sample Mock Table: `user_onboarding_events`

| event_id | acquisition_channel | user_id | event_stage |
|:---:|:---:|:---:|:---:|
| 1 | Organic | U101 | Signed_Up |
| 2 | Organic | U101 | Completed_Profile |
| 3 | Organic | U101 | Created_First_Project |
| 4 | Organic | U101 | Upgraded_To_Paid |
| 5 | Organic | U102 | Signed_Up |
| 6 | Organic | U102 | Completed_Profile |
| 7 | Organic | U103 | Signed_Up |
| 8 | Referral | U104 | Signed_Up |
| 9 | Referral | U104 | Completed_Profile |
| 10 | Referral | U104 | Created_First_Project |
| 11 | Referral | U104 | Upgraded_To_Paid |
| 12 | Referral | U105 | Signed_Up |
| 13 | Referral | U105 | Completed_Profile |
| 14 | Referral | U105 | Created_First_Project |
| 15 | Referral | U105 | Upgraded_To_Paid |
| 16 | Referral | U106 | Signed_Up |
| 17 | Paid_Search | U107 | Signed_Up |
| 18 | Paid_Search | U108 | Signed_Up |

---

## 🎯 Expected Output Table

| acquisition_channel | total_users | profile_completed_users | project_created_users | paid_converted_users |
|:---:|:---:|:---:|:---:|:---:|
| Referral | 3 | 2 | 2 | 2 |
| Organic | 3 | 2 | 1 | 1 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    acquisition_channel, 
    COUNT(DISTINCT user_id) AS total_users, 
    COUNT(DISTINCT CASE WHEN event_stage = 'Completed_Profile' THEN user_id END) AS profile_completed_users, 
    COUNT(DISTINCT CASE WHEN event_stage = 'Created_First_Project' THEN user_id END) AS project_created_users, 
    COUNT(DISTINCT CASE WHEN event_stage = 'Upgraded_To_Paid' THEN user_id END) AS paid_converted_users 
FROM user_onboarding_events 
GROUP BY acquisition_channel 
HAVING COUNT(DISTINCT user_id) >= 3 
   AND COUNT(DISTINCT CASE WHEN event_stage = 'Upgraded_To_Paid' THEN user_id END) >= 1 
ORDER BY paid_converted_users DESC, total_users DESC, acquisition_channel ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. `COUNT(DISTINCT CASE ... THEN user_id END)` Mechanics
- Inside the aggregate, `CASE WHEN event_stage = '...' THEN user_id END` outputs the `user_id` when the predicate matches, and defaults to `NULL` otherwise.
- The outer `COUNT(DISTINCT ...)`:
  - Discards all `NULL` outputs.
  - Collapses duplicate `user_id` entries for users triggering multiple events of that same stage.
- Result: An exact, deduplicated head-count of converted individuals.

### 2. User-Level vs Event-Level Metrics
- If an analyst writes `SUM(CASE WHEN event_stage = 'Completed_Profile' THEN 1 ELSE 0 END)`, they are measuring **raw event throughput**, not **user conversion**.
- For funnel analytics, distinct user counting prevents multi-action bias.

### 3. PostgreSQL / Modern SQL Alternative: `FILTER`
- In PostgreSQL and DuckDB:
  ```sql
  COUNT(DISTINCT user_id) FILTER (WHERE event_stage = 'Upgraded_To_Paid') AS paid_converted_users
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Omission of `DISTINCT` in Funnel Milestones
- **Interviewer Query:** *"What is the business impact if `DISTINCT` is omitted inside the conditional count?"*
- **Candidate Defense:**
  > *"Omitting `DISTINCT` converts a unique user conversion metric into an event frequency count. A single power user who repeatedly updates their profile would be counted 5 times, falsifying the funnel activation rate. Distinct conditional counts enforce true 1:1 user identity mapping."*

### Trap 2: String Literals & Casing Traps
- **Interviewer Query:** *"Why did `'Complete_Profile'` fail while `'Completed_Profile'` passed?"*
- **Candidate Defense:**
  > *"String comparisons in ANSI SQL and case-sensitive database collations (`utf8mb4_bin`, PostgreSQL default) require exact byte-level character equality. Any tense variation or casing slip leads to silent zero-count returns without throwing syntax errors."*
