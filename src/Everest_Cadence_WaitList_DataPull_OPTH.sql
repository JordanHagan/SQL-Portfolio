/*CREATE VOLATILE TABLES*/
------------------------------------------------------------------------------------------------------
--------------------- CREATE VT_DIS_NOTE TABLE---------------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE VT_DIS_NOTE AS (
	SELECT X.*,
	ROW_NUMBER() OVER (PARTITION BY PK ORDER BY EPT_DotOne) AS RN		
	FROM (SELECT Distinct 
		CAST(TRIM(WTL.PAT_ENC_CSN_ID) || TRIM(WTL.WT_START_DATE) as VARCHAR (225)) as PK, 
		EPT_MAP.INTERNAL_ID as EPT_DotOne,
		WTL.WT_START_DATE as START_DATE_EPT_7285,
		SER.PROV_NAME as WT_PROV_NAME_EPT_7265,
		DEP.DEPARTMENT_NAME as WT_DEP_NAME_EPT_7260,
		ZCWTP.NAME as WL_PRIORITY_EPT_7275,
		WTL.WT_END_DATE as END_DATE_EPT_7290,
		' ' as APPT_MES_EPT_7620,
		WTL_NT.WAIT_DISPLAY_NOTE as WT_DISPLY_NOTE_EPT_7296
		FROM 
		PAT_ENC_WT_LST  WTL
		Inner Join EPT_MAP on WTL.PAT_ID=EPT_MAP.CID 
		Left Join ZC_WAIT_STATUS ZCWTL on WTL.WAIT_STATUS_C=ZCWTL.WAIT_STATUS_C
		Left Join CLARITY_PRC PRC on WTL.PRC_ID=PRC.PRC_ID
		Left Join PAT_ENC_WT_LST_DP WTL_DP on WTL.PAT_ENC_CSN_ID=WTL_DP.PAT_ENC_CSN_ID
		Left Join PAT_ENC_WT_LST_NT WTL_NT on WTL.PAT_ENC_CSN_ID=WTL_NT.PAT_ENC_CSN_ID 
		Left Join CLARITY_SER SER on WTL_DP.PROV_ID=SER.PROV_ID
		Inner Join CLARITY_DEP DEP on WTL_DP.DEPARTMENT_ID=DEP.DEPARTMENT_ID
		Left Join PAT_ENC_APPT_MSG APPT on WTL.PAT_ENC_CSN_ID=APPT.PAT_ENC_CSN_ID
		Left Join ZC_WAIT_PRIORITY ZCWTP on ZCWTP.WAIT_PRIORITY_C=WTL.WAIT_PRIORITY_C
		WHERE 
		WTL.WAIT_STATUS_C in any ('1','2','4')
		And WTL_DP.LINE='1'
		And DEP.DEPARTMENT_NAME like any ('%OPT%','%OPHTH%','REG OPHTHAL%')
		And DEP.DEPARTMENT_NAME not like ('%[OVERRIDE RECORD]%')
		And PK is not null) as X ) 
With DATA Primary Index (PK) On Commit Preserve Rows;

------------------------------------------------------------------------------------------------------
--------------------- CREATE VT_APPT_MES TABLE---------------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE VT_APPT_MES AS (
	SELECT Y.*,
	ROW_NUMBER() OVER (PARTITION BY PK ORDER BY EPT_DotOne) AS RN		
	FROM(SELECT Distinct 
		CAST(TRIM(WTL.PAT_ENC_CSN_ID) || TRIM(WTL.WT_START_DATE) as VARCHAR (225)) as PK, 
		EPT_MAP.INTERNAL_ID as EPT_DotOne,
		WTL.WT_START_DATE as START_DATE_EPT_7285,
		SER.PROV_NAME as WT_PROV_NAME_EPT_7265,
		DEP.DEPARTMENT_NAME as WT_DEP_NAME_EPT_7260,
		ZCWTP.NAME as WL_PRIORITY_EPT_7275,
		WTL.WT_END_DATE as END_DATE_EPT_7290,
		APPT.APPT_MESSAGE as APPT_MES_EPT_7620,
		' ' as WT_DISPLY_NOTE_EPT_7296
		FROM 
		PAT_ENC_WT_LST  WTL
		Inner Join EPT_MAP on WTL.PAT_ID=EPT_MAP.CID 
		Left Join ZC_WAIT_STATUS ZCWTL on WTL.WAIT_STATUS_C=ZCWTL.WAIT_STATUS_C
		Left Join CLARITY_PRC PRC on WTL.PRC_ID=PRC.PRC_ID
		Left Join PAT_ENC_WT_LST_DP WTL_DP on WTL.PAT_ENC_CSN_ID=WTL_DP.PAT_ENC_CSN_ID
		Left Join PAT_ENC_WT_LST_NT WTL_NT on WTL.PAT_ENC_CSN_ID=WTL_NT.PAT_ENC_CSN_ID 
		Left Join CLARITY_SER SER on WTL_DP.PROV_ID=SER.PROV_ID
		Inner Join CLARITY_DEP DEP on WTL_DP.DEPARTMENT_ID=DEP.DEPARTMENT_ID
		Left Join PAT_ENC_APPT_MSG APPT on WTL.PAT_ENC_CSN_ID=APPT.PAT_ENC_CSN_ID
		Left Join ZC_WAIT_PRIORITY ZCWTP on ZCWTP.WAIT_PRIORITY_C=WTL.WAIT_PRIORITY_C
		WHERE 
		WTL.WAIT_STATUS_C in any ('1','2','4')
		And WTL_DP.LINE='1'
		And DEP.DEPARTMENT_NAME like any ('%OPT%','%OPHTH%','REG OPHTHAL%')
		And DEP.DEPARTMENT_NAME not like ('%[OVERRIDE RECORD]%')
		And PK is not null) as Y )
With DATA Primary Index (PK) On Commit Preserve Rows;
---------------------------------------------------------------------------------------------------------------------------------------------
/*Test Temp Table, If Needed*/
--Select * From VT_APPT_MES;
--Select * From VT_DIS_NOTE;

/*Drop Temp Table, If Needed*/
--Drop Table VT_APPT_MES;
--Drop Table VT_DIS_NOTE;
------------------------------------------------------------------------------------------------------------------------------------------

/*CREATE TEMP TABLES WITH THE RECURSIVE ROWS */
------------------------------------------------------------------------------------------------------
--------------------- CREATE REC_DIS_NOTE TABLE------------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE REC_DIS_NOTE AS (
WITH RECURSIVE REC_TEST (
	PK_1,
	EPT_1,
	EPT_7285,
	EPT_7265,
	EPT_7260,
	EPT_7275,
	EPT_7290,
	EPT_7620,
	EPT_7296,
	LVL) 
as (Select 
	CAST(PK as VARCHAR(225)),
	EPT_DotOne,
	CAST(START_DATE_EPT_7285 as DATE),
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	WL_PRIORITY_EPT_7275,
	CAST(END_DATE_EPT_7290 as DATE),
	APPT_MES_EPT_7620(VARCHAR(3000)),
	WT_DISPLY_NOTE_EPT_7296(VARCHAR(3000)),
	CAST(1 as DECIMAL (18,0))
    From VT_DIS_NOTE
    Where RN = '1'
UNION ALL
    Select 
	CAST(PK as VARCHAR(225)),
	EPT_DotOne,
	CAST(START_DATE_EPT_7285 as DATE),
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	WL_PRIORITY_EPT_7275,
	CAST(END_DATE_EPT_7290 as DATE),
	TRIM(WT_DISPLY_NOTE_EPT_7296) || ' ' || EPT_7296, 
	TRIM(APPT_MES_EPT_7620)  || ' ' || EPT_7620,
	CAST(LVL+1 as DECIMAL (18,0))
    From VT_DIS_NOTE 
    Inner Join REC_TEST on PK = PK_1 and VT_DIS_NOTE.RN = REC_TEST.LVL+1)
SELECT *
FROM REC_TEST
QUALIFY RANK() OVER(PARTITION BY PK_1 ORDER BY LVL DESC) = 1) 
With DATA Primary Index (PK_1) On Commit Preserve Rows;
------------------------------------------------------------------------------------------------------
--------------------- CREATE REC_APPT_MES TABLE-----------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE REC_APPT_MES AS (
WITH RECURSIVE REC_TEST (
	PK_1,
	EPT_1,
	EPT_7285,
	EPT_7265,
	EPT_7260,
	EPT_7275,
	EPT_7290,
	EPT_7620,
	EPT_7296,
	LVL) 
as (Select 
	CAST(PK as VARCHAR(225)),
	EPT_DotOne,
	CAST(START_DATE_EPT_7285 as DATE),
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	WL_PRIORITY_EPT_7275,
	CAST(END_DATE_EPT_7290 as DATE),
	APPT_MES_EPT_7620(VARCHAR(3000)),
	WT_DISPLY_NOTE_EPT_7296(VARCHAR(3000)),
	CAST(1 as DECIMAL (18,0))
    From VT_DIS_NOTE
    Where RN = '1'
UNION ALL
    Select 
	CAST(PK as VARCHAR(225)),
	EPT_DotOne,
	CAST(START_DATE_EPT_7285 as DATE),
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	WL_PRIORITY_EPT_7275,
	CAST(END_DATE_EPT_7290 as DATE),
	TRIM(WT_DISPLY_NOTE_EPT_7296) || ' ' || EPT_7296, 
	TRIM(APPT_MES_EPT_7620)  || ' ' || EPT_7620,
	CAST(LVL+1 as DECIMAL (18,0))
    From VT_APPT_MES 
    Inner Join REC_TEST on PK = PK_1 and VT_APPT_MES.RN = REC_TEST.LVL+1)
SELECT *
FROM REC_TEST
QUALIFY RANK() OVER(PARTITION BY PK_1 ORDER BY LVL DESC) = 1) 
With DATA Primary Index (PK_1) On Commit Preserve Rows;
---------------------------------------------------------------------------------------------------------------------------------------------
/*Test Temp Table, If Needed*/
--Select * From REC_DIS_NOTE;
--Select * From REC_APPT_MES;

/*Drop Temp Table, If Needed*/
--Drop Table REC_DIS_NOTE;
--Drop Table REC_APPT_MES;
----------------------------------------------------------------------------------------------------------------------------------------------

/*PULL FINAL COMBINED DATA*/
SELECT 
	NOTE.EPT_1,
	NOTE.EPT_7285,
	NOTE.EPT_7265,
	NOTE.EPT_7260,
	NOTE.EPT_7275,
	NOTE.EPT_7290,
	CASE When MES.EPT_7296=' ' Then NOTE.EPT_7296 Else Null END as NOTE_EPT_7296,
	CASE When NOTE.EPT_7620=' ' Then MES.EPT_7620 Else Null END as MES_EPT_7620
FROM REC_DIS_NOTE NOTE
Inner Join REC_APPT_MES MES on NOTE.PK_1=MES.PK_1 
ORDER BY NOTE.EPT_1 ASC


