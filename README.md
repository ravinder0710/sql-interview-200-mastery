# 🥋 SQL Interview Mastery — 200 Questions Challenge
### (Target: Fresher & Data Analyst | 0 — 2 Years Experience)

<div align="center">

![SQL Challenge](https://img.shields.io/badge/SQL-200_Questions_Challenge-blue.svg?style=for-the-badge&logo=postgresql)
![Role](https://img.shields.io/badge/Target_Role-Data_Analyst_%280--2_Years%29-orange.svg?style=for-the-badge)
![Progress](https://img.shields.io/badge/Progress-46%2F200_%2823%25%29-brightgreen.svg?style=for-the-badge)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

<p align="center">
  <b>Production-grade, battle-tested SQL solutions & architectural patterns asked by Tier-1 product companies & global consultancies.</b>
</p>

[⚡ Quick Revision Cheat Sheet](INTERVIEW_QUICK_REVISION_NOTES.md) •
[📂 Browse Questions](#-solved-questions-index) •
[📊 Curriculum Progress](#-curriculum--progress-tracker-10--200) •
[👨‍💻 Author](#-author--connect)

</div>

---

## 📌 Why This Repository Exists
Most candidates practice toy SQL problems (`SELECT * FROM students`). In real technical interviews (TCS, Accenture, Amazon, Swiggy, FinTech startups), interviewers test:
- **Edge cases**: NULL equality traps, strict boundary checks, integer division hazards.
- **Performance**: SARGable filters, covering indexes, and execution plans.
- **Business metrics**: MoM growth, cohort retention, priority triage queues, and amortization breakdowns.

This repository documents **200 real-world, high-frequency interview questions** with reproducible schemas, production queries, and interviewer defense logic.

---

## 🗂️ Curriculum & Progress Tracker (46 / 200)

| Block | Topic / Category | Target | Completed | Progress |
|---|---|:---:|:---:|:---|
| **01** | **Foundations & Data Filtering** (`WHERE`, `LIKE`, `IN`, `BETWEEN`, `NULL`, `ORDER BY`, `LIMIT`, Math) | 15 | 15 | `[██████████] 100%` |
| **02** | **String & Date Cleaning** (`CONCAT`, `UPPER`/`LOWER`, `SUBSTRING`, `DATEDIFF`, `DATEADD`) | 20 | 20 | `[██████████] 100%` |
| **03** | **Aggregations & Grouping** (`COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`, NULL traps) | 30 | 11 | `[████░░░░░░] 37%` |
| **04** | **Conditional Business Logic** (`CASE WHEN`, Bucketing, Conditional Aggregation) | 20 | 0 | `[░░░░░░░░░░] 0%` |
| **05** | **Multi-Table Joins (2 & 3 Tables)** (`INNER`, `LEFT` for unmatched records, 3-Table chains, `SELF JOIN`) | 50 | 0 | `[░░░░░░░░░░] 0%` |
| **06** | **Subqueries & CTEs** (Scalar/Correlated Subqueries, `WITH` clause modular pipelines) | 25 | 0 | `[░░░░░░░░░░] 0%` |
| **07** | **Window Functions & Ranking** (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`/`LEAD`, Running Totals)| 25 | 0 | `[░░░░░░░░░░] 0%` |
| **08** | **Real Company Mock Sets & Case Studies** (Amazon, TCS, Accenture, FinTech case scenarios) | 15 | 0 | `[░░░░░░░░░░] 0%` |
| **TOTAL** | **8 High-Impact Blocks** | **200** | **46** | **46 / 200 (23%)** |

---

## 📖 Solved Questions Index

| # | Question Title | Topic | Company Tags | Solution Link |
|:---:|---|---|---|:---:|
| **Q001** | Filter High Earners by Salary | Strict Numeric Boundary (`>`) & Column Projection | TCS, Infosys, Cognizant | [Q001 Solution ↗️](01_Foundations_and_Filtering/Q001_filter_employees_by_salary.md) |
| **Q002** | Undelivered Online Orders | Inequality (`<>`) & The NULL Trap | Amazon, Swiggy, Zomato | [Q002 Solution ↗️](01_Foundations_and_Filtering/Q002_filter_undelivered_online_orders.md) |
| **Q003** | Warehouse Promotional Catalog | Set Membership (`IN`) & Range (`BETWEEN`) | Flipkart, Amazon Inventory | [Q003 Solution ↗️](01_Foundations_and_Filtering/Q003_filter_inventory_by_category_price_stock.md) |
| **Q004** | Target Genuine Customer Accounts | Wildcard Pattern Matching (`LIKE`, `%`, `NOT LIKE`) | Salesforce, HubSpot, CRM | [Q004 Solution ↗️](01_Foundations_and_Filtering/Q004_filter_customers_by_pattern_matching.md) |
| **Q005** | Missing Commission & Manager Audit | Missing Data (`IS NULL`) & Operator Precedence | Infosys, Wipro, Payroll | [Q005 Solution ↗️](01_Foundations_and_Filtering/Q005_filter_missing_commission_or_manager.md) |
| **Q006** | OPD Priority Patient Queue | Multi-Column Sorting & Tie-Breaking | Hospital & Logistics Triage | [Q006 Solution ↗️](01_Foundations_and_Filtering/Q006_multi_column_priority_sorting.md) |
| **Q007** | Top 3 Streamed Songs | Top-N Truncation (`LIMIT` / `TOP`) & Dialects | Spotify, Netflix, YouTube | [Q007 Solution ↗️](01_Foundations_and_Filtering/Q007_top_n_records_with_limit.md) |
| **Q008** | Second Highest Property Price | Pagination (`LIMIT 1 OFFSET N-1`) & Deduplication | MagicBricks, 99acres | [Q008 Solution ↗️](01_Foundations_and_Filtering/Q008_second_highest_price_limit_offset.md) |
| **Q009** | Order Profitability Breakdown | Arithmetic Precedence & Integer Division Prevention | Retail E-Commerce Unit Economics | [Q009 Solution ↗️](01_Foundations_and_Filtering/Q009_calculated_columns_revenue_profit.md) |
| **Q010** | Loan Amortization & EMI Schedule | Scalar Math (`ROUND`, `CEIL`) & CTE Decomposition | CRED, Paytm Lending | [Q010 Solution ↗️](01_Foundations_and_Filtering/Q010_scalar_math_round_ceil_loan_emi.md) |
| **Q011** | Employee Onboarding Badge Profile | String Formatting (`CONCAT`, `UPPER`, `LENGTH`) | Accenture, Wipro, HR IT | [Q011 Solution ↗️](01_Foundations_and_Filtering/Q011_employee_badge_and_email_formatting.md) |
| **Q012** | String Parsing & Data Masking | String Extraction (`SUBSTRING`, `LEFT`, `RIGHT`) | Swiggy, Paytm, Telecom | [Q012 Solution ↗️](01_Foundations_and_Filtering/Q012_string_extraction_substring_left_right.md) |
| **Q013** | String Cleansing & Normalization | String Cleaning (`REPLACE`, `TRIM`, `UPPER`) | Amazon, Uber, Logistics | [Q013 Solution ↗️](01_Foundations_and_Filtering/Q013_string_cleaning_replace_trim.md) |
| **Q014** | Date Part Extraction & Temporal Filtering | Date Functions (`YEAR`, `MONTH`, `DAY`, `EXTRACT`) | Flipkart, Zomato, Retail | [Q014 Solution ↗️](01_Foundations_and_Filtering/Q014_date_parts_extraction_year_month_day.md) |
| **Q015** | Date Difference & Recency SLA Analysis | Date Math (`DATEDIFF`, `CURRENT_DATE`) | Swiggy, Amazon, Logistics | [Q015 Solution ↗️](01_Foundations_and_Filtering/Q015_datediff_delivery_sla_breach.md) |
| **Q016** | Cleaning Inconsistent Phone Prefixes | String Standardization (`RIGHT`, `REPLACE`, `LENGTH`) | Truecaller, FinTech, OTP | [Q016 Solution ↗️](02_String_and_Date_Cleaning/Q016_clean_phone_prefixes_and_hyphens.md) |
| **Q017** | Dynamic String Delimiter Splitting | String Search & Splitting (`INSTR`, `SUBSTRING`, `LEFT`) | Gmail, Marketing, HR | [Q017 Solution ↗️](02_String_and_Date_Cleaning/Q017_email_username_and_domain_separation.md) |
| **Q018** | String to Date Conversion & Formatting | String & Date Casting (`STR_TO_DATE`, `DATE_FORMAT`) | Banking, Audit, Healthcare | [Q018 Solution ↗️](02_String_and_Date_Cleaning/Q018_string_to_date_conversion_and_formatting.md) |
| **Q019** | Title Casing & Capitalization Normalization | String Transformation (`INITCAP`, `CONCAT`, `UPPER`) | Netflix, E-Commerce, Retail | [Q019 Solution ↗️](02_String_and_Date_Cleaning/Q019_title_casing_capitalization_normalization.md) |
| **Q020** | Date Addition & Expiry/Warranty Tracking | Date Arithmetic (`DATE_ADD`, `INTERVAL`) | Amazon, AppleCare, FinTech | [Q020 Solution ↗️](02_String_and_Date_Cleaning/Q020_date_addition_expiry_tracking.md) |
| **Q021** | Feedback Sentiment Keyword Tagging | String Pattern & Keyword Search (`CASE`, `LIKE`, CTE) | Uber, Swiggy, Airbnb | [Q021 Solution ↗️](02_String_and_Date_Cleaning/Q021_feedback_sentiment_keyword_tagging.md) |
| **Q022** | Exact Age Calculation & Senior Citizen KYC | Date Difference & Calendar Math (`TIMESTAMPDIFF`) | FinTech, Insurance, KYC | [Q022 Solution ↗️](02_String_and_Date_Cleaning/Q022_exact_age_calculation_timestampdiff.md) |
| **Q023** | Hour & Minute Extraction for Peak Traffic | Time Functions (`HOUR`, `MINUTE`, `DATETIME`) | Uber, Swiggy, Dunzo | [Q023 Solution ↗️](02_String_and_Date_Cleaning/Q023_hour_and_minute_extraction_peak_traffic.md) |
| **Q024** | Regex Alphanumeric Validation | Regular Expressions (`REGEXP`, `RLIKE`) | Banking, Fraud, KYC | [Q024 Solution ↗️](02_String_and_Date_Cleaning/Q024_regex_alphanumeric_pan_validation.md) |
| **Q025** | Handling NULLs & Fallback Imputation | Missing Data Handling (`COALESCE`, `IFNULL`) | CRM, E-Commerce, Billing | [Q025 Solution ↗️](02_String_and_Date_Cleaning/Q025_handling_nulls_fallback_coalesce.md) |
| **Q026** | Day Name Extraction & Weekend Surge Analysis | Day Functions (`DAYNAME`, `CASE WHEN`) | Luxury Retail, Zomato, Malls | [Q026 Solution ↗️](02_String_and_Date_Cleaning/Q026_day_name_extraction_weekend_analysis.md) |
| **Q027** | Nullifying Sentinel Dummy Values | Data Cleaning (`NULLIF`, `CASE WHEN`) | IoT, Telemetry, Weather | [Q027 Solution ↗️](02_String_and_Date_Cleaning/Q027_nullifying_sentinel_dummy_values.md) |
| **Q028** | Date Truncation & Cohort Normalization | Temporal Aggregation (`DATE_FORMAT`, `DATE_SUB`) | Netflix, Spotify, SaaS | [Q028 Solution ↗️](02_String_and_Date_Cleaning/Q028_date_truncation_cohort_normalization.md) |
| **Q029** | Credit Card & PII Data Masking | String Masking (`REPEAT`, `RIGHT`, `CONCAT`) | FinTech, Banking, PCI-DSS | [Q029 Solution ↗️](02_String_and_Date_Cleaning/Q029_credit_card_pii_masking.md) |
| **Q030** | URL Top-Level Domain (TLD) Extraction | String Parsing (`SUBSTRING_INDEX`, `RIGHT`) | Marketing, SEO, Web Analytics | [Q030 Solution ↗️](02_String_and_Date_Cleaning/Q030_url_domain_parsing_substring_index.md) |
| **Q031** | Session Duration & Idle Timeout Inactivity | Time Calculation (`TIMESTAMPDIFF`, `TIMEDIFF`) | Gaming, SaaS, Security Audit | [Q031 Solution ↗️](02_String_and_Date_Cleaning/Q031_session_duration_timestampdiff.md) |
| **Q032** | Month-End Closing & Billing Cycle Anchor | Date Functions (`LAST_DAY`, `DATE_ADD`) | FinTech, Credit Card Billing | [Q032 Solution ↗️](02_String_and_Date_Cleaning/Q032_month_end_closing_last_day.md) |
| **Q033** | Palindrome & Data Symmetry Detection | String Manipulation (`REVERSE`, `LOWER`, `REPLACE`) | Data Integrity, Search Engines | [Q033 Solution ↗️](02_String_and_Date_Cleaning/Q033_palindrome_symmetry_detection_reverse.md) |
| **Q034** | Phone Number Regex Standardization | Regular Expressions (`REGEXP_REPLACE`, `RIGHT`) | Telemarketing, CRM, OTP | [Q034 Solution ↗️](02_String_and_Date_Cleaning/Q034_phone_number_regex_replace.md) |
| **Q035** | Business Working Days SLA Calculation | Date Filtering & Weekend Exclusion (`DATEDIFF`, `WEEKDAY`) | B2B Logistics, Banking SLAs | [Q035 Solution ↗️](02_String_and_Date_Cleaning/Q035_business_working_days_sla_deduction.md) |
| **Q036** | Total Orders & Revenue by Customer | Aggregate Functions (`COUNT`, `SUM`, `ROUND`) | E-Commerce, Retail Analytics | [Q036 Solution ↗️](03_Aggregations_and_Grouping/Q036_customer_lifetime_spend_having.md) |
| **Q037** | Distinct vs Total Item & Category Diversity | Multi-Aggregates (`COUNT(*)`, `COUNT(DISTINCT)`) | Amazon, Retail Basket Analysis | [Q037 Solution ↗️](03_Aggregations_and_Grouping/Q037_distinct_vs_total_item_diversity.md) |
| **Q038** | Aggregate Average & The NULL Trap | Aggregations (`AVG`, `COALESCE`, `ROUND`) | HR Payroll, Performance Appraisals | [Q038 Solution ↗️](03_Aggregations_and_Grouping/Q038_aggregate_average_null_trap.md) |
| **Q039** | Multi-Column Grouping & Store Performance | Multi-Key Aggregations (`GROUP BY col1, col2`) | Retail Chain, Supermarkets | [Q039 Solution ↗️](03_Aggregations_and_Grouping/Q039_multi_column_grouping_store_performance.md) |
| **Q040** | Conditional Aggregation with CASE WHEN | Grouping & Pivoting (`SUM(CASE WHEN ...)`) | Banking, Loan Risk & Delinquency | [Q040 Solution ↗️](03_Aggregations_and_Grouping/Q040_conditional_aggregation_case_when.md) |
| **Q041** | Min/Max Boundary Aggregation & Price Spread | Extreme Value Aggregations (`MIN`, `MAX`) | E-Commerce, Price Optimization | [Q041 Solution ↗️](03_Aggregations_and_Grouping/Q041_min_max_boundary_price_spread.md) |
| **Q042** | Filter Groups with Sub-Aggregate Thresholds | Group Aggregation (`AVG`, `HAVING AVG() > ...`) | Call Center, Agent Productivity | [Q042 Solution ↗️](03_Aggregations_and_Grouping/Q042_agent_productivity_aht_csat_having.md) |
| **Q043** | Multi-Tier Subtotals & Aggregations with ROLLUP | Hierarchical Aggregations (`WITH ROLLUP`, `GROUPING`) | Financial Audit, Sales Summaries | [Q043 Solution ↗️](03_Aggregations_and_Grouping/Q043_hierarchical_subtotals_rollup.md) |
| **Q044** | Concatenating Group Values into Delimited Strings | String Aggregation (`GROUP_CONCAT`, `STRING_AGG`) | CRM, Tagging & User Preferences | [Q044 Solution ↗️](03_Aggregations_and_Grouping/Q044_string_aggregation_group_concat.md) |
| **Q045** | Ratio of Aggregates & Conversion Rates | Aggregate Math (`SUM() / COUNT(*) * 100`) | Marketing, E-Commerce Funnel | [Q045 Solution ↗️](03_Aggregations_and_Grouping/Q045_ratio_of_aggregates_conversion_rate.md) |
| **Q046** | Multiple Conditional Counts & Funnel Drop-off | Advanced Conditional Aggregation (`COUNT(CASE WHEN ...)`) | SaaS Product Funnel, User Journey | [Q046 Solution ↗️](03_Aggregations_and_Grouping/Q046_funnel_dropoff_conditional_distinct_count.md) |
| **Q047** | Grouping on Calculated Time Bins | Temporal Aggregations (`HOUR(timestamp)`) | Uber, Food Delivery, Logistics | *In Progress* |

---

## 📁 Repository Structure
```text
sql-interview-200-mastery/
├── README.md                                 # Master Curriculum & Live Tracker
├── LICENSE                                   # MIT Open-Source License
├── INTERVIEW_QUICK_REVISION_NOTES.md         # Formula & Interviewer Defense Notes
├── 01_Foundations_and_Filtering/             # (Q001 - Q015)
├── 02_String_and_Date_Cleaning/              # (Q016 - Q035)
├── 03_Aggregations_and_Grouping/             # (Q036 - Q065)
├── 04_Conditional_Logic_Case_When/           # (Q066 - Q085)
├── 05_Multi_Table_Joins/                     # (Q086 - Q135)
├── 06_Subqueries_and_CTEs/                   # (Q136 - Q160)
├── 07_Window_Functions_Ranking/              # (Q161 - Q185)
└── 08_Real_Company_Mock_Sets/                # (Q186 - Q200)
```

---

## 👨‍💻 Author & Connect

**Ravinder Gupta**
* Aspiring Data Analyst & SQL Specialist
* GitHub: [@ravinder0710](https://github.com/ravinder0710)
* Email: [iamravindergupta17@gmail.com](mailto:iamravindergupta17@gmail.com)

---
*Maintained with daily updates and active GitHub commits.*
