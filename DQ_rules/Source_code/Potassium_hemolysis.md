## Hemolysis of lab samples
When we implemented the rule to check for valid lab values, we found many encounters that have a result number that was NULL value. We further checked the reasons to populate the result number column with a null value. The raw result was the column populated with text to explain the reason. We found hemolyzed sample was one of the major reasons and specifically for potassium results. 

The steps we followed to check for hemolyzed samples:

 1.	We checked for all distinct encounters that have lab tests result populated as a null value (2,361,301). Then filter that to the hemolyzed sample (80,342). 

*Encounters with NULL values*
 ```SQL
SELECT COUNT (DISTINCT l.encounterid) 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
WHERE l.result_num IS NULL ;
 ```
 *Encounters with hemolyzed results*
 ```SQL
SELECT COUNT (DISTINCT encounterid) 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM 
WHERE result_num IS NULL 
AND  (raw_result LIKE 'HEMOLYZED%' or raw_result LIKE 'hem%' ) ;
 ```
 2.	Then we checked for a hemolyzed sample at the emergency department (ED) and found the encounter number (15,975).

 *Encounters with hemolyzed test result at the emergency room*
 ```SQL
SELECT COUNT (DISTINCT e.encounterid)  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l 
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.result_num IS Null  
AND (l.raw_result LIKE 'HEMOLYZED%' OR l.raw_result LIKE 'hem%' )  
AND e.enc_type = 'ED';
 ```
 3.	Then we added more filters to specify for serum potassium test by using lab LOINC code (2823-3) and we found that the total number for encounter for potassium test with the hemolyzed result (36,372) and the number of encounters for potassium test with the hemolyzed result at the ED (6,511).

 *Total number of encounters with hemolyzed potassium test *
 ```SQL
SELECT COUNT (DISTINCT l.encounterid)
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.lab_loinc = '2823-3' 
AND l.result_num IS Null 
AND (raw_result LIKE 'HEMOLYZED%' OR raw_result LIKE 'hem%' );
 ```

 *Total number of encounter with hemolyzed potassium test at the ED*
 ```SQL
SELECT count (DISTINCT l.encounterid) 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.lab_loinc = '2823-3' 
AND l.result_num IS Null 
AND (raw_result LIKE 'HEMOLYZED%' OR raw_result LIKE 'hem%' ) 
AND e.enc_type IN ('ED');
 ```
 4.	Then we checked for the annual trend for the prevalence of hemolyzed samples and we found the number of encounters that have hemolyzed results in the emergency room increasing significantly. For example, the number of encounters that have hemolyzed results in 2010 was (363) which increased to (1,867). The same trend seen with encounters have potassium tests with hemolyzed results in 2010 (231) raised to (772) in 2020.

 *Encounters with hemolyzed results over 10 years*
 ```SQL
SELECT COUNT (DISTINCT e.encounterid),
             e.enc_type, 
             date_part(YEAR, l.result_date) AS resultyear   
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.result_num IS Null  
AND (l.raw_result LIKE 'HEMOLYZED%' OR l.raw_result LIKE 'hem%' )      
GROUP BY e.enc_type, resultyear
ORDER BY e.enc_type, resultyear DESC;
 ```
*Encounter with hemolyzed potassium results over 10 years*
```SQL
 SELECT COUNT (DISTINCT e.encounterid),
               e.enc_type, 
               date_part(YEAR, l.result_date) AS resultyear   
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l 
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.result_num IS Null  
AND lab_loinc = '2823-3' 
AND (l.raw_result LIKE 'HEMOLYZED%' OR l.raw_result LIKE 'hem%' ) 
GROUP BY e.enc_type, resultyear
ORDER BY e.enc_type, resultyear DESC;
```