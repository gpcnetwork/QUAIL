/*Linkage of vital table to obsclin MU data*/

/*Records of height not exsit in OBSCLIN table*/

CREATE OR replace TABLE not_exsit_in_obslcin_ht as
SELECT a.patid, a.measure_date,a.measure_time, a.encounterid 
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A 
WHERE HT  IS NOT NULL 
MINUS SELECT b.patid, b.obsclin_date,b.obsclin_time, b.encounterid
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN  B 
WHERE (lower (b.RAW_OBSCLIN_NAME) LIKE  'height (cm)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'height (feet)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'height (inches)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'height/length measured%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'height (inches calc)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'height/length estimated%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'height/length dosing%');

/*Create table for data exists in vital not obsclin*/
CREATE OR REPLACE TABLE   insert_obsc_ht AS
SELECT a.* FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A
 JOIN grouse_db_quail.dq_clean_table.not_exsit_in_obslcin_ht b ON b.patid = a.patid
 AND b.encounterid = a.encounterid AND b.MEASURE_DATE = a.measure_date AND b.measure_time = a.measure_time;

/*Records of weight not exsit in OBSCLIN table*/
/*check for different wt names in obclin*/
SELECT COUNT  (DISTINCT patid), raw_obsclin_name, raw_obsclin_code
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN
 WHERE UPPER (RAW_OBSCLIN_NAME) LIKE 'WEIGHT%'
 GROUP BY raw_obsclin_name, raw_obsclin_code;
 
/*create table for data in vital table not exists in obclin*/
CREATE OR REPLACE TABLE Not_exists_in_obsclin_wt AS 
SELECT a.patid, a.measure_date,a.measure_time, a.encounterid 
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A 
WHERE WT IS NOT NULL
MINUS SELECT b.patid, b.obsclin_date,b.obsclin_time, b.encounterid
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN  B 
WHERE (lower (b.RAW_OBSCLIN_NAME) LIKE  'weight (lbs calc)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight (kg)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight (lbs)%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight measured%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight for height/length percentile%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight percentile%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight estimated%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'weight-dialysis%');

 /*Records of BMI not exsit in OBSCLIN table*/ 
/*check for different BMI names in obclin*/
SELECT COUNT  (DISTINCT  patid), raw_obsclin_name, raw_obsclin_code
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN
 WHERE UPPER (RAW_OBSCLIN_NAME) LIKE 'BMI%'
 GROUP BY raw_obsclin_name, raw_obsclin_code;


/*create table for data in vital table not exists in obclin*/
CREATE OR REPLACE TABLE Not_exists_in_obsclin_bmi AS 
SELECT a.patid, a.measure_date,a.measure_time, a.encounterid 
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A 
WHERE original_bmi  IS NOT NULL 
MINUS SELECT b.patid, b.obsclin_date,b.obsclin_time, b.encounterid
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN  B 
WHERE  (lower (b.RAW_OBSCLIN_NAME) LIKE  'bmi%'
 OR lower (b.RAW_OBSCLIN_NAME) LIKE  'bmi percentile%'
);

/*Create table for data exists in vital not obsclin*/
CREATE OR REPLACE TABLE  insert_obsc_bmi AS
SELECT  a.* FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A
JOIN grouse_db_quail.dq_clean_table.Not_exists_in_obsclin_bmi b ON  b.patid = a.patid
AND  b.encounterid = a.encounterid AND b.MEASURE_DATE = a.measure_date AND b.measure_time = a.measure_time;


/*Records of daistolic blood prossure (DBP) not exsit in OBSCLIN table*/  
/*check for different DBP names in obclin*/
SELECT COUNT  (DISTINCT patid), raw_obsclin_name, raw_obsclin_code
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN
 WHERE (upper (raw_obsclin_name) LIKE '%DIASTOLIC%'
 OR upper (raw_obsclin_name) LIKE '%DBP%'
)
GROUP BY raw_obsclin_name, raw_obsclin_code;
 
/*create table for data in vital table not exists in obclin*/
CREATE OR REPLACE TABLE Not_exists_in_obsclin_dbp AS 
SELECT a.patid, a.measure_date,a.measure_time, a.encounterid 
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A 
WHERE  diastolic IS NOT NULL 
MINUS SELECT b.patid, b.obsclin_date,b.obsclin_time, b.encounterid
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN  B 
WHERE (lower (raw_obsclin_name) LIKE '%diastolic%'
OR upper (raw_obsclin_name) LIKE '%dbp%'
);

/*Create table for data exists in vital not obsclin*/
Create OR REPALCE TABLE   insert_obsc_dbp AS
SELECT a.* FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A
JOIN grouse_db_quail.dq_clean_table.NOT_EXISTS_IN_OBSCLIN_DBP b ON b.patid = a.patid
AND b.encounterid = a.encounterid AND b.MEASURE_DATE = a.measure_date AND b.measure_time = a.measure_time;

/*Records of systolic blood prossure (SBP) not exsit in OBSCLIN table*/
/*check for different BMI names in obclin*/
SELECT COUNT   (DISTINCT  patid), raw_obsclin_name, raw_obsclin_code
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN
WHERE (upper (raw_obsclin_name) LIKE '%SYSTOLIC%'
OR  upper (raw_obsclin_name) LIKE '%SBP%')
GROUP BY raw_obsclin_name, raw_obsclin_code;

/*create table for data in vital table not exists in obclin*/
CREATE OR REPLACE TABLE Not_exists_in_obsclin_sbp AS 
SELECT a.patid, a.measure_date,a.measure_time, a.encounterid 
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A 
WHERE  systolic IS NOT NULL  
MINUS SELECT b.patid, b.obsclin_date,b.obsclin_time, b.encounterid
FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN  B 
WHERE  (lower (raw_obsclin_name) LIKE '%systolic%'
 or upper (raw_obsclin_name) LIKE '%sbp%'
); 


/*Create table for data exists in vital not obsclin*/
CREATE OR REPLACE TABLE insert_obsc_sbp AS
SELECT  a.* FROM GROUSE_DB.PCORNET_CDM_MU.LDS_VITAL A
JOIN grouse_db_quail.dq_clean_table.NOT_EXISTS_IN_OBSCLIN_sBP b ON b.patid = a.patid
AND b.encounterid = a.encounterid AND b.MEASURE_DATE = a.measure_date AND b.measure_time = a.measure_time;


/*vital HT inserted to obsclin */
CREATE OR REPLACE TABLE vital_insert_HT AS 
SELECT 
	NULL AS RAW_OBSCLIN_MODIFIER,
    MEASURE_DATE AS OBSCLIN_DATE , 
	NULL AS OBSCLIN_SOURCE,
	HT AS RAW_OBSCLIN_RESULT,
	NULL AS  OBSCLIN_RESULT_QUAL,
	MEASURE_TIME  AS OBSCLIN_START_TIME,
	NULL AS RAW_OBSCLIN_CODE ,
	NULL AS RAW_OBSCLIN_TYPE,
	'HT' AS RAW_OBSCLIN_NAME,
	NULL AS OBSCLIN_RESULT_UNIT, ---NO UNITS IN VITAL
	NULL AS OBSCLIN_TYPE,
	NULL AS OBSCLIN_PROVIDERID,
	HT AS OBSCLIN_RESULT_NUM ,
	NULL AS OBSCLIN_STOP_DATE ,
	NULL  AS  OBSCLIN_CODE ,
	PATID,
	NULL AS OBSCLIN_RESULT_MODIFIER,
	ENCOUNTERID ,
	MEASURE_TIME AS OBSCLIN_TIME,
	MEASURE_DATE AS OBSCLIN_START_DATE,
	NULL AS RAW_OBSCLIN_UNIT ,
	NULL AS OBSCLINID ,
	'50373000' AS OBSCLIN_RESULT_SNOMED,
	NULL AS OBSCLIN_ABN_IND,
	NULL AS OBSCLIN_STOP_TIME ,
        NULL AS OBSCLIN_RESULT_TEXT 
FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.INSERT_OBSC_HT;

/*vital Wt inserted to obsclin */
CREATE OR REPLACE TABLE  vital_insert_wt AS

SELECT 
	NULL AS RAW_OBSCLIN_MODIFIER,
    MEASURE_DATE AS OBSCLIN_DATE , 
	NULL AS OBSCLIN_SOURCE,
	WT AS RAW_OBSCLIN_RESULT,
	NULL AS  OBSCLIN_RESULT_QUAL,
	MEASURE_TIME  AS OBSCLIN_START_TIME,
	NULL AS RAW_OBSCLIN_CODE ,
	NULL AS RAW_OBSCLIN_TYPE,
	'WT' AS RAW_OBSCLIN_NAME,
	NULL AS OBSCLIN_RESULT_UNIT, ---NO UNITS IN VITAL
	NULL AS OBSCLIN_TYPE,
	NULL AS OBSCLIN_PROVIDERID,
	WT AS OBSCLIN_RESULT_NUM ,
	NULL AS OBSCLIN_STOP_DATE ,
	NULL AS  OBSCLIN_CODE ,
	PATID,
	NULL AS OBSCLIN_RESULT_MODIFIER,
	ENCOUNTERID ,
	MEASURE_TIME AS OBSCLIN_TIME,
	MEASURE_DATE AS OBSCLIN_START_DATE,
	NULL AS RAW_OBSCLIN_UNIT ,
	NULL AS OBSCLINID ,
	'27113001' AS OBSCLIN_RESULT_SNOMED,
	NULL AS OBSCLIN_ABN_IND,
	NULL AS OBSCLIN_STOP_TIME ,
        NULL AS OBSCLIN_RESULT_TEXT 
FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.insert_obsc_wt;

/*vital  BMI nserted to obsclin */
CREATE OR REPALCE TABLE  vital_insert_BMI AS 

SELECT 
	NULL AS RAW_OBSCLIN_MODIFIER,
    MEASURE_DATE AS OBSCLIN_DATE , 
	NULL AS OBSCLIN_SOURCE,
	original_bmi AS RAW_OBSCLIN_RESULT,
	NULL AS  OBSCLIN_RESULT_QUAL,
	MEASURE_TIME  AS OBSCLIN_START_TIME,
	NULL AS RAW_OBSCLIN_CODE ,
	NULL AS RAW_OBSCLIN_TYPE,
	'BMI' AS RAW_OBSCLIN_NAME,
	NULL AS OBSCLIN_RESULT_UNIT, ---NO UNITS IN VITAL
	NULL AS OBSCLIN_TYPE,
	NULL AS OBSCLIN_PROVIDERID,
	original_bmi AS OBSCLIN_RESULT_NUM ,
	NULL AS OBSCLIN_STOP_DATE ,
	NULL  AS  OBSCLIN_CODE ,
	PATID,
	NULL AS OBSCLIN_RESULT_MODIFIER,
	ENCOUNTERID ,
	MEASURE_TIME AS OBSCLIN_TIME,
	MEASURE_DATE AS OBSCLIN_START_DATE,
	NULL AS RAW_OBSCLIN_UNIT ,
	NULL AS OBSCLINID ,
	'60621009' AS OBSCLIN_RESULT_SNOMED,
	NULL AS OBSCLIN_ABN_IND,
	NULL AS OBSCLIN_STOP_TIME ,
        NULL AS OBSCLIN_RESULT_TEXT 
FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.INSERT_OBSC_BMI;

/*vital  DBP nserted to obsclin */
CREATE OR REPALCE TABLE  vital_insert_DBP AS 

SELECT 
	NULL AS RAW_OBSCLIN_MODIFIER,
    MEASURE_DATE AS OBSCLIN_DATE , 
	NULL AS OBSCLIN_SOURCE,
	diastolic AS RAW_OBSCLIN_RESULT,
	NULL AS  OBSCLIN_RESULT_QUAL,
	MEASURE_TIME  AS OBSCLIN_START_TIME,
	NULL AS RAW_OBSCLIN_CODE ,
	NULL AS RAW_OBSCLIN_TYPE,
	'DBP' AS RAW_OBSCLIN_NAME,
	NULL AS OBSCLIN_RESULT_UNIT, ---NO UNITS IN VITAL
	NULL AS OBSCLIN_TYPE,
	NULL AS OBSCLIN_PROVIDERID,
	diastolic AS OBSCLIN_RESULT_NUM ,
	NULL AS OBSCLIN_STOP_DATE ,
	NULL  AS  OBSCLIN_CODE ,
	PATID,
	NULL AS OBSCLIN_RESULT_MODIFIER,
	ENCOUNTERID ,
	MEASURE_TIME AS OBSCLIN_TIME,
	MEASURE_DATE AS OBSCLIN_START_DATE,
	NULL AS RAW_OBSCLIN_UNIT ,
	NULL AS OBSCLINID ,
	NULL AS OBSCLIN_RESULT_SNOMED,
	NULL AS OBSCLIN_ABN_IND,
	NULL AS OBSCLIN_STOP_TIME ,
        NULL AS OBSCLIN_RESULT_TEXT 
FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.INSERT_OBSC_DBP;

/*vital  SBP nserted to obsclin */
CREATE OR REPALCE TABLE vital_insert_SBP AS 

SELECT 
	NULL AS RAW_OBSCLIN_MODIFIER,
    MEASURE_DATE AS OBSCLIN_DATE , 
	NULL AS OBSCLIN_SOURCE,
    systolic AS RAW_OBSCLIN_RESULT,
	NULL AS  OBSCLIN_RESULT_QUAL,
	MEASURE_TIME  AS OBSCLIN_START_TIME,
	NULL AS RAW_OBSCLIN_CODE ,
	NULL AS RAW_OBSCLIN_TYPE,
	'SBP' AS RAW_OBSCLIN_NAME,
	NULL AS OBSCLIN_RESULT_UNIT, ---NO UNITS IN VITAL
	NULL AS OBSCLIN_TYPE,
	NULL AS OBSCLIN_PROVIDERID,
	systolic AS OBSCLIN_RESULT_NUM ,
	NULL AS OBSCLIN_STOP_DATE ,
	NULL  AS  OBSCLIN_CODE ,
	PATID,
	NULL AS OBSCLIN_RESULT_MODIFIER,
	ENCOUNTERID ,
	MEASURE_TIME AS OBSCLIN_TIME,
	MEASURE_DATE AS OBSCLIN_START_DATE,
	NULL AS RAW_OBSCLIN_UNIT ,
	NULL AS OBSCLINID ,
	NULL AS OBSCLIN_RESULT_SNOMED,
	NULL AS OBSCLIN_ABN_IND,
	NULL AS OBSCLIN_STOP_TIME ,
        NULL AS OBSCLIN_RESULT_TEXT 
FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.INSERT_OBSC_SBP;

/*Create the whole table for missed data in obsclin table */
CREATE OR REPLACE TABLE INSERT_IN_OBC_ALL AS 
SELECT * FROM  GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.vital_insert_wt
UNION 
SELECT * FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.vital_insert_HT
UNION 
SELECT * FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.VITAL_INSERT_BMI
UNION 
SELECT * FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.VITAL_INSERT_DBP
UNION 
SELECT * FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.VITAL_INSERT_SBP;


/*Modify colunm data type*/
CREATE OR REPLACE TABLE Modified_INSERT_IN_OBC_ALL AS

SELECT RAW_OBSCLIN_MODIFIER,
     OBSCLIN_DATE , 
	OBSCLIN_SOURCE,
    CAST( RAW_OBSCLIN_RESULT AS VARCHAR(200)) AS RAW_OBSCLIN_RESULT,
	 OBSCLIN_RESULT_QUAL,
	OBSCLIN_START_TIME,
	RAW_OBSCLIN_CODE ,
	RAW_OBSCLIN_TYPE,
	 RAW_OBSCLIN_NAME,
	OBSCLIN_RESULT_UNIT, ---NO UNITS IN VITAL
	OBSCLIN_TYPE,
	OBSCLIN_PROVIDERID,
	CAST( OBSCLIN_RESULT_NUM AS VARCHAR(200))AS OBSCLIN_RESULT_NUM ,
	 OBSCLIN_STOP_DATE ,
	OBSCLIN_CODE ,
	PATID,
	 OBSCLIN_RESULT_MODIFIER,
	ENCOUNTERID ,
	 OBSCLIN_TIME,
	OBSCLIN_START_DATE,
	RAW_OBSCLIN_UNIT ,
	 OBSCLINID ,
	 OBSCLIN_RESULT_SNOMED,
	OBSCLIN_ABN_IND,
    OBSCLIN_STOP_TIME ,
     OBSCLIN_RESULT_TEXT  

FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.INSERT_IN_OBC_ALL
;

/*The final linked table*/
CREATE OR REPLACE TABLE linked_vital_obsclin_table AS
SELECT * FROM GROUSE_DB_QUAIL.DQ_CLEAN_TABLE.MODIFIED_INSERT_IN_OBC_ALL
UNION 
SELECT * FROM GROUSE_DB.PCORNET_CDM_MU.LDS_OBS_CLIN;
;


