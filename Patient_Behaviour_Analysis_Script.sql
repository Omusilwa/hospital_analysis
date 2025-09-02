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
