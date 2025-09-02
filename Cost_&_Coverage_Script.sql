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