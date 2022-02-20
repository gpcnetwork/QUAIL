/**Check for ETL issues in the PCORnet database by tracking gentamicin medication and order of creatinine lab test for inpatient encounters**/  


---Check using 2021 cyle

SELECT pp.PRESCRIBINGID, pp.* 
FROM PCORNET_CDM.CDM_C009R020.ENCOUNTER pe
LEFT JOIN PCORNET_CDM.CDM_C009R020.PRESCRIBING pp ON pp.encounterid = pe.encounterid
WHERE pe.ENC_TYPE= 'IP' 
AND pp.RAW_RX_MED_NAME LIKE 'gentamicin%' 
AND pe.ADMIT_DATE BETWEEN '2020-1-1' AND '2020-2-1' AND pp.encounterid = *******
ORDER BY  pp.RX_ORDER_DATE, pp.RX_ORDER_Time, pp.Rx_start_date;

---Check using 2022 after fixing the ETL glitch

SELECT pp.PRESCRIBINGID, pp.* 
FROM PCORNET_CDM.CDM_C010R022.ENCOUNTER pe
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRESCRIBING pp ON pp.encounterid = pe.encounterid
WHERE pe.ENC_TYPE= 'IP' 
AND pp.RAW_RX_MED_NAME LIKE 'gentamicin%' 
AND pe.ADMIT_DATE BETWEEN '2020-1-1' AND '2020-2-1' AND pp.encounterid =******* 
ORDER BY  pp.RX_ORDER_DATE, pp.RX_ORDER_Time, pp.Rx_start_date;

