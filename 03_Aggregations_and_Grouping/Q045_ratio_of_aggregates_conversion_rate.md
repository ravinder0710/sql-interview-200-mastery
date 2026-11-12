# Q045: Ratio of Aggregates & Conversion Rates (`SUM / COUNT * 100.0`)

## 📌 Metadata
- **Module:** 03 Aggregations & Grouping
- **Question Number:** Q045 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Digital Marketing & AdTech BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL, PostgreSQL, Snowflake, SQL Server, BigQuery

---

## 🏢 Business Scenario
In digital performance marketing and ad-tech optimization (e.g., Google Ads, Meta Ads Manager, Flipkart Commerce Ads), performance leads monitor **Conversion Rate (CVR%)** to evaluate campaign return on ad spend (ROAS).

Conversion rate is mathematically defined as the ratio of completed conversion events to total inbound user clicks:
$$\text{CVR \%} = \left(\frac{\sum \text{Conversions}}{\sum \text{Clicks}}\right) \times 100.0$$

Campaigns with fewer clicks yield noisy, statistically insignificant conversion spikes. Growth marketers enforce a statistical minimum volume filter alongside efficiency thresholds to prioritize scale investments.

The Growth Marketing Directorate requires an audited ad campaign performance report where:
1. Only authentic human traffic is evaluated (`device_type IN ('Mobile', 'Desktop')`), excluding automated crawler or tablet traffic.
2. The campaign accrued meaningful sample size (`total_clicks >= 5`).
3. The campaign demonstrates high conversion velocity ($\text{conversion\_rate\_pct} \ge 25.00\%$).
4. Conversion percentages are rounded to 2 decimal places with integer division safeguards (`100.0`).
5. Output is sorted by `conversion_rate_pct DESC, total_clicks DESC, campaign_id ASC`.

---

## 📊 Sample Mock Table: `ad_campaign_clicks`

| click_id | campaign_id | campaign_name | device_type | is_purchased |
|:---:|:---:|:---:|:---:|:---:|
| 1 | CMP_101 | Summer_Sale | Mobile | 1 |
| 2 | CMP_101 | Summer_Sale | Mobile | 0 |
| 3 | CMP_101 | Summer_Sale | Desktop | 1 |
| 4 | CMP_101 | Summer_Sale | Mobile | 0 |
| 5 | CMP_101 | Summer_Sale | Desktop | 1 |
| 6 | CMP_102 | Brand_Awareness | Mobile | 1 |
| 7 | CMP_102 | Brand_Awareness | Desktop | 0 |
| 8 | CMP_102 | Brand_Awareness | Mobile | 0 |
| 9 | CMP_102 | Brand_Awareness | Desktop | 0 |
| 10 | CMP_102 | Brand_Awareness | Mobile | 0 |
| 11 | CMP_103 | Flash_Deal | Tablet | 1 |
| 12 | CMP_104 | Retargeting | Mobile | 1 |
| 13 | CMP_104 | Retargeting | Mobile | 1 |
| 14 | CMP_104 | Retargeting | Desktop | 0 |
| 15 | CMP_104 | Retargeting | Desktop | 1 |
| 16 | CMP_104 | Retargeting | Mobile | 1 |

---

## 🎯 Expected Output Table

| campaign_id | campaign_name | total_clicks | total_conversions | conversion_rate_pct |
|:---:|:---:|:---:|:---:|:---:|
| CMP_104 | Retargeting | 5 | 4 | 80.00 |
| CMP_101 | Summer_Sale | 5 | 3 | 60.00 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    campaign_id, 
    campaign_name, 
    COUNT(click_id) AS total_clicks, 
    SUM(is_purchased) AS total_conversions, 
    ROUND(SUM(is_purchased) * 100.0 / COUNT(click_id), 2) AS conversion_rate_pct 
FROM ad_campaign_clicks 
WHERE device_type IN ('Mobile', 'Desktop') 
GROUP BY campaign_id, campaign_name 
HAVING COUNT(click_id) >= 5 
   AND (SUM(is_purchased) * 100.0 / COUNT(click_id)) >= 25.00 
ORDER BY conversion_rate_pct DESC, total_clicks DESC, campaign_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Integer Division Hazards Across SQL Dialects
- In strict typed engines like **PostgreSQL** and **SQL Server (T-SQL)**, dividing two integers yields an integer quotient:
  $$4 / 5 = 0 \implies 0 \times 100 = 0.00\%$$
- Placing `100.0` (with explicit decimal point) in the numerator forces implicit numeric coercion across the entire expression:
  $$\text{SUM}(is\_purchased) \times 100.0 \implies \text{NUMERIC}(10, 2)$$
  This guarantees accurate floating-point quotients across every relational engine.

### 2. The Binary 0/1 Flag Shortcut: `AVG(col)`
- When an indicator flag is stored as binary integers (`0` and `1`), the arithmetic mean `AVG(flag)` is mathematically identical to $\frac{\sum \text{Successes}}{\sum \text{Total}}$:
  ```sql
  ROUND(AVG(is_purchased) * 100.0, 2) AS conversion_rate_pct
  ```
  This formulation is concise and eliminates dual aggregation overhead in the query engine.

### 3. Division-by-Zero Protection
- In sparse datasets where the denominator might evaluate to zero, wrap with `NULLIF`:
  ```sql
  ROUND(SUM(is_purchased) * 100.0 / NULLIF(COUNT(click_id), 0), 2)
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Multiplying by 100 After Division
- **Interviewer Query:** *"What happens if a candidate writes `(SUM(is_purchased) / COUNT(click_id)) * 100`?"*
- **Candidate Defense:**
  > *"In PostgreSQL and SQL Server, integer division evaluates inside the parentheses first: `(4 / 5)` evaluates to `0`, and `0 * 100` returns `0.00%`. Multiplying `100.0` in the numerator prior to division forces floating-point decimal evaluation before the quotient is computed."*

### Trap 2: Using Column Alias Inside `HAVING`
- **Interviewer Query:** *"Why can't we write `HAVING conversion_rate_pct >= 25.00`?"*
- **Candidate Defense:**
  > *"Because `HAVING` runs before `SELECT` in ANSI SQL logical query processing, column aliases defined in `SELECT` are unassigned during the `HAVING` phase. Repeating the aggregate expression guarantees portable, standard-compliant SQL across PostgreSQL, Oracle, and SQL Server."*
