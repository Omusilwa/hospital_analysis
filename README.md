# Encounter Insights: Patient and Ops Analytics

In today’s healthcare landscape, where patient-centered care and operational excellence are key to success, the Encounter Insights: Patient and Ops Analytics Project demonstrates the strategic value of health analytics. Using a comprehensive encounter dataset, the project evaluates critical aspects of hospital operations and patient experience, uncovering insights that can drive better service delivery and clinical outcomes.

Through focused SQL-based analysis, complex data is transformed into actionable intelligence—tracing patient journeys, identifying satisfaction drivers, and highlighting efficiency gaps. These insights enable leadership to make informed, data-driven decisions that enhance performance, streamline workflows, and strengthen the overall patient experience

---
## **Dataset Overview**

The analysis draws on a relational healthcare database,featuring five key tables that collectively capture the full patient encounter lifecycle:

- Encounters Table: Records detailed visit information, including encounter dates, visit types, encounter reason, and associated costs—forming the foundation for operational and patient flow analysis.

- Organization Table: Contains information on healthcare facilities, and addresses, enabling evaluation of performance across organizational structures.

- Patient Table: Includes demographic and identification data that support segmentation and trend analysis across age, gender, and other patient characteristics.

- Payer Table: Holds information on insurance types, coverage, and payment categories, providing insights into financial and reimbursement patterns.

- Procedure Table: Details medical procedures performed during each encounter, facilitating analysis of treatment patterns, procedure utilization, and resource allocation

---
## **🎯 Project Objectives**

##### 1. Analyze Encounter Trends:
- Examine the total number of patient encounters across years, identify the distribution of encounter types (such as outpatient, emergency, and inpatient), and assess the duration of visits to uncover patterns in hospital activity and service utilization.

##### 2. Evaluate Cost and Coverage Dynamics:
- Explore payer coverage rates, procedure costs, and claim distributions to reveal financial performance insights—highlighting high-cost procedures, common treatments, and gaps in insurance coverage.

##### 3. Understand Patient Behavior and Readmissions:
- Track patient admissions and readmissions over time to identify utilization trends, frequent readmissions, and potential areas for improving continuity of care and patient outcomes.

---
# **⚙️ Implementation**
---

### **Analyze Encounter Trends:**

**A). Total number of patient encounters across years**

**Output:**

<img width="465" height="400" alt="image" src="https://github.com/user-attachments/assets/705e0b9a-208c-4a7c-96ee-2940e7113d29" />

**Insights:**

Over the years, patient encounters have shown a steady upward trend, reflecting growing demand for healthcare services. Notably, `2014` and `2021` stood out with sharp increases, reaching `3,885` and `3,530 encounters` respectively highlighting periods of heightened activity that likely required additional staffing and operational resources.

However, `2022` marked a striking drop to just `220 encounters`, the lowest point in the decade. This sudden decline may point to reduced access to care, patient leakage to other facilities, or even improvements in community health that lowered the need for hospital visits. Together, these trends tell a story of evolving patient engagement and shifting service demand over time.

---

**B). Distribution of encounter types**

**Output:**

<img width="718" height="487" alt="image" src="https://github.com/user-attachments/assets/66d470ac-d6a7-4234-b307-25a8cc754d78" />

**Insights:**

Over the years, **Ambulatory** and **Outpatient encounters** have consistently dominated care delivery, accounting for nearly `60%` and `40%` of total encounters, respectively. This strong presence reflects a growing preference for cost-effective, convenient care often linked to same-day procedures, diagnostics, and integrated care networks that keep patients out of the hospital.

Meanwhile, **Urgent Care** and **Wellness** visits remain below `20%` and `10%`, and **Inpatient encounters** have dropped to under `5%`. Together, these figures tell a powerful story: healthcare delivery is shifting toward prevention, early intervention, and shorter or home-based care models. The trend underscores success in reducing admissions while meeting patients where they are—more efficiently, and often more effectively.

---

**C). Duration of visits**

**Output:**

<img width="733" height="487" alt="image" src="https://github.com/user-attachments/assets/63a626ee-ab2f-4129-bc5c-45ab321c7d3c" />

**Insights:**

The data reveals that the average length of stay (LOS) for most encounters is less than `24 hours`, accounting for over `95%` of all visits, while only `5%` or fewer extend beyond a full day. This short stay pattern aligns closely with the high proportion of `Ambulatory` and `Outpatient` encounters, which together make up the majority of hospital activity.

The correlation suggests a healthcare model increasingly focused on efficient same-day care, where diagnostics, minor procedures, and treatments are completed without the need for extended hospitalization. This trend not only enhances patient convenience but also reflects the system’s success in managing capacity, reducing costs, and emphasizing preventive and coordinated care pathways that minimize unnecessary admissions

----
----

### 2. Evaluate Cost and Coverage Dynamics:

**A). Explore payer coverage rates**

**Output:**

<img width="753" height="157" alt="image" src="https://github.com/user-attachments/assets/9e341eab-7c08-419c-b955-598de5cf5e07" />

**Insight:**

Nearly half `(49%)` of encounters are not covered, representing a major opportunity to  reduce out-of-pocket costs for patients. Addressing this gap could enhance both care access and financial performance

**B). Procedure costs**

**Output:**

<img width="1187" height="346" alt="image" src="https://github.com/user-attachments/assets/125c9cf7-a259-4609-9a51-64d6fc86d88c" />

**Insight:**

Some procedures, though performed infrequently, exert a major influence on the institution’s overall financial picture. They represent significant cost and revenue drivers that require close attention for budgeting, payer negotiations, and cost-control planning.

For instance, the most expensive procedure, `Admission to ICU` incurred a total cost of `$206,260.4` from just `15 encounters`. This single case highlights how a small number of high-cost events can substantially affect operating margins and resource allocation

**D). Exploring Claim Cost**

**Output:**

<img width="1022" height="275" alt="image" src="https://github.com/user-attachments/assets/6f5d03e7-521b-4c71-a97d-0a5da9aba15f" />

**Insights:**

Claim Cost reveals an important trend: most `ambulatory`, `wellness` and `outpatient` visits occur without insurance coverage. These represent out-of-pocket payments, forming the largest share of all encounters in the institution. This pattern not only highlights patients’ financial burden but also underscores potential gaps in coverage accessibility.

On the other hand, `inpatient`, `urgent care`, and `emergency` encounters, typically unplanned and high-cost are more likely to be covered. This makes sense, as these are critical, unscheduled events where insurance protection truly matters.

These insights are valuable for financial planning and payer negotiations. Understanding which services are most often uncovered, and which payers systematically reimburse higher or lower amounts can guide more balanced contract strategies and help strengthen the institution’s financial resilience

-----
-----

### **3. Patient Behavior**

**A). Quarterly Trend in Unique Patient Admissions**

**Output**

<img width="767" height="488" alt="image" src="https://github.com/user-attachments/assets/d5136c9a-f8c3-4a05-8ba8-c660ae205aed" /> 

**Insights:**

Tracking unique patient admissions each quarter reveals uncovers the rhythm of care within the institution. These patterns reflect seasonal shifts in disease prevalence, helping us understand when demand peaks and how to align resources and staffing accordingly.

On average, unique admissions account for about `35%` year-on-year, but certain quarters stand out. For example, `Q4 of 2013` and `2016` recorded unusually high admissions; `52% and 51%` respectively, while `Q4 of 2019` saw a steep drop to just `6.7%`. These fluctuations act as signals, pointing to possible external factors such as epidemic outbreaks, policy changes, or service delivery shifts.

Recognizing and preparing for these cycles can help the organization optimize capacity, ensure adequate staffing, and improve readiness for unexpected surges or downturns in patient demand.



**B. Patients readmitted within 30 days**


Interpretation

- Readmission within 30 days: Core quality/safety indicator.
    - High % suggests poor discharge planning, inadequate follow-up, or high illness burden.
    - Low % indicates better care transitions
----
#### **Summary of Analysis**

**Learnings**

- Patient encounters can be analyzed by year, quarter, month, week, day, or hour using SQLite date functions.
- Coverage metrics (covered vs. zero coverage) reveal the financial health of encounters and highlight equity gaps.
- Length of stay (LOS) buckets (<24h vs ≥24h) provide insights into resource utilization and inpatient workload.
- Procedures analysis identifies the most frequent and costliest services, informing operational and financial priorities.
- Readmission analysis (30-day) links encounters chronologically by patient to measure care quality and discharge effectiveness.
- Data quality checks (negative stays, extreme gaps, NULL values) are essential to ensure valid conclusions.

**Impact on Patient Care**

- Identifies high-risk periods (quarterly admission surges) for better staffing and preparedness.
- Highlights gaps in continuity of care through 30-day readmission metrics, guiding post-discharge interventions.
- Detects access barriers when zero coverage is high, supporting outreach and patient support programs.
- Provides insight into clinical practice patterns (frequent and costly procedures), enabling targeted quality improvement.

**Business Value for the Hospital**

- Financial sustainability: quantifying uncompensated care (zero coverage) helps anticipate revenue risks.
- Operational efficiency: LOS and encounter trends support capacity planning, bed management, and workforce allocation.
- Regulatory alignment: 30-day readmission tracking aligns with quality benchmarks and can mitigate financial penalties.
- Strategic planning: procedure mix and cost insights guide investment decisions and service line prioritization.
- Equity and reputation: demonstrating awareness of access and coverage issues strengthens the hospital’s public trust and policy influence.
