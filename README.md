# 🥋 SQL Interview Mastery — 200 Questions Challenge
### (Target: Fresher & Data Analyst | 0 — 2 Years Experience)

<div align="center">

![SQL Challenge](https://img.shields.io/badge/SQL-200_Questions_Challenge-blue.svg?style=for-the-badge&logo=postgresql)
![Role](https://img.shields.io/badge/Target_Role-Data_Analyst_%280--2_Years%29-orange.svg?style=for-the-badge)
![Progress](https://img.shields.io/badge/Progress-2%2F200_%281%25%29-brightgreen.svg?style=for-the-badge)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

<p align="center">
  <b>Production-grade, battle-tested SQL solutions & architectural patterns asked by Tier-1 product companies & global consultancies.</b>
</p>

[⚡ Quick Revision Cheat Sheet](INTERVIEW_QUICK_REVISION_NOTES.md) •
[📂 Browse Questions](#-solved-questions-index) •
[📊 Curriculum Progress](#-curriculum--progress-tracker-1--200) •
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

## 🗂️ Curriculum & Progress Tracker (2 / 200)

| Block | Topic / Category | Target | Completed | Progress |
|---|---|:---:|:---:|:---|
| **01** | **Foundations & Data Filtering** (`WHERE`, `LIKE`, `IN`, `BETWEEN`, `NULL`, `ORDER BY`, `LIMIT`, Math) | 15 | 2 | `[██░░░░░░░░] 13%` |
| **02** | **String & Date Cleaning** (`CONCAT`, `UPPER`/`LOWER`, `SUBSTRING`, `DATEDIFF`, `DATEADD`) | 20 | 0 | `[░░░░░░░░░░] 0%` |
| **03** | **Aggregations & Grouping** (`COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`, NULL traps) | 30 | 0 | `[░░░░░░░░░░] 0%` |
| **04** | **Conditional Business Logic** (`CASE WHEN`, Bucketing, Conditional Aggregation) | 20 | 0 | `[░░░░░░░░░░] 0%` |
| **05** | **Multi-Table Joins (2 & 3 Tables)** (`INNER`, `LEFT` for unmatched records, 3-Table chains, `SELF JOIN`) | 50 | 0 | `[░░░░░░░░░░] 0%` |
| **06** | **Subqueries & CTEs** (Scalar/Correlated Subqueries, `WITH` clause modular pipelines) | 25 | 0 | `[░░░░░░░░░░] 0%` |
| **07** | **Window Functions & Ranking** (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`/`LEAD`, Running Totals)| 25 | 0 | `[░░░░░░░░░░] 0%` |
| **08** | **Real Company Mock Sets & Case Studies** (Amazon, TCS, Accenture, FinTech case scenarios) | 15 | 0 | `[░░░░░░░░░░] 0%` |
| **TOTAL** | **8 High-Impact Blocks** | **200** | **2** | **2 / 200 (1%)** |

---

## 📖 Solved Questions Index

| # | Question Title | Topic | Company Tags | Solution Link |
|:---:|---|---|---|:---:|
| **Q001** | Filter High Earners by Salary | Numeric Boundary & Column Projection | TCS, Infosys, Cognizant | [Q001 Solution ↗️](01_Foundations_and_Filtering/Q001_filter_employees_by_salary.sql) |
| **Q002** | Undelivered Online Orders | Inequality (`<>`) & The NULL Trap | Amazon, Swiggy, Zomato | [Q002 Solution ↗️](01_Foundations_and_Filtering/Q002_filter_undelivered_online_orders.sql) |
| **Q003** | Warehouse Promotional Catalog | Set Membership (`IN`) & Range (`BETWEEN`) | Flipkart, Amazon Inventory | *In Progress* |

*(This index updates dynamically with every completed problem!)*

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

## 🛠️ File Format Standards
Each `.sql` problem file follows strict production guidelines:
1. **Header Metadata**: Question ID, Block, Company Tags, Difficulty, SQL Dialect compatibility.
2. **Business Context**: The exact business motivation behind the inquiry.
3. **Reproducible Schema & DML**: DDL create statements and ready-to-insert sample records.
4. **Expected Output Grid**: Tabular ground truth verification.
5. **Clean ANSI SQL Query**: Formatted, readable, and production-tested query.
6. **Interviewer Defense & Notes**: SARGability, indexing insights, and common logic traps.

---

## 👨‍💻 Author & Connect

**Ravinder Gupta**
* Aspiring Data Analyst & SQL Specialist
* GitHub: [@ravinder0710](https://github.com/ravinder0710)
* Email: [iamravindergupta17@gmail.com](mailto:iamravindergupta17@gmail.com)

---
*Maintained with daily updates and active GitHub commits.*
