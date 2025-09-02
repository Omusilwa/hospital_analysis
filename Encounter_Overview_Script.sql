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
