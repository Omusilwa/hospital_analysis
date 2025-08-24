# Health Analytics Project

This project demonstrates the importance of health analytics in evaluating hospital operations and patient experience using a synthetic dataset.
It highlights how data preprocessing, SQL exploration, and visualization can lead to actionable insights in healthcare delivery.

---
### 🔧 Tools & Technologies

- Python → Data preprocessing & database population
- SQL → Data exploration & query analysis
- Tableau → Interactive dashboards & visualization
---
### 🎯 Objectives

#### 1. Encounter Overview

- How many total encounters occurred each year?
  For each year, what percentage of encounters belonged to each encounter class
  (ambulatory, outpatient, wellness, urgent care, emergency, inpatient)?
- What percentage of encounters lasted over 24 hours vs under 24 hours?

#### 2. Cost & Coverage Insights
- How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
- What are the Top 10 most frequent procedures performed and their average base cost?
- What are the Top 10 highest-cost procedures and the number of times they were performed?
- What is the average total claim cost, broken down by payer?

#### 3. Patient Behavior Analysis
- How many unique patients were admitted each quarter over time?
- How many patients were readmitted within 30 days of a previous encounter?
- Which patients had the most readmissions?
---

### ⚙️ Implementation

#### Data Preprocessing (Python)
- Hospital dataset provided in two database tables (patients, payers) plus CSVs (encounters, organization, procedures).
- Steps:
  1. Load CSVs and append records into the hospital database.
  2. Convert fields to correct data types (e.g., datetime).

#### SQL Analysis
**Encounters Overview**
- Total encounters per year → Extract year with STRFTIME("%Y", column).
- Encounters by class per year → Use CTEs and joins to calculate yearly totals and class distributions, then compute percentages.
- Length of stay → Compute duration (in hours) per encounter, bucket into <24H vs >24H, and aggregate by year.

**Cost & Coverage**
- Queries to assess payer coverage, procedure frequencies, and cost analysis using aggregation and ranking.

**Patient Behavior**
- Track quarterly admissions, identify 30-day readmissions, and highlight high-frequency patients.
---
✍️......
