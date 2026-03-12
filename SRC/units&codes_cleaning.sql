

## ---Cleaning of transformed obscene table to make all values, units, LOINC codes, and names of vital (WT, HT, BP,BMI) are consistent. 



/////////////////////////////////////////////////////////////////////MU///////////////////////////////
   
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.Mu_linked_vital_obsclin_table
SET obsclin_result_num = CASE
                  WHEN  (raw_obsclin_name) = 'Body weight' THEN Round (obsclin_result_num*0.453592,1)
                 WHEN  (raw_obsclin_name) = 'Weight (Lbs Calc)' THEN Round (obsclin_result_num*0.453592,1)
                  WHEN  (raw_obsclin_name) = 'Weight (lbs)' THEN Round (obsclin_result_num*0.453592,1)
                  WHEN  (raw_obsclin_name) = 'Home Weight-Patient Reported (lbs)' THEN Round (obsclin_result_num*0.453592,1)
                 WHEN  (raw_obsclin_name) = 'Pre Pregnancy Weight' THEN Round (obsclin_result_num*0.453592,1)
                 WHEN  (raw_obsclin_name) = 'Patient Weight' THEN Round (obsclin_result_num*0.453592,1)
                 WHEN  (raw_obsclin_name) = 'My Weight' THEN Round (obsclin_result_num*0.453592,1)
                 WHEN (raw_obsclin_name) = 'Creat Patient Weight' THEN Round (obsclin_result_num*0.453592,1)
                  WHEN  (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54,1)
                 WHEN  (raw_obsclin_name) = 'Height (Inches Calc)' THEN Round (obsclin_result_num*2.54,1)
                  WHEN  (raw_obsclin_name) = 'Height (inches)' THEN Round  (obsclin_result_num*2.54,1)
                  WHEN lower (raw_obsclin_name) like '%creat patient height' THEN Round (obsclin_result_num*2.54,1)
                WHEN lower (raw_obsclin_name) like '%pre-amputation height (inches)' THEN Round  (obsclin_result_num*2.54,1)
                 WHEN lower (raw_obsclin_name) like '%height (feet)' THEN Round (obsclin_result_num*30.48,1)
                 ELSE obsclin_result_num
             END,
   
 obsclin_result_unit  = CASE
                WHEN lower (raw_obsclin_name) like '%lbs%' THEN 'Kg'
                WHEN  (raw_obsclin_name) = 'Pre Pregnancy Weight' THEN 'Kg'
                WHEN  (raw_obsclin_name) = 'My Weight' THEN 'kg'
                WHEN (raw_obsclin_name) = 'Weight Estimated' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Dosing weight (vancomycin)' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Dosing Weight (kg)' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Ideal Body Weight Calculated' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Weight for Height/Length Percentile' THEN '%'
                WHEN  (raw_obsclin_name) = 'Body weight' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Weight (kg)' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Dosing Weight (kg)' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Pre Pregnancy Weight' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Weight Measured' THEN 'kg'
                WHEN  (raw_obsclin_name) = 'Weight-Dialysis' THEN 'kg'
                 WHEN  (raw_obsclin_name) = 'Patient Weight' THEN 'kg'
                 WHEN  (raw_obsclin_name) = 'Ideal Body Weight' THEN 'kg'
                  WHEN  (raw_obsclin_name) = 'Creat Patient Weight' THEN 'kg'
                
                
                WHEN  (raw_obsclin_name) = 'Height (cm)' THEN 'cm'
                WHEN  (raw_obsclin_name) = 'Height (Inches Calc)' THEN 'cm'
                WHEN  (raw_obsclin_name) = 'Height (inches)' THEN 'cm'
                WHEN lower (raw_obsclin_name) like '%creat patient height' THEN 'cm'
                WHEN lower (raw_obsclin_name) like '%height (feet)%' THEN 'cm'
                WHEN lower (raw_obsclin_name) like '%pre-amputation height (inches))' THEN 'cm'
                WHEN lower (raw_obsclin_name) like '%Height Percent' THEN '%'
                 WHEN  (raw_obsclin_name) = 'Body height' THEN 'cm'
                WHEN (raw_obsclin_name) = 'BMI'  THEN 'kg/m2'
                WHEN (raw_obsclin_name) = 'Initial BMI'  THEN 'kg/m2'
                WHEN (raw_obsclin_name) = 'UBW BMI'  THEN 'kg/m2'
                WHEN (raw_obsclin_name) = 'Pre Pregnancy BMI'  THEN 'kg/m2'
                WHEN (raw_obsclin_name) = 'Most Recent BMI'  THEN 'kg/m2'
                WHEN (raw_obsclin_name) = 'BMI Percentile' THEN '%'
                
                WHEN (raw_obsclin_name) = 'Systolic blood pressure' THEN 'mm[Hg]'
                 WHEN (raw_obsclin_name) = 'Diastolic blood pressure' THEN 'mm[Hg]'
                
                ELSE obsclin_result_unit
            END,
obsclin_code = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Weight (kg)' THEN '29463-7'
                 WHEN  (raw_obsclin_name) = 'Height (cm)' THEN '8302-2'
                 WHEN  raw_obsclin_code = '60621009' THEN '39156-5'
                 WHEN  raw_obsclin_code = '3141-9' THEN '29463-7'
                 WHEN (raw_obsclin_name) = 'Most Recent BMI'  THEN '39156-5'
                 ELSE obsclin_code
             END,
obsclin_type = CASE
                  WHEN  raw_obsclin_code = '27113001' THEN 'LC'
                 WHEN  raw_obsclin_code = '60621009' THEN 'LC'
                 WHEN (raw_obsclin_name) = 'Most Recent BMI'  THEN 'LC'
                 WHEN  raw_obsclin_code = '3141-9' THEN 'LC'
                 WHEN  raw_obsclin_code = '50373000' THEN 'LC'
                 ELSE obsclin_type
             END,
raw_obsclin_code = CASE
                 WHEN  raw_obsclin_code = '27113001' THEN '29463-7'
                 WHEN  raw_obsclin_code = '60621009' THEN '39156-5'
                 WHEN  raw_obsclin_code = '3141-9' THEN '29463-7'
                 WHEN (raw_obsclin_name) = 'Most Recent BMI'  THEN '39156-5'
                 WHEN  raw_obsclin_code = '50373000' THEN '8302-2'
                 
                 ELSE raw_obsclin_code
             END,
 raw_obsclin_type = CASE

                WHEN  raw_obsclin_code = '27113001' THEN 'LC'
                 WHEN  raw_obsclin_code = '60621009' THEN 'LC'
                 WHEN  raw_obsclin_code = '3141-9' THEN 'LC'
                 WHEN (raw_obsclin_name) = 'Most Recent BMI'  THEN 'LC'
                 WHEN  raw_obsclin_code = '50373000' THEN 'LC'
                 
                 ELSE raw_obsclin_type
                 END,
 RAW_OBSCLIN_NAME  = CASE
                WHEN  (raw_obsclin_name) = 'Home Weight-Patient Reported (lbs)' 
                THEN 'Home Weight-Patient Reported (kg)'
                WHEN  (raw_obsclin_name) = 'Weight (Lbs Calc)' THEN 'Body weight'
                WHEN  (raw_obsclin_name) = 'Weight (lbs)' THEN 'Body weight'
                WHEN lower (raw_obsclin_name) like '%source of weight' THEN 'Weight Source'
                WHEN lower (raw_obsclin_name) like '%birth weight:' THEN 'Birth Weight'
                WHEN  (raw_obsclin_name) = 'Patient Weight' THEN 'Body weight'
                WHEN  (raw_obsclin_name) = 'Weight Measured' THEN 'Body weight'
                WHEN  (raw_obsclin_name) = 'Weight (kg)' THEN 'Body weight'
                WHEN  (raw_obsclin_name) = 'Adult Oncology Baseline Weight (kg)' THEN 'Adult Oncology Weight (kg)'
                WHEN lower (raw_obsclin_name) like '%my weight' THEN 'Body weight stated'
                WHEN lower (raw_obsclin_name) like '%usual body weight' THEN 'Body weight reported_usual'
                 WHEN (raw_obsclin_name) = 'Creat Patient Weight' THEN 'Body weight'
                 WHEN  (raw_obsclin_name) = 'Dosing weight (vancomycin)' THEN 'Dosing Weight (kg)'
                 WHEN  (raw_obsclin_name) = 'Ideal Body Weight Calculated' THEN 'Ideal Body Weight'
                WHEN (raw_obsclin_name) = 'Body Weight' THEN 'Body weight'
                WHEN (raw_obsclin_name) = 'Body weight' THEN 'Body weight'
                WHEN  (raw_obsclin_name) = 'Pre Pregnancy Weight' THEN 'Pre Pregnancy Weight (kg)'
                
                WHEN (raw_obsclin_name) = 'Height (Inches Calc)' THEN 'Body height'
                WHEN  (raw_obsclin_name) = 'Height (inches)' THEN 'Body height'
                WHEN lower (raw_obsclin_name) like '%height (feet)' THEN 'Body height'
                WHEN lower (raw_obsclin_name) like '%height (inches)' THEN 'Body height'
                WHEN lower (raw_obsclin_name) like '%height (cm)' THEN 'Body height'
                WHEN lower (raw_obsclin_name) like '%creat patient height' THEN 'Body height'
                WHEN (raw_obsclin_name) = 'BMI' THEN 'Body mass index (BMI) [Ratio]'
                WHEN (raw_obsclin_name) = 'BMI Percentile' THEN 'Body mass index (BMI) [Percentile]'
                WHEN (raw_obsclin_name) = 'Systolic Blood Pressure' THEN 'Systolic blood pressure'
                WHEN (raw_obsclin_name) = 'Blood Pressure Systolic' THEN 'Systolic blood pressure'
                WHEN (raw_obsclin_name) = 'Systolic BP with Activity' THEN 'Systolic Blood Pressure with Activity'
                WHEN (raw_obsclin_name) = 'Diastolic Blood Pressure' THEN 'Diastolic blood pressure'
                WHEN (raw_obsclin_name) = 'Blood Pressure Diastolic' THEN 'Diastolic blood pressure'
                 WHEN (raw_obsclin_name) = 'Diastolic BP with Activity' THEN 'Diastolic Blood Pressure with Activity'
                ELSE RAW_OBSCLIN_NAME
                END,
raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN NULL
                WHEN  (raw_obsclin_name) = 'Home Weight-Patient Reported (lbs)' 
                THEN NULL 
                WHEN  (raw_obsclin_name) = 'Weight (Lbs Calc)' THEN NULL
                WHEN  (raw_obsclin_name) = 'Weight (lbs)' THEN NULL
                WHEN lower (raw_obsclin_name) like '%birth weight:' THEN NULL
                WHEN  (raw_obsclin_name) = 'Patient Weight' THEN NULL
                WHEN  (raw_obsclin_name) = 'Weight Measured' THEN NULL
                WHEN  (raw_obsclin_name) = 'Weight (kg)' THEN NULL
                WHEN  (raw_obsclin_name) = 'Adult Oncology Baseline Weight (kg)' THEN NULL
                WHEN lower (raw_obsclin_name) like '%my weight' THEN NULL
                WHEN lower (raw_obsclin_name) like '%usual body weight' THEN NULL
                 WHEN (raw_obsclin_name) = 'Creat Patient Weight' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Dosing weight (vancomycin)' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Ideal Body Weight Calculated' THEN NULL
                WHEN (raw_obsclin_name) = 'Body Weight' THEN NULL
                WHEN (raw_obsclin_name) = 'Body weight' THEN NULL
                WHEN  (raw_obsclin_name) = 'Pre Pregnancy Weight' THEN NULL

                WHEN (raw_obsclin_name) = 'Height (Inches Calc)' THEN NULL
                WHEN  (raw_obsclin_name) = 'Height (inches)' THEN NULL
                WHEN lower (raw_obsclin_name) like '%height (feet)' THEN NULL
                WHEN lower (raw_obsclin_name) like '%height (inches)' THEN NULL
                WHEN lower (raw_obsclin_name) like '%height (cm)' THEN NULL
                WHEN lower (raw_obsclin_name) like '%creat patient height' THEN NULL
                 ELSE raw_obsclin_result
                 END;

-----
///////////////////////////////////////////////allina///////////////////////////////////////////////           




Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_ALLINA.DEID_OBS_CLIN
CLONE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.Allina_linked_vital_obsclin ;



UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.Allina_linked_vital_obsclin
SET obsclin_result_num = CASE
                  
                 WHEN lower (obsclin_result_num) = 'ni' THEN NULL
                 ELSE obsclin_result_num
                 END,
raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN NULL
                 ELSE raw_obsclin_result
                 END;
                 
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.Allina_linked_vital_obsclin            
SET  obsclin_result_num = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54,1)
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
                 END;



///////////////////////////////////////////IHC/////////////////////////////////////////////////




Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_IHC.DEID_OBS_CLIN
CLONE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_ihc_vital_obsclin_table ;



UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_ihc_vital_obsclin_table
SET raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN NULL
                 ELSE raw_obsclin_result
                 END,
 obsclin_result_num = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54,1)
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
                 END;


    
//////////////////////////////////////////kumc////////////////////////////////////////////////////////////////




Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_KUMC.DEID_OBS_CLIN
CLONE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_kumc_obsclin ;


-----
create or replace table kumc_linked_vital_obsclin as
 select * from GROUSE_DB.PCORNET_CDM_KUMC.V_DEID_OBS_CLIN;


UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_kumc_obsclin
SET obsclin_result_num = CASE
                  
                 WHEN   (raw_obsclin_name) = 'TOBACCO' THEN NULL
                 WHEN   (raw_obsclin_name) = 'TOBACCO_TYPE' THEN NULL
                 WHEN   (raw_obsclin_name) = 'SMOKING' THEN NULL
                 WHEN   ( obsclin_result_num) IN ('','NI', 'UN') THEN NULL
                 ELSE obsclin_result_num
                 END,
raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'HT' THEN NULL
                 WHEN  (raw_obsclin_name) = 'WT' THEN NULL
                 ELSE raw_obsclin_result
                 END;

/*Update unit and results field*/
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_kumc_obsclin
SET  obsclin_result_num = CASE
                  
                 WHEN (raw_obsclin_name) = 'HT' THEN Round  (obsclin_result_num*2.54,1)
                 WHEN (raw_obsclin_name) = 'WT' THEN Round  (obsclin_result_num*0.453592,1)
                 
                 ELSE  obsclin_result_num
             END,
             
 obsclin_result_unit  = CASE
            
                WHEN lower (raw_obsclin_name) like '%ht%' THEN 'cm'
               WHEN lower (raw_obsclin_name) like '%wt%' THEN 'Kg'
                WHEN lower (raw_obsclin_name) like '%diastolic%' THEN 'mmHg'
               WHEN lower (raw_obsclin_name) like '%systolic%' THEN 'mmHg'
               WHEN lower (raw_obsclin_name) like '%bmi' THEN 'kg/m2'
               ELSE obsclin_result_unit
            END,
raw_obsclin_name  = CASE
            
                WHEN  (raw_obsclin_name) = 'WT' THEN 'Body weight'
                WHEN  (raw_obsclin_name) = 'HT' THEN 'Body height'
                WHEN  (raw_obsclin_name) = 'ORIGINAL_BMI' THEN 'Body mass idnex (BMI)[Ratio]'
                WHEN  (raw_obsclin_name) = 'SYSTOLIC' THEN 'Systolic blood pressure'
                WHEN  (raw_obsclin_name) = 'DIASTOLIC' THEN 'Diastolic blood pressure'
               ELSE raw_obsclin_name
            END,
obsclin_code   = CASE
            
                WHEN  (raw_obsclin_name) = 'WT' THEN '29463-7'
                WHEN  (raw_obsclin_name) = 'HT' THEN '8302-2'
                WHEN  (raw_obsclin_name) = 'ORIGINAL_BMI' THEN '39156-5'
                WHEN  (raw_obsclin_name) = 'SYSTOLIC' THEN '8480-6'
                WHEN  (raw_obsclin_name) = 'DIASTOLIC' THEN '8480-6'
               ELSE obsclin_code
            END,
raw_obsclin_code   = CASE
            
                WHEN  (raw_obsclin_name) = 'WT' THEN '29463-7'
                WHEN  (raw_obsclin_name) = 'HT' THEN '8302-2'
                WHEN  (raw_obsclin_name) = 'ORIGINAL_BMI' THEN '39156-5'
                WHEN  (raw_obsclin_name) = 'SYSTOLIC' THEN '8480-6'
                WHEN  (raw_obsclin_name) = 'DIASTOLIC' THEN '8480-6'
               ELSE raw_obsclin_code 
            END,
obsclin_type   = CASE
            
                WHEN  (raw_obsclin_name) = 'WT' THEN 'LC'
                WHEN  (raw_obsclin_name) = 'HT' THEN 'LC'
                WHEN  (raw_obsclin_name) = 'ORIGINAL_BMI' THEN 'LC'
                WHEN  (raw_obsclin_name) = 'SYSTOLIC' THEN 'LC'
                WHEN  (raw_obsclin_name) = 'DIASTOLIC' THEN 'LC'
               ELSE obsclin_type
            END;
 
 
///////////////////////////////////////MCRI//////////////////////////////////////////////////////////////





Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_MCRI.DEID_OBS_CLIN
CLONE  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.mcri_linked_vital_obsclin;

UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.mcri_linked_vital_obsclin
SET obsclin_result_num = CASE
                  
                 WHEN lower (raw_obsclin_name) like '%body height%' THEN Round (obsclin_result_num*2.54,1)
                 WHEN lower (raw_obsclin_name) like '%body weight%' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
    raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN NULL
                 ELSE raw_obsclin_result
                 END;

////////////////////////////////////////////////MCW///////////////////////////////////////////////////////////////



Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_MCW.DEID_OBS_CLIN
CLONE  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.MCW_linked_vital_obsclin;


-------------

    
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.MCW_linked_vital_obsclin
SET obsclin_result_num = CASE
                  
                 WHEN lower (raw_obsclin_name) like '%body height%' THEN Round (obsclin_result_num*2.54,1)
                 WHEN lower (raw_obsclin_name) like '%body weight%' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
    raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN NULL
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN NULL
                 ELSE raw_obsclin_result
                 END;
 

///////////////////////////////////////////////UIOWA/////////////////////////////////////////////////////////////////



Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_UIOWA.DEID_OBS_CLIN
CLONE  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_uiowa_obsclin;

------------
create or replace table linked_uiowa_obsclin as 
 select * from GROUSE_DB.PCORNET_CDM_UIOWA.V_DEID_OBS_CLIN;

UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.linked_uiowa_obsclin
SET obsclin_result_num = CASE
                  
                 WHEN (raw_obsclin_name) = 'HEIGHT' THEN Round (obsclin_result_num*2.54,1)
                 WHEN (raw_obsclin_name) = 'WEIGHT' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
    raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) = 'HEIGHT' THEN NULL
                 WHEN  (raw_obsclin_name) = 'WEIGHT' THEN NULL
                 ELSE raw_obsclin_result
                 END,
  raw_obsclin_unit = CASE
                  
                 WHEN  (raw_obsclin_name) = 'HEIGHT' THEN NULL
                 WHEN  (raw_obsclin_name) = 'WEIGHT' THEN NULL
                 ELSE raw_obsclin_unit
                 END,
    raw_obsclin_name = CASE 
                  WHEN  (raw_obsclin_name) = 'WEIGHT' THEN 'Body weight'
                  WHEN  (raw_obsclin_name) = 'HEIGHT' THEN 'Body height'
                  WHEN  (raw_obsclin_name) = 'R SHRD BMI' THEN 'Body mass index (BMI)[Ratio]'
                  WHEN  (raw_obsclin_name) = 'BLOOD PRESSURE - SYSTOLIC' THEN 'Systolic blood pressure'
                  WHEN  (raw_obsclin_name) = 'BLOOD PRESSURE - DIASTOLIC' THEN 'Diastolic blood pressure'
                  ELSE raw_obsclin_name
                  END,
    obsclin_code   = CASE
            
                WHEN  (obsclin_code) = '3141-9' THEN '29463-7'
                WHEN  (obsclin_code) = '3137-7' THEN '8302-2'
                
               ELSE obsclin_code
            END,
  obsclin_result_unit = CASE
                WHEN (obsclin_result_unit) = '[in_us]' THEN 'cm'
                WHEN (obsclin_result_unit) = '[lb_av]' THEN 'kg'
                ELSE obsclin_result_unit
                END;
                  

/////////////////////////////////////////////////UNMC////////////////////////////////////////////////////





Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_UNMC.DEID_OBS_CLIN
CLONE  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UNMC_linked_vital_obsclin_table;

 
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UNMC_linked_vital_obsclin_table
SET obsclin_result_num = CASE
                  
                 WHEN (raw_obsclin_name) = 'Body height Measured' THEN Round (obsclin_result_num*2.54,1)
                 WHEN (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54,1)
                 WHEN (raw_obsclin_name) = 'Body weight Measured' THEN Round (obsclin_result_num*0.0283495,1)
                 WHEN (raw_obsclin_name) = 'Body weight' THEN Round  (obsclin_result_num*0.453592,1)
                 WHEN (raw_obsclin_name) = 'WT' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
raw_obsclin_result = CASE
                 WHEN (raw_obsclin_name) = 'Body weight Measured' THEN NULL
                 WHEN (raw_obsclin_name) = 'Body weight' THEN NULL
                 WHEN (raw_obsclin_name) = 'WT' THEN NULL
                 WHEN (raw_obsclin_name) = 'Body height Measured' THEN NULL
                 WHEN (raw_obsclin_name) = 'Body height' THEN NULL
                 ELSE raw_obsclin_result
                 END,
obsclin_code   = CASE
            
                WHEN  (obsclin_code) = '3141-9' THEN '29463-7'
                WHEN  (obsclin_code) = '3137-7' THEN '8302-2'
               ELSE obsclin_code
            END,
raw_obsclin_code   = CASE
            
                WHEN  (obsclin_code) = '3141-9' THEN '29463-7'
                WHEN  (obsclin_code) = '3137-7' THEN '8302-2'
               ELSE raw_obsclin_code
            END,
  raw_obsclin_unit = CASE
                  
                 WHEN (raw_obsclin_name) = 'Body weight Measured' THEN 'kg'
                 WHEN (raw_obsclin_name) = 'Body weight' THEN 'kg'
                 WHEN (raw_obsclin_name) = 'WT' THEN 'kg'
                 WHEN (raw_obsclin_name) = 'Body height Measured' THEN 'cm'
                 WHEN (raw_obsclin_name) = 'Body height' THEN 'cm'
                 ELSE raw_obsclin_unit
                 END,
  obsclin_result_unit = CASE
                 WHEN (raw_obsclin_name) = 'Body weight Measured' THEN 'kg'
                 WHEN (raw_obsclin_name) = 'Body weight' THEN 'kg'
                 WHEN (raw_obsclin_name) = 'WT' THEN 'kg'
                 WHEN (raw_obsclin_name) = 'Body height Measured' THEN 'cm'
                 WHEN (raw_obsclin_name) = 'Body height' THEN 'cm'
                 ELSE  obsclin_result_unit
                 END,
    raw_obsclin_name = CASE 
                  WHEN (raw_obsclin_name) = 'Body weight Measured' THEN 'Body weight'
                  WHEN (raw_obsclin_name) = 'Body weight' THEN 'Body weight'
                  WHEN (raw_obsclin_name) = 'WT' THEN 'Body weight'
                  WHEN (raw_obsclin_name) = 'Body height Measured' THEN 'Body height'
                  WHEN (raw_obsclin_name) = 'Body height' THEN 'Body height'
                  ELSE raw_obsclin_name
                END;
                
 /////////////////////////////////////////////UTHOUSTON/////////////////////////////////////////////////////////////////


Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_UTHOUSTON.DEID_OBS_CLIN
CLONE  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UTHOUSTON_LINKED_VITAL_OBSCLIN;

------
 
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UTHOUSTON_LINKED_VITAL_OBSCLIN
SET obsclin_result_num = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet'  
                 THEN Round (obsclin_result_num*30.48,1)
                 WHEN  (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces' 
                 THEN Round (obsclin_result_num*0.0283495,1)
                 ELSE Round ( obsclin_result_num,1)
             END,
obsclin_result_text = CASE
                  
                 WHEN lower (raw_obsclin_name) like '%height%'  THEN NULL
                 WHEN lower (raw_obsclin_name) like '%weight%' THEN NULL
                 ELSE  obsclin_result_text
             END,
            
raw_obsclin_result = CASE
                  
                 WHEN lower (raw_obsclin_name) like '%height%'  THEN NULL
                 WHEN lower (raw_obsclin_name) like '%weight%' THEN NULL
                 ELSE raw_obsclin_result
                 END,
 obsclin_result_unit  = CASE
            
               WHEN (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet' THEN 'cm'
               WHEN (raw_obsclin_name) = 'Height' and obsclin_code = '8' THEN 'cm'
               WHEN (raw_obsclin_name) = 'Pedi Height'  THEN 'cm'
               WHEN (raw_obsclin_name) = 'Height > 9 feet'  THEN 'cm'
               WHEN  (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces'THEN 'Kg'
               WHEN  (raw_obsclin_name) = 'Weight - every visit' THEN 'Kg'
               WHEN  (raw_obsclin_name) = 'Pedi Weight' THEN 'Kg'
               WHEN  (raw_obsclin_name) = 'UTP - Pedi Weight' THEN 'Kg'
               WHEN (raw_obsclin_name) = 'Weight' and obsclin_code = '9' THEN 'kg'
               WHEN  (raw_obsclin_name) = 'BMI' THEN 'kg/m2'
               WHEN  (raw_obsclin_name) = 'BMI Calculated' THEN 'kg/m2'
               WHEN  (raw_obsclin_name) = 'Systolic' THEN 'mm[Hg]'
               WHEN  (raw_obsclin_name) = 'Diastolic' THEN 'mm[Hg]'
               
               ELSE obsclin_result_unit
            END,
raw_obsclin_unit  = CASE
            
                WHEN (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet' THEN 'cm'
                WHEN (raw_obsclin_name) = 'Height' and obsclin_code = '8' THEN 'cm'
                WHEN (raw_obsclin_name) = 'Pedi Height'  THEN 'cm'
               WHEN (raw_obsclin_name) = 'Height > 9 feet'  THEN 'cm'
               WHEN (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces'THEN 'Kg'
               WHEN  (raw_obsclin_name) = 'Weight - every visit' THEN 'Kg'
               WHEN (raw_obsclin_name) = 'Weight' and obsclin_code = '9' THEN 'kg'
               WHEN  (raw_obsclin_name) = 'Pedi Weight' THEN 'Kg'
               WHEN  (raw_obsclin_name) = 'UTP - Pedi Weight' THEN 'Kg'
               WHEN  (raw_obsclin_name) = 'BMI' THEN 'kg/m2'
               WHEN  (raw_obsclin_name) = 'BMI Calculated' THEN 'kg/m2'
               WHEN  (raw_obsclin_name) = 'Systolic' THEN 'mm[Hg]'
               WHEN  (raw_obsclin_name) = 'Diastolic' THEN 'mm[Hg]'
               ELSE raw_obsclin_unit
            END,
obsclin_code  = CASE
            
                WHEN (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet' THEN '8302-2'
                WHEN lower (raw_obsclin_name) like '%height%' and raw_obsclin_unit = 'cm' THEN '8302-2'
               WHEN  (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces'THEN '29463-7'
               WHEN lower (raw_obsclin_name) like '%weight%' and raw_obsclin_unit = 'kg' THEN '29463-7'
               WHEN  (raw_obsclin_name) = 'Weight - every visit' THEN '29463-7'
               WHEN  (raw_obsclin_name) = 'BMI' THEN '39156-5'
               WHEN  (raw_obsclin_name) = 'BMI Calculated' THEN '39156-5'
               WHEN  (raw_obsclin_name) = 'Systolic' THEN '8480-6'
               WHEN  (raw_obsclin_name) = 'Diastolic' THEN '8462-4'
               ELSE obsclin_code
            END,
raw_obsclin_code  = CASE
            
              WHEN (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet' THEN '8302-2'
              WHEN lower (raw_obsclin_name) like '%height%' and raw_obsclin_unit = 'cm' THEN '8302-2'
               WHEN  (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces'THEN '29463-7'
               WHEN lower (raw_obsclin_name) like '%weight%' and raw_obsclin_unit = 'kg' THEN '29463-7'
               WHEN  (raw_obsclin_name) = 'Weight - every visit' THEN '29463-7'
               WHEN  (raw_obsclin_name) = 'BMI' THEN '39156-5'
               WHEN  (raw_obsclin_name) = 'BMI Calculated' THEN '39156-5'
               WHEN  (raw_obsclin_name) = 'Systolic' THEN '8480-6'
                WHEN  (raw_obsclin_name) = 'Diastolic' THEN '8462-4'
               ELSE raw_obsclin_code 
            END,
raw_obsclin_name  = CASE
            
              WHEN (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet' THEN 'Body height'
              WHEN (raw_obsclin_name) = 'Pedi Height'  THEN 'Body height'
              WHEN (raw_obsclin_name) = 'Height > 9 feet'  THEN 'Body height'
              WHEN (raw_obsclin_name) = 'Height'  THEN 'Body height'
              WHEN (raw_obsclin_name) = 'Height' and obsclin_code = '8' THEN 'Body height'
              WHEN (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces'THEN 'Body weight'
              WHEN (raw_obsclin_name) = 'Weight' THEN 'Body weight'
              WHEN (raw_obsclin_name) = 'Pedi Weight' THEN 'Body weight'
              WHEN (raw_obsclin_name) = 'UTP - Pedi Weight' THEN 'Body weight'
              WHEN  (raw_obsclin_name) = 'BMI' THEN 'Body mass index(BMI)[Ratio]'
              WHEN  (raw_obsclin_name) = 'BMI Calculated' THEN 'Body mass index(BMI)[Ratio]'
              WHEN  (raw_obsclin_name) = 'Systolic' THEN 'Systolic blood pressure'
               WHEN  (raw_obsclin_name) = 'Diastolic' THEN 'Diastolic blood pressure'
              ELSE raw_obsclin_name
            END,
obsclin_type   = CASE
              WHEN (raw_obsclin_name) = 'Height' and raw_obsclin_unit = 'Feet' THEN 'LC'
              WHEN (raw_obsclin_name) = 'Pedi Height'  THEN 'LC'
              WHEN (raw_obsclin_name) = 'Height > 9 feet'  THEN 'LC'
              WHEN (raw_obsclin_name) = 'Height'  THEN 'LC'
              WHEN (raw_obsclin_name) = 'Weight' and raw_obsclin_unit = 'Ounces'THEN 'LC'
              WHEN (raw_obsclin_name) = 'Weight' THEN 'LC'
              WHEN (raw_obsclin_name) = 'Pedi Weight' THEN 'LC'
              WHEN (raw_obsclin_name) = 'UTP - Pedi Weight' THEN 'LC'
              WHEN  (raw_obsclin_name) = 'BMI' THEN 'LC'
              WHEN  (raw_obsclin_name) = 'BMI Calculated' THEN 'LC'
              WHEN  (raw_obsclin_name) = 'Systolic' THEN 'LC'
              WHEN  (raw_obsclin_name) = 'Diastolic' THEN 'LC'
              ELSE obsclin_type
            END;


    

;
------------------
/////////////////////////////////////////////UTHSCSA//////////////////////////////////////////////////////////////



Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_UTHSCSA.DEID_OBS_CLIN
CLONE  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UTHSCSA_LINKED_VITAL_OBSCLIN;

-----

UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UTHSCSA_LINKED_VITAL_OBSCLIN
SET obsclin_result_num = CASE
                  
                 WHEN  (raw_obsclin_name) =  'Body height'   THEN Round (obsclin_result_num*2.54,1)
                 WHEN (raw_obsclin_name) = 'Body weight'  THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
     raw_obsclin_result = CASE
                  
                 WHEN  (raw_obsclin_name) =  'Body height'   THEN NULL
                 WHEN (raw_obsclin_name) = 'Body weight'  THEN NULL
                 ELSE raw_obsclin_result
             END;
            


/////////////////////////////////////////////UTSW/////////////////////////////////////////////////////////////////




Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_UTSW.DEID_OBS_CLIN
CLONE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.CLEANED_UTSW_OBSCLIN ;


/*Create table for UTSW obsclin data*/
CREATE OR REPLACE TABLE  CLEANED_UTSW_OBSCLIN AS 
SELECT * FROM GROUSE_DB.PCORNET_CDM_UTSW.V_DEID_OBS_CLIN;

UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.CLEANED_UTSW_OBSCLIN
SET obsclin_result_num = CASE
                  
                 WHEN obsclin_code = '8302-2' AND OBSCLIN_RESULT_UNIT = '[in_us]'  THEN Round (obsclin_result_num*2.54,1)
                 WHEN  obsclin_code = '3141-9' AND OBSCLIN_RESULT_UNIT = '[lb_av]' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
obsclin_code  = CASE
            
                
               WHEN obsclin_code = '3141-9' THEN '29463-7'
               ELSE obsclin_code
            END,
raw_obsclin_code  = CASE
            
                WHEN obsclin_code = '8302-2' THEN '8302-2'
               WHEN obsclin_code = '3141-9' THEN '29463-7'
               WHEN obsclin_code = '39156-5' THEN '39156-5'
               WHEN obsclin_code = '8462-4' THEN '8462-4'
               WHEN obsclin_code = '8480-6' THEN '8480-6'
               ELSE raw_obsclin_code
            END,
            
 obsclin_result_unit  = CASE
            
                WHEN obsclin_code = '8302-2' THEN 'cm'
               WHEN obsclin_code = '3141-9' THEN 'Kg'
               WHEN obsclin_code = '39156-5' THEN 'kg/m2'
               WHEN obsclin_code = '8462-4' THEN 'mm[Hg]'
               WHEN obsclin_code = '8480-6' THEN 'mm[Hg]'
               ELSE obsclin_result_unit
            END,
 RAW_OBSCLIN_NAME  = CASE

                WHEN obsclin_code = '8302-2' THEN 'Body height'
               WHEN obsclin_code = '3141-9' THEN 'Body weight'
               WHEN obsclin_code = '39156-5' THEN 'Body mass index(BMI)[Ratio]'
               WHEN obsclin_code = '8462-4' THEN 'Diastolic blood pressure'
               WHEN obsclin_code = '8480-6' THEN 'Systolic blood pressure'
                ELSE RAW_OBSCLIN_NAME
                
            END;
            

/////////////////////////////////////////////////////////UU//////////////////////////////////////////////////////////////////




Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_UU.DEID_OBS_CLIN
CLONE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UU_LINKED_VITAL_OBSCLIN ;
 -----------------
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.UU_LINKED_VITAL_OBSCLIN
SET obsclin_result_num = CASE
                  
                 WHEN  (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54, 1) 
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN Round (obsclin_result_num*0.453592, 1)
                 ELSE obsclin_result_num
             END;
 
            

/////////////////////////////////////////////WHASHU////////////////////////////////////////////////////////////////////////




Create TABLE GROUSE_DB_QUAIL.PCORNET_CDM_WASHU.DEID_OBS_CLIN
CLONE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.WHASHU_OBSCLIN_VITAL ;

select * from GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.WHASHU_OBSCLIN_VITAL
limit 1000;

--------------
UPDATE GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.WHASHU_OBSCLIN_VITAL
SET obsclin_result_num = CASE
                  WHEN  (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54,1)
                 WHEN   (raw_obsclin_name) = 'Body weight' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE obsclin_result_num
             END,
    raw_obsclin_result = CASE
                  WHEN  (raw_obsclin_name) = 'Body height' THEN Round (obsclin_result_num*2.54,1)
                 WHEN  (raw_obsclin_name) = 'Body weight' THEN Round (obsclin_result_num*0.453592,1)
                 ELSE  raw_obsclin_result
             END;


               
            
