## Check for ETL issues in the PCORnet database by tracking gentamicin medication and order of creatinine lab test for inpatient encounters   

Using the PCORnet database (2021 cycle), we used the prescribing table joined with the encounter table to track the prescription time of gentamicin in the period between 2020-1-1 and 2020-2-1. We found duplication of records in prescribing table which was due to an ETL issue. We informed the software engineering team who worked on this problem and fixed the 2022 cycle.

*Check using 2021 cyle*
```SQL
SELECT pp.PRESCRIBINGID, pp.* 
FROM PCORNET_CDM.CDM_C009R020.ENCOUNTER pe
LEFT JOIN PCORNET_CDM.CDM_C009R020.PRESCRIBING pp ON pp.encounterid = pe.encounterid
WHERE pe.ENC_TYPE= 'IP' 
AND pp.RAW_RX_MED_NAME LIKE 'gentamicin%' 
AND pe.ADMIT_DATE BETWEEN '2020-1-1' AND '2020-2-1' AND pp.encounterid = *******
ORDER BY  pp.RX_ORDER_DATE, pp.RX_ORDER_Time, pp.Rx_start_date;
```
*Check using 2022 after fixing the ETL glitch*
```SQL
SELECT pp.PRESCRIBINGID, pp.* 
FROM PCORNET_CDM.CDM_C010R022.ENCOUNTER pe
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRESCRIBING pp ON pp.encounterid = pe.encounterid
WHERE pe.ENC_TYPE= 'IP' 
AND pp.RAW_RX_MED_NAME LIKE 'gentamicin%' 
AND pe.ADMIT_DATE BETWEEN '2020-1-1' AND '2020-2-1' AND pp.encounterid =******* 
ORDER BY  pp.RX_ORDER_DATE, pp.RX_ORDER_Time, pp.Rx_start_date;

```
