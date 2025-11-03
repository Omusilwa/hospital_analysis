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
<img width="857" height="428" alt="image" src="https://github.com/user-attachments/assets/f1ebb1c4-ee17-42f5-9368-846f016ca21b" />

**Insights:**

Over the years, patient encounters have shown a steady upward trend, reflecting growing demand for healthcare services. Notably, `2014` and `2021` stood out with sharp increases, reaching `3,885` and `3,530 encounters` respectively highlighting periods of heightened activity that likely required additional staffing and operational resources.

However, `2022` marked a striking drop to just `220 encounters`, the lowest point in the decade. This sudden decline may point to reduced access to care, patient leakage to other facilities, or even improvements in community health that lowered the need for hospital visits. Together, these trends tell a story of evolving patient engagement and shifting service demand over time.

---

**B). Distribution of encounter types**

**Output:**
<img width="802" height="637" alt="image" src="https://github.com/user-attachments/assets/ec04d7ff-94a6-46a6-8035-602bab7e711f" />


**Insights:**

Over the years, **Ambulatory** and **Outpatient encounters** have consistently dominated care delivery, accounting for nearly `60%` and `40%` of total encounters, respectively. This strong presence reflects a growing preference for cost-effective, convenient care often linked to same-day procedures, diagnostics, and integrated care networks that keep patients out of the hospital.

Meanwhile, **Urgent Care** and **Wellness** visits remain below `20%` and `10%`, and **Inpatient encounters** have dropped to under `5%`. Together, these figures tell a powerful story: healthcare delivery is shifting toward prevention, early intervention, and shorter or home-based care models. The trend underscores success in reducing admissions while meeting patients where they are—more efficiently, and often more effectively.

---

**C). Duration of visits**

**Output:**

<img width="642" height="702" alt="image" src="https://github.com/user-attachments/assets/b067e824-cee0-4164-af7d-6dd62bfbd746" />



**Insights:**

The data reveals that the average length of stay (LOS) for most encounters is less than `24 hours`, accounting for over `95%` of all visits, while only `5%` or fewer extend beyond a full day. This short stay pattern aligns closely with the high proportion of `Ambulatory` and `Outpatient` encounters, which together make up the majority of hospital activity.

The correlation suggests a healthcare model increasingly focused on efficient same-day care, where diagnostics, minor procedures, and treatments are completed without the need for extended hospitalization. This trend not only enhances patient convenience but also reflects the system’s success in managing capacity, reducing costs, and emphasizing preventive and coordinated care pathways that minimize unnecessary admissions

----

### **Cost & Coverage**

This analysis complements the story by showing what is most common, what is most expensive, and who pays—and how much.

**A. Queries to assess payer coverage and percentage of total encounter each represent.**

Implementation

Query 1 – Overall zero coverage & % of all encounters

  - Filter encounters where `payer_coverage` <= 0.
  - Count those encounters.
  - Divided by all encounters to get the overall percentage.
  - Round to a presentable integer.

```sql
SELECT COUNT(*) AS ZeroCoverage_Encounters,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM encounters) ,0) AS pct_of_total
FROM encounters e 
WHERE e.PAYER_COVERAGE <= 0;
```
**Output:**
<img width="938" height="138" alt="image" src="https://github.com/user-attachments/assets/bcaaabd3-cb0b-4dfa-ab8f-3493e8934ebd" />


Query 2 – Compare “ZeroCover” vs “Covered”

  - Bucket each encounter into `ZeroCover` vs `Covered` in a CTE.
  - Divide each bucket by all encounters (same denominator) to make shares comparable.
  - Group by `Coverage_Status` and count.
  - Order by percentage or by status for stable presentation.

```sql
WITH coverage AS (SELECT 
					CASE 
						WHEN PAYER_COVERAGE <= 0 OR PAYER_COVERAGE IS NULL THEN "ZeroCover" ELSE "Covered" 
						END AS Coverage_Status
					FROM encounters)

SELECT Coverage_Status, COUNT(*) Encounter_Count,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM encounters) ,0) AS pct_of_total
FROM coverage
GROUP BY Coverage_Status 
ORDER BY pct_of_total ;
```
**Output:**
<img width="1043" height="285" alt="image" src="https://github.com/user-attachments/assets/edca2be6-e461-407d-890e-92b3c4d1f964" />

Interpretation:
- Overall % `ZeroCover`: High share - larger uncompensated-care burden; expect bad debt/charity care to rise.
- Low share - more reimbursable workload; better revenue stability.

**B. Top 10 most frequent procedures**

Implementation:
    - Aggregate by `DESCRIPTION` from procedures.
    - Count rows = frequency of each procedure.
    - Compute average `BASE_COST`.
    - Order by frequency descending.
    - Limit output to 10 rows.

```sql
-- b. Top 10 most frequent procedures performed and the average base cost for each?
SELECT  p.DESCRIPTION , COUNT(*) AS Encounter_Count,
		ROUND(AVG(p.BASE_COST),2) AS Average_Cost
FROM procedures p 
GROUP BY DESCRIPTION 
ORDER BY Encounter_Count DESC 
LIMIT 10;
```
**Output:**
<img width="1080" height="342" alt="image" src="https://github.com/user-attachments/assets/0fc12b7c-58b4-4dcb-a7b6-df833736c508" />

Interpretation

- Most frequent procedures;
    - Shows workload drivers: what the hospital does most often.
    - Often these are routine, lower-cost interventions.
      
High frequency may point to resource allocation needs (staff, supplies).

**C.Top 10 highest average-cost procedures**

Implementation:

- Normalize `DESCRIPTION` (e.g., `TRIM(LOWER(...))`) to reduce duplicates from inconsistent casing.
- Compute average `BASE_COST` and encounter count.
- Order by average cost descending.
- Limit output to 10 rows
  
```sql
SELECT  TRIM(LOWER(p.DESCRIPTION)) AS Descrption, ROUND(AVG(p.BASE_COST),2) AS Average_Cost,
		COUNT(*) AS Encounter_Count
FROM procedures p 
GROUP BY DESCRIPTION 
ORDER BY Average_Cost DESC 
LIMIT 10;
```
**Output:**
<img width="1187" height="346" alt="image" src="https://github.com/user-attachments/assets/125c9cf7-a259-4609-9a51-64d6fc86d88c" />

Interpretation:

- Highest-cost procedures
    - Identifies financially intensive services.
    - These may not occur often but heavily impact costs/revenue.
      
Useful for budgeting, negotiation with payers, and identifying candidates for cost-control strategies.

**D. Average claim cost per payer and encounter class**

Implementation
- Join `encounters` to `payers` on `payer_id`.
- Group by `ENCOUNTERCLASS`.
- Count encounters and compute average `TOTAL_CLAIM_COST`.
- Present payer + encounter class breakdown.

```sql
SELECT e.ENCOUNTERCLASS, COUNT(*) AS Encounter_Count,
	ROUND(AVG(e.TOTAL_CLAIM_COST),2) AS Average_Claim_Cost, 
	p.NAME 
FROM encounters e INNER JOIN payers p 
ON e.PAYER = p.Id 
GROUP BY e.ENCOUNTERCLASS;
````
**Output:**
<img width="1022" height="275" alt="image" src="https://github.com/user-attachments/assets/6f5d03e7-521b-4c71-a97d-0a5da9aba15f" />

Interpretation:
- Average claim cost by payer & encounter class;
    - Compares utilization and cost patterns across payer contracts.
    - High averages may reflect sicker patients, higher procedure intensity, or inefficient care delivery.

Useful for financial planning and payer negotiations: some payers may systematically reimburse lower/higher amounts.

Encounter class split (inpatient vs outpatient vs ED) shows where costs concentrate.

-----

### **Patient Behavior**

**A. Unique patients admitted each quarter over time**

Implementation plan

  1. Extract `EncounterYear` from `START` (admission date).
  2. Compute quarter: `(month – 1)/3 + 1`.
  3. Filter for inpatient encounters (`LOWER(encounterclass) = 'inpatient'`).
  4. Count unique patients per year–quarter (`COUNT(DISTINCT Id`)
  5. Use a window function to calculate the % of yearly admissions each quarter contributed.
  6.  Order results by year and quarter.

```sql
WITH qtr AS (SELECT STRFTIME("%Y", "START" ) AS EncounterYear,
				COUNT(DISTINCT (e.Id)) AS Patient_Count, 
				(CAST(STRFTIME("%m", "START" ) AS INT)-1)/3 + 1 AS EncounterQuarter 		
			FROM encounters e 
			WHERE LOWER(e.ENCOUNTERCLASS) = "inpatient"
			GROUP BY EncounterYear, EncounterQuarter 
			
			)
SELECT 	EncounterYear,
		Patient_Count,
		EncounterQuarter,
		ROUND(100.0 * Patient_Count/ SUM(Patient_Count) 
				OVER(PARTITION BY EncounterYear),2) AS pct_of_year
FROM qtr 
ORDER BY EncounterYear, EncounterQuarter ;
```
**Output**
<img width="913" height="337" alt="image" src="https://github.com/user-attachments/assets/6ff06ee5-8210-496b-9074-1008b3139b2f" />

Interpretation

- Shows seasonality of admissions.
    - pct_of_year highlights distribution—if Q3 = 40%, capacity/staffing may need to shift.
    - Outliers (very low/high quarter %s) can indicate unusual events (e.g., epidemics, policy change).


**B. Patients readmitted within 30 days**

Implementation plan

1. Use ROW_NUMBER() to order encounters chronologically per patient.
2. Self-join each encounter with its next for the same patient.
3. Calculate gap: JULIANDAY(next.START) - JULIANDAY(curr.STOP).
4. Flag if gap is BETWEEN 0 AND 30.
5. Return index encounter, discharge date, readmit encounter, readmit date, and readmit flag.
6. (validation): Additional query checks negatives (bad timestamp order) and >365d gaps (potential outliers or long gaps).

```sql
-- b. How many patients were readmitted within 30 days of a previous encounter?
WITH ordered AS (SELECT 	e.Id AS Encounter_Id, 
							e. START, 
							e. STOP, 
							e. PATIENT,
						ROW_NUMBER() 
							OVER(PARTITION BY e.PATIENT ORDER BY START) AS rn
					FROM encounters e 
					WHERE e.START IS NOT NULL AND e.STOP IS NOT NULL
),

paired AS (
			SELECT 	curr.PATIENT,
					curr.Encounter_Id AS current_encounter,
					curr."STOP" AS discharge_date,
					nxt.Encounter_Id AS readmit_encounter,
					nxt."START" AS Readmit_Date,
					ROUND(JULIANDAY(nxt."START") - JULIANDAY(curr."STOP"),0) AS days_to_readmit
			FROM ordered curr
			LEFT JOIN ordered nxt
				ON curr.PATIENT = nxt.PATIENT AND nxt.rn = curr.rn + 1
		)
SELECT 	PATIENT,
		current_encounter,
		discharge_date,
		readmit_encounter,
		days_to_readmit,
		CASE WHEN days_to_readmit BETWEEN 0 AND 30 THEN 1 ELSE 0 END AS readmit_30d
FROM paired
ORDER BY PATIENT, discharge_date;
```
```sql
WITH ordered AS (SELECT 	e.Id AS Encounter_Id, 
							e. START, 
							e. STOP, 
							e. PATIENT,
						ROW_NUMBER() 
							OVER(PARTITION BY e.PATIENT ORDER BY START) AS rn
					FROM encounters e 
					WHERE e.START IS NOT NULL AND e.STOP IS NOT NULL
),

paired AS (
			SELECT 	curr.PATIENT,
					curr.Encounter_Id AS current_encounter,
					curr."STOP" AS discharge_date,
					nxt.Encounter_Id AS readmit_encounter,
					nxt."START" AS Readmit_Date,
					ROUND(JULIANDAY(nxt."START") - JULIANDAY(curr."STOP"),0) AS days_to_readmit
			FROM ordered curr
			LEFT JOIN ordered nxt
				ON curr.PATIENT = nxt.PATIENT AND nxt.rn = curr.rn + 1
		)
		
SELECT 	SUM(days_to_readmit < 0) AS negatives,
		SUM(days_to_readmit > 365) AS over_year
FROM (paired);
```

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
