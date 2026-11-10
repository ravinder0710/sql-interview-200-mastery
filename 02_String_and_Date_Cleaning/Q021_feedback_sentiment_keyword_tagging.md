# Q021: Feedback Sentiment Keyword Tagging (`CASE WHEN`, `LIKE`, CTE)

## 📌 Metadata
- **Module:** Block 02: String & Date Cleaning
- **Question Number:** 021 / 200
- **Difficulty:** Intermediate
- **Target Role:** Data Analyst / SQL Developer (0–2 Years)

---

## 🏢 Business Scenario
In a rapid-commerce / food delivery platform, customer satisfaction ratings are tied to free-text reviews. The customer experience (CX) and operations triage team needs an automated escalation engine that tags unstructured feedback into standardized sentiment categories based on critical service failure keywords (e.g., `'cold'`, `'late'`, `'worst'`). Negative feedback cases must be immediately filtered and escalated to the regional dispatch and merchant relations queue, sorted by lowest rating stars first.

---

## 📊 Sample Mock Table (`customer_reviews`)

| review_id | customer_name | review_text | rating_stars |
| :---: | :--- | :--- | :---: |
| 701 | Rakesh Kumar | Food was cold and late delivery | 1 |
| 702 | Ananya Roy | Great taste, really loved the packaging | 5 |
| 703 | Kunal Sen | Average experience, nothing special | 3 |
| 704 | Pooja Jain | The worst biryani I ever had | 1 |
| 705 | Tarun Das | Order arrived late but food was great | 2 |
| 706 | Sunita Patel | Quick delivery and polite rider | 4 |

---

## 🎯 Expected Output

| review_id | customer_name | review_text | rating_stars | feedback_tag |
| :---: | :--- | :--- | :---: | :--- |
| 701 | Rakesh Kumar | Food was cold and late delivery | 1 | Negative |
| 704 | Pooja Jain | The worst biryani I ever had | 1 | Negative |
| 705 | Tarun Das | Order arrived late but food was great | 2 | Negative |

---

## 💡 Production SQL Solution

```sql
WITH feedback_data AS (
    SELECT 
        review_id, 
        customer_name, 
        review_text, 
        rating_stars, 
        CASE 
            WHEN LOWER(review_text) LIKE '%cold%' 
              OR LOWER(review_text) LIKE '%late%' 
              OR LOWER(review_text) LIKE '%worst%' 
            THEN 'Negative'
            WHEN LOWER(review_text) LIKE '%great%' 
              OR LOWER(review_text) LIKE '%loved%' 
            THEN 'Positive'
            ELSE 'Neutral'
        END AS feedback_tag 
    FROM customer_reviews
)
SELECT 
    review_id, 
    customer_name, 
    review_text, 
    rating_stars, 
    feedback_tag 
FROM feedback_data 
WHERE feedback_tag = 'Negative' 
ORDER BY 
    rating_stars ASC, 
    review_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

1. **Why Use a CTE Instead of Repeating `CASE WHEN` in `WHERE`?**
   - Because `WHERE` evaluates prior to `SELECT`, you cannot write `WHERE feedback_tag = 'Negative'` in a single-pass query without repeating the entire `CASE WHEN` block.
   - Encapsulating the logic within a Common Table Expression (`WITH feedback_data AS ...`) adheres to software engineering **DRY principles (Don't Repeat Yourself)**, keeps the code maintainable, and allows direct filtering on the computed alias in the outer query.

2. **Sequential Short-Circuit Evaluation of `CASE WHEN`:**
   - In SQL, `CASE WHEN` evaluates sequentially from top to bottom and **short-circuits** upon encountering the first matching condition.
   - In review 705 (*"Order arrived late but food was great"*), both `'late'` and `'great'` are present. Because the `'late'` condition appears first in branch 1, it immediately tags as `'Negative'` without evaluating subsequent positive branches.

3. **Case-Insensitive Normalization:**
   - Wrapping columns with `LOWER(review_text)` guarantees that capitalizations like `'Worst'`, `'LATE'`, or `'Cold'` are matched deterministically across case-sensitive databases like PostgreSQL.

---

## 🚨 Common Interview Traps & Defense

1. **Trap: Condition Precedence & Multi-Keyword Conflicts:**
   - *Interviewer:* "What happens if a review contains both a positive and a negative keyword (e.g. 'late but great')?"
   - *Defense:* `CASE WHEN` executes in strict top-to-bottom order and halts at the first `TRUE` predicate. Prioritizing negative complaints at the top ensures critical operational issues are never masked by casual positive remarks.

2. **Trap: Full Table Scan on `%keyword%`:**
   - *Interviewer:* "On 50 million review rows, why is `LIKE '%cold%'` slow and how would you optimize it in production?"
   - *Defense:* Substring wildcards on both sides invalidate standard B-Tree indexes. In enterprise production environments, we optimize text searches by using Full-Text Catalogs (e.g., PostgreSQL `tsvector` with GIN indexing, or Elasticsearch) rather than relational wildcard scans.
