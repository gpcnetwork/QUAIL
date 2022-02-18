## Using drug prescriptions and lab orders to check for quality of care 

1.	To check for quality of care for patients who have encounters for ambulatory visit in PCORnet database, we used metformin (oral hypoglycemic drug used to treat type 2 diabetes mellitus ) prescriptions and if blood glucose or HBA1c lab test  was ordered before the prescription of this drug. We found 771 patients who had metformin prescriptions during their ambulatory visit without any order for blood sugar or HBA1c lab test. 

*Check for number of patients had metformin prescription who have ambulatory visit*
```SQL
SELECT COUNT (DISTINCT p.encounterid) AS encout,     COUNT (DISTINCT p.patid) AS pt, 
                    e.enc_type 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING p ON p.encounterid = e.encounterid
WHERE  p.raw_rxnorm_cui = '6809'
GROUP BY e.enc_type;

```
```SQL
SELECT COUNT (DISTINCT p.encounterid) AS encout, COUNT (DISTINCT p.patid) AS pt 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING p ON p.encounterid = e.encounterid
WHERE  p.raw_rxnorm_cui = '6809' 
AND e.enc_type = 'AV' 
```
*Find the patients who had metformin prescription and without order for blood glucose or HBA1c lab test*
```SQL
SELECT COUNT (DISTINCT p.encounterid) AS encout, COUNT (DISTINCT p.patid) AS pt  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING p
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.encounterid = p.encounterid
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e ON e.encounterid = p.encounterid
WHERE  p.raw_rxnorm_cui = '6809' 
AND e.enc_type = 'AV'  
AND l.patid NOT IN (SELECT l.patid 
                    FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
                    WHERE l.lab_loinc IN ('4548-4','41653-7','2339-0','2345-7','32016-8')) ;

```
