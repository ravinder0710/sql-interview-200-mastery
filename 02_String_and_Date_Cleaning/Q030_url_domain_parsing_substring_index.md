# Q030: URL Domain Parsing & Extraction (`SUBSTRING_INDEX`)

## 📌 Metadata
- **Module:** 02 String & Date Cleaning
- **Question Number:** Q030 / 200
- **Difficulty Level:** Medium
- **Target Role:** Data Analyst / Marketing BI Developer (0–2 Years Experience)
- **Dialect Compatibility:** MySQL (`SUBSTRING_INDEX`), PostgreSQL (`SPLIT_PART`), BigQuery (`NET.HOST`), Snowflake (`PARSE_URL`)

---

## 🏢 Business Scenario
In digital marketing attribution, AdTech campaign management, and web analytics (e.g., Google Analytics 4, Meta Ads Manager, Shopify Referrals), web traffic logs store raw referral URLs containing transport protocols (`http://`, `https://`), host domains, subdomains, sub-paths, and URL query parameters (e.g., `https://partners.shopify.com/store/login`).

Marketing performance teams and growth analysts require clean, normalized domain-level aggregation to attribute conversion volumes accurately across traffic channels without fragmenting reports across different URL sub-pages.

The Digital Marketing lead has requested an extract of high-performing referral campaigns where:
1. The channel is strictly referral traffic (`traffic_source = 'Referral'`).
2. The campaign drove substantial volume (`visitor_count >= 1000`).
3. The raw `referrer_url` is tokenized to strip protocols and paths, outputting `clean_domain`.
4. Output is sorted by `visitor_count DESC, referral_id ASC`.

---

## 📊 Sample Mock Table: `web_traffic_referrals`

| referral_id | campaign_name | referrer_url | traffic_source | visitor_count |
|:---:|:---:|:---:|:---:|:---:|
| 801 | Diwali_Promo | `https://partners.shopify.com/store/login` | Referral | 4500 |
| 802 | Organic_Search | `https://www.google.com/search?q=shoes` | Organic | 12000 |
| 803 | Winter_Sale | `http://m.facebook.com/posts/winter-deals` | Referral | 850 |
| 804 | FinTech_Webinar | `https://blog.hubspot.com/marketing/trends` | Referral | 3200 |
| 805 | Affiliate_Blast | `https://deals.coupondunia.in/offers/electronics` | Referral | 7800 |
| 806 | Newsletter_Drop | `https://cdn.substack.com/archive/october` | Direct | 2100 |
| 807 | Tech_Summit | `http://events.techcrunch.com/2024/agenda` | Referral | 1450 |

---

## 🎯 Expected Output Table

| referral_id | campaign_name | clean_domain | visitor_count |
|:---:|:---:|:---:|:---:|
| 805 | Affiliate_Blast | `deals.coupondunia.in` | 7800 |
| 801 | Diwali_Promo | `partners.shopify.com` | 4500 |
| 804 | FinTech_Webinar | `blog.hubspot.com` | 3200 |
| 807 | Tech_Summit | `events.techcrunch.com` | 1450 |

---

## 💡 Production SQL Solution

```sql
SELECT 
    referral_id, 
    campaign_name, 
    SUBSTRING_INDEX(SUBSTRING_INDEX(referrer_url, '//', -1), '/', 1) AS clean_domain, 
    visitor_count 
FROM web_traffic_referrals 
WHERE traffic_source = 'Referral' 
  AND visitor_count >= 1000 
ORDER BY visitor_count DESC, referral_id ASC;
```

---

## 🧠 Interview Defense & Technical Takeaways

### 1. Two-Step Tokenization with `SUBSTRING_INDEX(str, delim, count)`
- **Step 1 (Strip Protocol):**
  ```sql
  SUBSTRING_INDEX(referrer_url, '//', -1)
  ```
  A negative count (`-1`) instructs MySQL to start searching from the right-hand side of the string, extracting everything after the final occurrence of `'//'`.  
  *Example:* `'https://partners.shopify.com/store/login'` $\longrightarrow$ `'partners.shopify.com/store/login'`.

- **Step 2 (Strip URI Paths):**
  ```sql
  SUBSTRING_INDEX(..., '/', 1)
  ```
  A positive count (`1`) instructs MySQL to start from the left-hand side, extracting everything before the first occurrence of `'/'`.  
  *Result:* `'partners.shopify.com'`.

### 2. Cross-Dialect Production Standards
- **PostgreSQL / Amazon Redshift**:
  ```sql
  SPLIT_PART(SPLIT_PART(referrer_url, '//', 2), '/', 1)
  ```
- **Google BigQuery**:
  ```sql
  NET.HOST(referrer_url)
  ```
- **Snowflake**:
  ```sql
  PARSE_URL(referrer_url):host::VARCHAR
  ```

---

## 🚨 Common Interview Traps & Defense

### Trap 1: Handling Missing Protocol Prefixes
- **Interviewer Query:** *"What happens if a dirty data feed contains `partners.shopify.com/store` without `http://` or `https://`?"*
- **Candidate Defense:**
  > *"When the delimiter `'//'` is absent in `SUBSTRING_INDEX(str, '//', -1)`, MySQL gracefully returns the entire string unchanged. The outer `SUBSTRING_INDEX(..., '/', 1)` then correctly isolates the domain before the first slash. However, if paths also omit slashes, wrapping with `REGEXP_SUBSTR` provides robust pattern anchoring."*

### Trap 2: URLs with Port Numbers or Query Strings
- **Interviewer Query:** *"What if the URL is `https://app.domain.com:8080/path` or `https://app.domain.com?ref=123`?"*
- **Candidate Defense:**
  > *"In non-standard URLs where ports (`:8080`) or query parameters (`?`) precede the first slash, pure slash-based splitting may leave artifacts. In production enterprise data platforms, using specialized regex (`REGEXP_REPLACE(referrer_url, '^https?://([^/?#:]+).*$', '$1')`) or cloud-native URL parsing functions (`NET.HOST`) is standard practice."*
