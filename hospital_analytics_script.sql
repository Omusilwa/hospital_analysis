-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
SELECT STRFTIME("%Y", "START" ) AS EncounterYear,
		COUNT(*) AS TotalEncounter
FROM encounters
GROUP BY STRFTIME("%Y", "START" ) 
ORDER BY EncounterYear ;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
WITH class_count AS (SELECT STRFTIME("%Y", "START" ) AS EncounterYear,
						COUNT(*) AS ClassEncounter_Count, ENCOUNTERCLASS 
						FROM encounters
						GROUP BY STRFTIME("%Y", "START" ), ENCOUNTERCLASS),

	total_count AS (SELECT STRFTIME("%Y", "START" ) AS EncounterYear,
						COUNT(*) AS TotalEncounter
						FROM encounters
						GROUP BY STRFTIME("%Y", "START")
)
SELECT c.EncounterYear, c.ENCOUNTERCLASS,
		ROUND(100.0* c.ClassEncounter_Count/t.TotalEncounter,2) AS pct_of_totalencounter
FROM class_count c JOIN total_count t
ON c.EncounterYear = t.EncounterYear
ORDER BY t.EncounterYear, pct_of_totalencounter;

-- c. What percentage of encounters were over 24 hours versus under 24 hours?
WITH duration AS (SELECT STRFTIME("%Y", "START" ) AS EncounterYear,
							ROUND((JULIANDAY("STOP") -JULIANDAY("START"))*24,2) AS hours_stayed
						FROM encounters e 
						WHERE START IS NOT NULL AND STOP IS NOT NULL),

buckets_24hr AS (SELECT EncounterYear,
				 CASE WHEN hours_stayed >= 24.0 THEN ">24H" ELSE "<24H" END AS Length_of_Stay
				FROM duration),
		
yr_agg AS (SELECT EncounterYear, 
					Length_of_Stay,
					COUNT(*) AS Encounter_Count
			FROM buckets_24hr 
			GROUP BY EncounterYear, Length_of_Stay
	)

SELECT EncounterYear, 
		Length_of_Stay,
		ROUND(100.0 * Encounter_Count/
				SUM(Encounter_Count) 
				OVER(PARTITION BY EncounterYear),2) AS pct_of_total
FROM yr_agg
ORDER BY EncounterYear, Length_of_Stay;


-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT COUNT(*) AS ZeroCoverage_Encounters,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM encounters) ,0) AS pct_of_total
FROM encounters e 
WHERE e.PAYER_COVERAGE <= 0;

-- a(i) ZeroCoverage_Encounters Class comparison:
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

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT  p.DESCRIPTION , COUNT(*) AS Encounter_Count,
		ROUND(AVG(p.BASE_COST),2) AS Average_Cost
FROM procedures p 
GROUP BY DESCRIPTION 
ORDER BY Encounter_Count DESC 
LIMIT 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT  TRIM(LOWER(p.DESCRIPTION)) AS Descrption, ROUND(AVG(p.BASE_COST),2) AS Average_Cost,
		COUNT(*) AS Encounter_Count
FROM procedures p 
GROUP BY DESCRIPTION 
ORDER BY Average_Cost DESC 
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT e.ENCOUNTERCLASS, COUNT(*) AS Encounter_Count,
	ROUND(AVG(e.TOTAL_CLAIM_COST),2) AS Average_Claim_Cost, 
	p.NAME 
FROM encounters e INNER JOIN payers p 
ON e.PAYER = p.Id 
GROUP BY e.ENCOUNTERCLASS;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- a. How many unique patients were admitted each quarter over time?
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
		
-----
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




-- c. Which patients had the most readmissions?
