# 🥋 SQL Interview Mastery — 200 Questions Challenge
### (Target: Fresher & Data Analyst | 0 — 2 Years Experience)

<div align="center">

![SQL Challenge](https://img.shields.io/badge/SQL-200_Questions_Challenge-blue.svg?style=for-the-badge&logo=postgresql)
![Role](https://img.shields.io/badge/Target_Role-Data_Analyst_%280--2_Years%29-orange.svg?style=for-the-badge)
![Progress](https://img.shields.io/badge/Progress-16%2F200_%288%25%29-brightgreen.svg?style=for-the-badge)
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

## 🗂️ Curriculum & Progress Tracker (16 / 200)

| Block | Topic / Category | Target | Completed | Progress |
|---|---|:---:|:---:|:---|
| **01** | **Foundations & Data Filtering** (`WHERE`, `LIKE`, `IN`, `BETWEEN`, `NULL`, `ORDER BY`, `LIMIT`, Math) | 15 | 10 | `[███████░░░] 67%` |
| **02** | **String & Date Cleaning** (`CONCAT`, `UPPER`/`LOWER`, `SUBSTRING`, `DATEDIFF`, `DATEADD`) | 20 | 0 | `[░░░░░░░░░░] 0%` |
| **03** | **Aggregations & Grouping** (`COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`, NULL traps) | 30 | 0 | `[░░░░░░░░░░] 0%` |
| **04** | **Conditional Business Logic** (`CASE WHEN`, Bucketing, Conditional Aggregation) | 20 | 0 | `[░░░░░░░░░░] 0%` |
| **05** | **Multi-Table Joins (2 & 3 Tables)** (`INNER`, `LEFT` for unmatched records, 3-Table chains, `SELF JOIN`) | 50 | 0 | `[░░░░░░░░░░] 0%` |
| **06** | **Subqueries & CTEs** (Scalar/Correlated Subqueries, `WITH` clause modular pipelines) | 25 | 0 | `[░░░░░░░░░░] 0%` |
| **07** | **Window Functions & Ranking** (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`/`LEAD`, Running Totals)| 25 | 0 | `[░░░░░░░░░░] 0%` |
| **08** | **Real Company Mock Sets & Case Studies** (Amazon, TCS, Accenture, FinTech case scenarios) | 15 | 0 | `[░░░░░░░░░░] 0%` |
| **TOTAL** | **8 High-Impact Blocks** | **200** | **10** | **10 / 200 (5%)** |

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
| **Q017** | Email Username & Domain Separation | String Search & Splitting (`INSTR`, `SUBSTRING`) | Gmail, Marketing, HR | *In Progress* |

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
