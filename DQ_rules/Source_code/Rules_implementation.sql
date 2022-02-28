/**Rules to assess domain constraints**/
/*Demographic data elements rule*/  


---The number of whole patients

SELECT COUNT (DISTINCT patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC 
;


---The number of records with discrepancies

SELECT * 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC
WHERE birth_date> '01-JAN-1850';


---The number of patients with discrepancy

SELECT COUNT (DISTINCT patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC 
WHERE birth_date < '01-JAN-1850';

/*Observation data elements (height, weight, blood pressure values)*/

---The number of the whole cohort

SELECT COUNT (DISTINCT patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_VITAL;

---The number of records with discrepancies

WITH boimeterict AS (SELECT  patid, 
                             ht, 
                             wt , 
                             diastolic, 
                             systolic 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_VITAL
WHERE ht < 10 OR ht > 300 AND  wt < 2.2 OR  wt > 660 
UNION ALL 
SELECT patid, 
       ht, 
       wt , 
       diastolic, 
       systolic 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_VITAL
WHERE diastolic < 20 OR diastolic > 350 AND systolic < 20 OR systolic >350 ) 
SELECT * FROM boimeterict;

---Count of patients with discrepancy

WITH boimeterict AS (SELECT  patid , 
                            ht, 
                            wt , 
                            diastolic, 
                            systolic 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_VITAL
WHERE ht < 10 OR ht > 300 AND  wt < 2.2 OR  wt > 660 
UNION ALL 
SELECT  patid, 
        ht, 
        wt , 
        diastolic, 
        systolic 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_VITAL
WHERE diastolic < 20 OR diastolic > 350 AND systolic < 20 OR systolic >350 ) 
SELECT COUNT (DISTINCT patid) FROM boimeterict;


/*Valid lab values*/  

---The number of whole cohort

SELECT COUNT (DISTINCT l.patid)
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
JOIN ANALYTICSDB.QARULES.LAB_VALID_CHECKINGI v ON loinc_code = l.lab_loinc; 

---The number of records with discrepancies

SELECT DISTINCT l.patid,
                 l.lab_loinc,  
                 l.result_num, 
                 l.result_unit,raw_lab_name , 
                 v.lab_test, 
                 v. valid_low, 
                 v.valid_high, 
                 v.units, 
                 v.loinc_code 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
JOIN ANALYTICSDB.QARULES.LAB_VALID_CHECKINGI v ON V.loinc_code = l.lab_loinc
WHERE l.result_num < v.valid_low OR l.result_num > valid_high OR l.result_unit <> v.units; 

---The number of patients with discrepancies

SELECT COUNT (DISTINCT l.patid)   
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
JOIN ANALYTICSDB.QARULES.LAB_VALID_CHECKINGI v ON loinc_code = l.lab_loinc
WHERE l.result_num < v.valid_low OR l.result_num > valid_high OR l.result_unit <> v.units;


/**Rules to assess relational integrity and attribute dependency**/   

/*Age and diagnosis*/  

---The whole number of patients

SELECT COUNT (DISTINCT d.PATID ) AS countp 
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS AS diagnosis 
ON d.PATID = diagnosis.PATID
LEFT JOIN ANALYTICSDB.QARULES.AGE_DX b 
ON (b.icd9code = diagnosis.dx OR b.Alternate_Code = diagnosis.dx  OR b.icd10code = diagnosis.dx)
WHERE dx_type IN ('09', '10') 
;

---Number of records with discrepancies

SELECT  DISTINCT d.PATID,
                 d.BIRTH_DATE,
                 DATEDIFF(YY, d.birth_date, diagnosis.dx_date) as pcor_age,
                 b.Valid_Beginning_Age,
                 b.Valid_End_Age, 
                 d.SEX, 
                 diagnosis.raw_diagnosis_name, diagnosis.dx_date,
                 diagnosis.ADMIT_DATE,
                 diagnosis.ENCOUNTERID, 
                 diagnosis.DX as dx, 
                 diagnosis.ADMIT_DATE,
                 b.icd9code,
                 b.icd10code,
                 b.Alternate_Code 
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS AS diagnosis ON d.PATID = diagnosis.PATID
LEFT JOIN ANALYTICSDB.QARULES.AGE_DX b ON (b.icd9code = diagnosis.dx OR b.Alternate_Code = diagnosis.dx  OR b.icd10code = diagnosis.dx)
WHERE dx_type IN ('09', '10') 
AND pcor_age< b.valid_beginning_age OR pcor_age>b.valid_end_age
;

---Count of patients with discrepancies

SELECT COUNT (DISTINCT patid ) AS coutpd 
FROM (SELECT  DATEDIFF(YY, d.birth_date, diagnosis.dx_date) AS pcor_age,
            d.patid
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS AS diagnosis ON d.PATID = diagnosis.PATID
LEFT JOIN ANALYTICSDB.QARULES.AGE_DX b ON (b.icd9code = diagnosis.dx OR b.Alternate_Code = diagnosis.dx  OR b.icd10code = diagnosis.dx)
WHERE dx_type IN ('09', '10') AND pcor_age< b.valid_beginning_age OR pcor_age>b.valid_end_age
);

/*Age and procedure*/  


---Whole number of patients

SELECT COUNT (DISTINCT  d.PATID)
FROM  PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES AS pr ON d.PATID = pr.PATID
LEFT JOIN  ANALYTICSDB.QARULES.AGE_PX b ON (b.cpt_code = pr.px )
WHERE px_type = 'CH' ;

---Number of records with discrepancies

SELECT  DISTINCT  d.PATID,
                  d.BIRTH_DATE,
                  DATEDIFF(YY, d.birth_date,pr.px_date ) AS pcor_age,
                  b.valid_begin_age,
                  valid_end_age, 
                  d.SEX, 
                  pr.ADMIT_DATE,
                  pr.ENCOUNTERID,
                  pr.raw_procedure_name,
                  pr.px_date, 
                  pr.px,b.cpt_code
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES AS pr ON d.PATID = pr.PATID
LEFT JOIN  ANALYTICSDB.QARULES.AGE_PX b ON (b.cpt_code = pr.px )
WHERE px_type = 'CH' and pcor_age < b.valid_begin_age OR  pcor_age > b.valid_end_age;

---Count of patients with discrepancies

SELECT COUNT (DISTINCT patid) AS the_sum
FROM(SELECT  datediff(YY, d.birth_date,pr.px_date ) as pcor_age, 
d.patid
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES AS pr ON d.PATID = pr.PATID
LEFT JOIN  ANALYTICSDB.QARULES.AGE_PX b ON (b.cpt_code = pr.px )
WHERE px_type = 'CH' and pcor_age < b.valid_begin_age OR  pcor_age > b.valid_end_age
);

/*Gender and diagnosis*/ 


---The number of whole cohort of patients admitted after Jan/01

SELECT COUNT (DISTINCT d.patid) AS patient_count 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS dx ON d.patid = dx.patid
LEFT JOIN ANALYTICSDB.QARULES.GENDER_DX b ON (b.icd9code = dx.dx OR b.icd10code = dx.dx)
WHERE dx.dx_type IN ('09','10') 
AND (dx.DX_DATE > '01-JAN-2015' OR dx.ADMIT_DATE > '01-JAN-2015')
;

---Number of records that have discrepancy

SELECT d.patid,
       d.birth_date,
       d.sex AS pecornet_gender,
       b.invalid_gender AS qa_gender,
       dx.encounterid,
       dx.dx_date,
       dx.admit_date,
       dx.raw_diagnosis_name, 
       dx.dx,
       b.icd9code,
       b.icd10code,
       b.concept_name
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS dx ON d.patid = dx.patid
LEFT JOIN ANALYTICSDB.QARULES.GENDER_DX b ON (b.icd9code = dx.dx OR b.icd10code = dx.dx)
WHERE dx.dx_type IN ('09','10') 
AND (dx.DX_DATE > '01-JAN-2015' OR dx.ADMIT_DATE > '01-JAN-2015')
AND d.sex = b.invalid_gender;

---Number of patients with discrepancies

SELECT COUNT (DISTINCT d.patid) AS patient_count 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS dx ON d.patid = dx.patid
LEFT JOIN ANALYTICSDB.QARULES.GENDER_DX b ON (b.icd9code = dx.dx OR b.icd10code = dx.dx)
WHERE dx.dx_type IN ('09','10') 
AND (dx.DX_DATE > '01-JAN-2015' OR dx.ADMIT_DATE > '01-JAN-2015')
AND d.sex = b.invalid_gender;

/*Gender and procedure*/  


---whole number of patients

SELECT  COUNT (DISTINCT d.patid) 
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES AS pr ON d.PATID = pr.PATID
LEFT JOIN ANALYTICSDB.QARULES.GENDER_PX b ON (b.cpt_code = pr.px )
WHERE px_type = 'CH' 
 ;

---Number of records with discrepancies

SELECT  DISTINCT d.patid,
                 d.sex ,
                 pr.px,
                 pr.raw_procedure_name,  
                 b.cpt_code, 
                 b.invalid_gender, 
                 b.description
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES AS pr ON d.PATID = pr.PATID
LEFT JOIN ANALYTICSDB.QARULES.GENDER_PX b ON (b.cpt_code = pr.px )
WHERE px_type = 'CH'
AND d.sex = b.invalid_gender
;

---Number of patients with discrepancies

SELECT  COUNT (DISTINCT  d.PATID)
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES AS pr ON d.PATID = pr.PATID
LEFT JOIN ANALYTICSDB.QARULES.GENDER_PX b ON (b.cpt_code = pr.px )
WHERE px_type = 'CH' 
AND d.sex = b.invalid_gender
;

/*Gender and clinical specialty*/  


---Number of whole patients

SELECT COUNT (DISTINCT patid) AS patient_number 
FROM (SELECT  DATEDIFF(YY, d.birth_date, GETDATE())   AS age  ,
   e.patid 
     FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e
     LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC d ON  d.patid= e.patid
     WHERE  age > 1 );

---Number of records with discrepancies

SELECT e.patid,
       d.sex,
       e.facility_type,
       e.facilityid,
       DATEDIFF(YY, d.birth_date, GETDATE()) AS age  
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC d ON  d.patid= e.patid
WHERE d.sex = 'M'  
AND age > 1 
AND e.facility_type IN ('HOSPITAL_OUTPATIENT_OBGYN_CLINIC','HOSPITAL_OUTPATIENT_GYNECOLOGY_CLINIC', 'HOSPITAL_OUTPATIENT_OBSTETRICAL_CLINIC');

---Number of patients with discrepancies

SELECT COUNT (DISTINCT patid) AS patient_number 
FROM (SELECT  DATEDIFF(YY, d.birth_date, GETDATE())    AS age,
     e.patid 
     FROM PCORNET_CDM.CDM_C010R022.PRIVATE_ENCOUNTER e
     LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC d ON  d.patid= e.patid
     WHERE d.sex = 'M'  
     AND age > 1 
     AND e.facility_type IN ('HOSPITAL_OUTPATIENT_OBGYN_CLINIC','HOSPITAL_OUTPATIENT_GYNECOLOGY_CLINIC', 'HOSPITAL_OUTPATIENT_OBSTETRICAL_CLINIC'));



/*Drug and diagnosis*/  


---Number of whole patients

SELECT COUNT (DISTINCT patid) AS countp
FROM (SELECT  DATEDIFF(YY, d.birth_date, diagnosis.dx_date) as pcor_age, 
            d.patid
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS AS diagnosis ON d.PATID = diagnosis.PATID
LEFT JOIN ANALYTICSDB.QARULES.AGE_DX b ON (b.icd9code = diagnosis.dx or b.Alternate_Code = diagnosis.dx  OR b.icd10code = diagnosis.dx)
WHERE dx_type IN ('09', '10')  
 );

---The number of records with discrepancies

SELECT  DISTINCT  d.PATID, 
                  d.BIRTH_DATE, 
                  dATEDIFF(YY, d.birth_date, diagnosis.dx_date) as pcor_age,
                  b.Valid_Beginning_Age,
                  b.Valid_End_Age, 
                  d.SEX, 
                  diagnosis.raw_diagnosis_name, diagnosis.dx_date,
                  diagnosis.ADMIT_DATE, 
                  diagnosis.ENCOUNTERID, 
                  diagnosis.DX as dx, 
                  diagnosis.ADMIT_DATE,
                  b.icd9code,
                  b.icd10code,
                  b.Alternate_Code 
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS AS diagnosis ON d.PATID = diagnosis.PATID
LEFT JOIN ANALYTICSDB.QARULES.AGE_DX b ON (b.icd9code = diagnosis.dx OR b.Alternate_Code = diagnosis.dx  OR b.icd10code = diagnosis.dx)
WHERE dx_type IN ('09', '10') 
AND pcor_age< b.valid_beginning_age OR pcor_age>b.valid_end_age
;

---Number of patients with discrepancies

SELECT COUNT (DISTINCT patid ) AS coutpd 
FROM (SELECT  DATEDIFF(YY, d.birth_date, diagnosis.dx_date) as pcor_age, 
            d.patid
FROM PCORNET_CDM.CDM_C010R021.DEMOGRAPHIC AS d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS AS diagnosis ON d.PATID = diagnosis.PATID
LEFT JOIN ANALYTICSDB.QARULES.AGE_DX b ON (b.icd9code = diagnosis.dx OR b.Alternate_Code = diagnosis.dx  OR b.icd10code = diagnosis.dx)
WHERE dx_type IN ('09', '10') AND pcor_age< b.valid_beginning_age OR pcor_age>b.valid_end_age
);

/*Inpatient only procedure*/


---Number of whole patients

SELECT COUNT (DISTINCT p.patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p
LEFT JOIN ANALYTICSDB.QARULES.IPO ad ON ad.ipo_cpt_code = p.px
WHERE   p.enc_type NOT IN ('IP','EI')  ;

---Number of records with discrepancies

SELECT DISTINCT p.patid,
                p.enc_type, 
                p.raw_procedure_name  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p
LEFT JOIN ANALYTICSDB.QARULES.IPO ad ON ad.ipo_cpt_code = p.px
WHERE p.px = ad.ipo_cpt_code AND p.enc_type NOT IN ('IP','EI')  ;


---Number of patients with discrepancies

SELECT COUNT (DISTINCT p.patid)
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p
LEFT JOIN ANALYTICSDB.QARULES.IPO ad ON ad.ipo_cpt_code = p.px
WHERE p.px = ad.ipo_cpt_code AND p.enc_type NOT IN ('IP','EI')  ;

/*Diagnosis and lab*/  


---Number of whole patients

SELECT COUNT  (DISTINCT d.patid) AS total 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS d ON d.patid = l.patid
LEFT JOIN ANALYTICSDB.QARULES.DX_LABII xl 
WHERE d.dx = xl.icd AND l.lab_loinc IN ('4548-4','41653-7','2339-0','2345-7','32016-8') ;


---Number of records with dicrepancies

SELECT COUNT (DISTINCT d.patid) AS total 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS d ON d.patid = l.patid
LEFT JOIN ANALYTICSDB.QARULES.DX_LABII xl 
WHERE d.dx = xl.icd AND  l.patid NOT IN 
(SELECT l.patid 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l WHERE l.lab_loinc IN ('4548-4','41653-7','2339-0','2345-7','32016-8')) ;

---Number of patients with dicrepancies

SELECT COUNT (DISTINCT d.patid) AS total 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_DIAGNOSIS d ON d.patid = l.patid
LEFT JOIN ANALYTICSDB.QARULES.DX_LABII xl 
WHERE d.dx = xl.icd AND  l.patid NOT IN 
(SELECT l.patid 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l WHERE l.lab_loinc IN ('4548-4','41653-7','2339-0','2345-7','32016-8')

/*Drug and lab*/  


---Number of whole patients

SELECT COUNT (DISTINCT pp.patid)   
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING pp
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.patid = pp.patid
WHERE RAW_RXNORM_CUI IN ('37801','6851','8640') 
AND l.patid  IN (SELECT l.patid 
                 FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l 
                 WHERE l.lab_loinc IN ('1743-4','1920-8','1752-5','2160-0','1743-4','1920-8','2324-2','1547-9','17856-6'));

---Number of records with dicrepancies

SELECT DISTINCT pp.patid,  
                pp.encounterid,
                pp.rxnorm_cui, 
                pp.raw_rx_med_name,
                pp.RAW_RXNORM_CUI 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING pp
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.patid = pp.patid
WHERE RAW_RXNORM_CUI IN ('37801','6851','8640') 
AND l.patid NOT IN (SELECT l.patid 
                    FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l 
                    WHERE l.lab_loinc IN ('1743-4','1920-8','1752-5','2160-0','1743-4','1920-8','2324-2','1547-9','17856-6'));

---Number of patients with dicrepancies

SELECT  COUNT (DISTINCT pp.patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING pp
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.patid = pp.patid
WHERE RAW_RXNORM_CUI IN ('37801','6851','8640') 
AND l.patid NOT IN (SELECT l.patid 
                    FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l 
                     WHERE l.lab_loinc IN ('1743-4','1920-8','1752-5','2160-0','1743-4','1920-8','2324-2','1547-9','17856-6'));

/*Drug and continuous procedure*/ 

---Number of whole cohort

SELECT COUNT (DISTINCT p.patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p ON p.patid = d.patid
WHERE d.raw_rxnorm_cui IN ('202462','5521') AND p.patid IN (SELECT p.patid 
    FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('92002' , 
'92004', '92012', '92014', '92015', '99172', '99173','92018','92019','92225','92226','92230','92240','92250','92284','92003'
,'99201','99202','99203','99204','99205','99211','99212','99213','99214','992015') ) 
 AND  DATEDIFF(MONTH,d.rx_start_date,p.px_date  )>=0 AND  DATEDIFF(MONTH,d.rx_start_date,p.px_date  )<=24;

---Number of records with discrepancies

SELECT *
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p ON p.patid = d.patid
WHERE d.raw_rxnorm_cui IN ('202462','5521') AND p.patid NOT IN (SELECT p.patid 
        FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p 
        WHERE p.px IN ('92002' , 
'92004', '92012', '92014', '92015', '99172', '99173','92018','92019','92225','92226','92230','92240','92250','92284','92003'
,'99201','99202','99203','99204','99205','99211','99212','99213','99214','992015') ) 
AND  DATEDIFF(MONTH,d.rx_start_date,p.px_date  )>=0 AND  DATEDIFF(MONTH,d.rx_start_date,p.px_date  )<=24;

---Number of patients with discrepancies

SELECT COUNT (DISTINCT p.patid) 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING d
LEFT JOIN PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p ON p.patid = d.patid
WHERE d.raw_rxnorm_cui IN ('202462','5521') AND p.patid NOT IN (SELECT p.patid 
        FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p 
        WHERE p.px IN ('92002' , 
'92004', '92012', '92014', '92015', '99172', '99173','92018','92019','92225','92226','92230','92240','92250','92284','92003'
,'99201','99202','99203','99204','99205','99211','99212','99213','99214','992015') ) 
AND DATEDIFF(MONTH,d.rx_start_date,p.px_date  )>=0 
AND DATEDIFF(MONTH,d.rx_start_date,p.px_date  )<=24;


/*Drug Monitring*/ 
 

---Number of whole of patients

SELECT COUNT(DISTINCT pp.patid)
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING pp
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.patid = pp.patid
LEFT JOIN ANALYTICSDB.QARULES.DRUG_MONITORING dm ON dm.drug_name =  pp.raw_rx_med_name
WHERE pp.raw_rxnorm_cui = dm.rx_code   ;

---Number of records with disrepanies

SELECT DISTINCT pp.encounterid, 
                pp.encounterid,
                pp.rxnorm_cui,
                pp.raw_rx_med_name,
                pp.raw_rxnorm_cui,
                dm.rx_code,
                l.lab_loinc,
                dm.loinc_code,
                l.raw_lab_name
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING pp
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.encounterid = pp.encounterid
LEFT JOIN ANALYTICSDB.QARULES.DRUG_MONITORING dm ON dm.drug_name =  pp.raw_rx_med_name
WHERE pp.raw_rxnorm_cui = dm.rx_code  
AND l.patid NOT IN (SELECT l.patid 
                 FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
                WHERE l.lab_loinc IN ('10535-3','14334-7','25168-6','3968-5','1811288','29247-4','11253-2','20578-1','4092-3','3948-7','4086-5','3432-2','1558044','3663-2','3665-7','4057-6','4059-2','4058-4','35669-1',
                '4049-3','3422-3','23905-3','14836-1'));

---Nunber of patients with discrepancies

SELECT COUNT(DISTINCT pp.patid)----32,465

FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING pp
LEFT JOIN  PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l ON l.encounterid = pp.encounterid
LEFT JOIN ANALYTICSDB.QARULES.DRUG_MONITORING dm ON dm.drug_name =  pp.raw_rx_med_name
WHERE pp.raw_rxnorm_cui = dm.rx_code  
AND l.patid NOT IN (SELECT l.patid 
                    FROM PCORNET_CDM.CDM_C010R022.PRIVATE_LAB_RESULT_CM l
                    WHERE l.lab_loinc IN ('10535-3','14334-7','25168-6','3968-5','1811288','29247-4','11253-2','20578-1','4092-3','3948-7','4086-5','3432-2','1558044','3663-2','3665-7','4057-6','4059-2','4058-4','35669-1',
                    '4049-3','3422-3','23905-3','14836-1'));

/*Drug Interaction*/
 

---The number of whole cohort

select count (distinct Patid) from PCORNET_CDM.CDM_C010R022.PRIVATE_PRESCRIBING;

---The number of records with discrepancies

SELECT  DISTINCT a.patid ,
                 a.rx_order_date,
                 a.encounterid,
                 a.raw_rxnorm_cui,
                 a.raw_rx_med_name,
                 a.drug_name_1,
                 a.rxnormm_1,
                 b.raw_rxnorm_cui,
                 b.raw_rx_med_name,
                 b.drug_name_2,
                 b.rxnorm_2
FROM interaction_a AS a,interaction_b AS b  
WHERE b.encounterid = a.encounterid AND b.patid = a.patid
AND a.rx_order_date = b.rx_order_date AND ((a.raw_rxnorm_cui='74169' AND b.raw_rxnorm_cui='34482' )
OR (a.raw_rxnorm_cui='4493' AND b.raw_rxnorm_cui='8123' )
OR (a.raw_rxnorm_cui='3407' AND b.raw_rxnorm_cui='9068' )
OR (a.raw_rxnorm_cui='136411' AND b.raw_rxnorm_cui='28004' )
OR (a.raw_rxnorm_cui='8591' AND b.raw_rxnorm_cui='9997' )
OR (a.raw_rxnorm_cui='2599' AND b.raw_rxnorm_cui='8787' )
OR (a.raw_rxnorm_cui='11289' AND b.raw_rxnorm_cui='3393' )
OR (a.raw_rxnorm_cui='10438' AND b.raw_rxnorm_cui='2551' )
OR (a.raw_rxnorm_cui='8331' AND b.raw_rxnorm_cui='6135' )
OR (a.raw_rxnorm_cui='6851' AND b.raw_rxnorm_cui='8698' )
OR (a.raw_rxnorm_cui='1760' AND b.raw_rxnorm_cui='8896' )
OR (LOWER(a.raw_rx_med_name)='piperacillin_taz' AND LOWER(b.raw_rx_med_name)='imipenem-cilastatin' )
OR (LOWER(a.raw_rx_med_name)='fluoxetine' AND LOWER(b.raw_rx_med_name)='phenelize' )
OR (LOWER(a.raw_rx_med_name)='digoxin' AND LOWER(b.raw_rx_med_name)='quinidine' )
OR (LOWER(a.raw_rx_med_name)='sildenafil' AND LOWER(b.raw_rx_med_name)='isosorbide_mononitrate' )
OR (LOWER(a.raw_rx_med_name)='potassium Chloride' AND LOWER(b.raw_rx_med_name)='spironolactone' )
OR (LOWER(a.raw_rx_med_name)='clonidine' AND LOWER(b.raw_rx_med_name)='propranolol' )
OR (LOWER(a.raw_rx_med_name)='warfarin' AND LOWER(b.raw_rx_med_name)='diflunisal' )
OR (LOWER(a.raw_rx_med_name)='theophylline' AND LOWER(b.raw_rx_med_name)='ciprofloxacin' )
OR (LOWER(a.raw_rx_med_name)='pimozide' AND LOWER(b.raw_rx_med_name)='ketoconazole' )
OR (LOWER(a.raw_rx_med_name)='methotrexate' AND LOWER(b.raw_rx_med_name)='probenecid' )
OR (LOWER(a.raw_rx_med_name)='bromocriptine ' AND LOWER(b.raw_rx_med_name)='pseudoephedrine' ))
ORDER BY patid,encounterid,rx_order_date;

---Number of patients with discrepancies

SELECT   COUNT(DISTINCT a.patid)
FROM interaction_a AS a,interaction_b AS b  
WHERE b.encounterid = a.encounterid AND b.patid = a.patid
AND a.rx_order_date = b.rx_order_date AND ((a.raw_rxnorm_cui='74169' AND b.raw_rxnorm_cui='34482' )
OR (a.raw_rxnorm_cui='4493' AND b.raw_rxnorm_cui='8123' )
OR (a.raw_rxnorm_cui='3407' AND b.raw_rxnorm_cui='9068' )
OR (a.raw_rxnorm_cui='136411' AND b.raw_rxnorm_cui='28004' )
OR (a.raw_rxnorm_cui='8591' AND b.raw_rxnorm_cui='9997' )
OR (a.raw_rxnorm_cui='2599' AND b.raw_rxnorm_cui='8787' )
OR (a.raw_rxnorm_cui='11289' AND b.raw_rxnorm_cui='3393' )
OR (a.raw_rxnorm_cui='10438' AND b.raw_rxnorm_cui='2551' )
OR (a.raw_rxnorm_cui='8331' AND b.raw_rxnorm_cui='6135' )
OR (a.raw_rxnorm_cui='6851' AND b.raw_rxnorm_cui='8698' )
OR (a.raw_rxnorm_cui='1760' AND b.raw_rxnorm_cui='8896' )
OR (LOWER(a.raw_rx_med_name)='piperacillin_taz' AND LOWER(b.raw_rx_med_name)='imipenem-cilastatin' )
OR (LOWER(a.raw_rx_med_name)='fluoxetine' AND LOWER(b.raw_rx_med_name)='phenelize' )
OR (LOWER(a.raw_rx_med_name)='digoxin' AND LOWER(b.raw_rx_med_name)='quinidine' )
OR (LOWER(a.raw_rx_med_name)='sildenafil' AND LOWER(b.raw_rx_med_name)='isosorbide_mononitrate' )
OR (LOWER(a.raw_rx_med_name)='potassium Chloride' AND LOWER(b.raw_rx_med_name)='spironolactone' )
OR (LOWER(a.raw_rx_med_name)='clonidine' AND LOWER(b.raw_rx_med_name)='propranolol' )
OR (LOWER(a.raw_rx_med_name)='warfarin' AND LOWER(b.raw_rx_med_name)='diflunisal' )
OR (LOWER(a.raw_rx_med_name)='theophylline' AND LOWER(b.raw_rx_med_name)='ciprofloxacin' )
OR (LOWER(a.raw_rx_med_name)='pimozide' AND LOWER(b.raw_rx_med_name)='ketoconazole' )
OR (LOWER(a.raw_rx_med_name)='methotrexate' AND LOWER(b.raw_rx_med_name)='probenecid' )
OR (LOWER(a.raw_rx_med_name)='bromocriptine ' AND LOWER(b.raw_rx_med_name)='pseudoephedrine' ))
;


/**Rules to assess historical data and state-dependent objects**/   


/*Lab time*/  


---The number of whole cohort

SELECT COUNT (DISTINCT l.patid) 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
WHERE (l.lab_loinc = '2990-0' OR l.lab_loinc = '2991-8' OR l.lab_loinc = '2986-8');

---The number of records with discrepancies

SELECT DISTINCT l.patid,
                l.lab_loinc,
                l.result_num, 
                l.result_unit,
                raw_lab_name, 
                l.specimen_time, 
                l.specimen_date , 
                l.lab_order_date 
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
WHERE (l.lab_loinc = '2990-0' OR l.lab_loinc = '2991-8' OR l.lab_loinc = '2986-8')
AND HOUR( l.specimen_time) >= 10;

---The number of patients with discrepancies

SELECT COUNT(DISTINCT l.patid)  
FROM PCORNET_CDM.CDM_C010R022.LAB_RESULT_CM l
WHERE (l.lab_loinc = '2990-0' OR l.lab_loinc = '2991-8' OR l.lab_loinc = '2986-8')
AND HOUR( l.specimen_time) >= 10;

/*Date in future*/  


---Death_date

SELECT DISTINCT patid
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_DEATH;
SELECT * 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_DEATH
WHERE DECEASED_DT_TM >=GETDATE();

---Birth_date

SELECT * 
FROM  PCORNET_CDM.CDM_C010R022.PRIVATE_DEMOGRAPHIC
WHERE BIRTH_DATE>=GETDATE();

---Medadmin_start

SELECT * 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_MED_ADMIN;
SELECT * 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_MED_ADMIN
WHERE medadmin_start_date >=GETDATE() OR medadmin_stop_date   >=GETDATE();

---Proc_start

SELECT * 
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES
WHERE px_date >=GETDATE();


/*Procedure duplication*/  


---Hysterectomy

SELECT COUNT  (DISTINCT p.patid) AS count  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('58570','58571','58572','58573','55866');

SELECT  COUNT  (DISTINCT p.patid) AS count  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('58570','58571','58572','58573','55866')
GROUP BY p.patid HAVING COUNT >1;

---Leg amputation

SELECT  COUNT  (DISTINCT p.patid) AS count  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('27889')
   ;
SELECT  count  (DISTINCT p.patid) AS count  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('27889')
GROUP BY p.patid HAVING COUNT >1 ; 

---Prostate removal

SELECT  COUNT  (DISTINCT p.patid) AS count  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('55866')
   ;
SELECT COUNT  (DISTINCT p.patid) AS count  
FROM PCORNET_CDM.CDM_C010R022.PRIVATE_PROCEDURES p WHERE p.px IN ('55866')
GROUP BY p.patid HAVING  COUNT >1 ; 






