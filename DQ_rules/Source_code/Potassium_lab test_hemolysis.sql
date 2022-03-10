/**Hemolysis of lab samples**/


---Encounters with NULL values

SELECT COUNT (DISTINCT l.encounterid) 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
WHERE l.result_num IS NULL ;
 
---Encounters with hemolyzed results
 
SELECT COUNT (DISTINCT encounterid) 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM 
WHERE result_num IS NULL 
AND  (raw_result LIKE 'HEMOLYZED%' or raw_result LIKE 'hem%' ) ;
 
 
---Encounters with hemolyzed test result at the emergency room

SELECT COUNT (DISTINCT e.encounterid)  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l 
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.result_num IS Null  
AND (l.raw_result LIKE 'HEMOLYZED%' OR l.raw_result LIKE 'hem%' )  
AND e.enc_type = 'ED';
 

---Total number of encounters with hemolyzed potassium test 
 
SELECT COUNT (DISTINCT l.encounterid)
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.lab_loinc = '2823-3' 
AND l.result_num IS Null 
AND (raw_result LIKE 'HEMOLYZED%' OR raw_result LIKE 'hem%' );
 

---Total number of encounter with hemolyzed potassium test at the ED
 
SELECT count (DISTINCT l.encounterid) 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.lab_loinc = '2823-3' 
AND l.result_num IS Null 
AND (raw_result LIKE 'HEMOLYZED%' OR raw_result LIKE 'hem%' ) 
AND e.enc_type IN ('ED');

---Encounters with hemolyzed results over 10 years
 
SELECT COUNT (DISTINCT e.encounterid),
             e.enc_type, 
             date_part(YEAR, l.result_date) AS resultyear   
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM 
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e  ON e.encounterid = l.encounterid
WHERE l.result_num IS Null  
AND (l.raw_result LIKE 'HEMOLYZED%' OR l.raw_result LIKE 'hem%' )      
GROUP BY e.enc_type, resultyear
ORDER BY e.enc_type, resultyear DESC;
 
---Encounter with hemolyzed potassium results over 10 years*

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

