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
1. Total encounters each year → Extract year with STRFTIME("%Y", column).
2. Percentage of Encounters by Encounter class per year
3. Length of stay (<24H vs >24H), aggregate by year.

**Cost & Coverage**
1. Queries to assess payer coverage,
2. procedure frequencies, and
3. cost analysis using aggregation and ranking.

**Patient Behavior**
1. Track quarterly admissions
- Interpretation & Decision Impact
      - Quarter: strategic planning, budgets, seasonal programs.
  
      - Month: staffing templates, clinic schedules.
      - Week: clinic rota balancing, outreach timing.
      - Day/Hour: shift staffing, fast-track windows, lab/pharmacy coverage.
  
2. Identify 30-day readmissions.
3. Highlight high-frequency patients.
---
✍️......
