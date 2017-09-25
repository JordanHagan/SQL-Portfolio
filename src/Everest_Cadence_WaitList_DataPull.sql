/*CREATE VOLATILE TABLES*/
------------------------------------------------------------------------------------------------------
--------------------- CREATE VT_DIS_NOTE TABLE---------------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE VT_DIS_NOTE AS (
	SELECT X.*,
	ROW_NUMBER() OVER (PARTITION BY PK ORDER BY PAT_ENC_CSN_ID) AS RN		
	FROM (SELECT Distinct 
		TRIM(WTL.PAT_ENC_CSN_ID) || TRIM(WTL_DP.LINE) as PK, 
		WTL.PAT_ENC_CSN_ID,
		WTL.PAT_ID as EPT_CID,
		EPT_MAP.INTERNAL_ID as EPT_DotOne,
		ZCWTL.NAME as WL_STATUS_EPT_7255,
		WTL.WT_PREF_TIMES as WT_PREF_DATE_EPT_7295,
		PRC.PRC_NAME as VISIT_TYPE_EPT_7280,
		WTL_DP.LINE as PROV_DEP_LINE_NUM,
		SER.PROV_NAME as WT_PROV_NAME_EPT_7265,
		DEP.DEPARTMENT_NAME as WT_DEP_NAME_EPT_7260,
		WTL_NT.WAIT_DISPLAY_NOTE as WT_DISPLY_NOTE_EPT_7296,
		' ' as APPT_MES_EPT_7620
		FROM 
		PAT_ENC_WT_LST  WTL
		INNER JOIN EPT_MAP on WTL.PAT_ID=EPT_MAP.CID 
		LEFT JOIN ZC_WAIT_STATUS ZCWTL on WTL.WAIT_STATUS_C=ZCWTL.WAIT_STATUS_C
		LEFT JOIN CLARITY_PRC PRC on WTL.PRC_ID=PRC.PRC_ID
		LEFT JOIN PAT_ENC_WT_LST_DP WTL_DP on WTL.PAT_ENC_CSN_ID=WTL_DP.PAT_ENC_CSN_ID
		LEFT JOIN PAT_ENC_WT_LST_NT WTL_NT on WTL.PAT_ENC_CSN_ID=WTL_NT.PAT_ENC_CSN_ID 
		LEFT JOIN CLARITY_SER SER on WTL_DP.PROV_ID=SER.PROV_ID
		INNER JOIN CLARITY_DEP DEP on WTL_DP.DEPARTMENT_ID=DEP.DEPARTMENT_ID
		LEFT JOIN PAT_ENC_APPT_MSG APPT on WTL.PAT_ENC_CSN_ID=APPT.PAT_ENC_CSN_ID
		WHERE 
		WTL.WAIT_STATUS_C='1' --Pending Status
		AND DEP.DEPARTMENT_NAME in any ('CARD FRNK', 'CARD RKCK', 'CARD SOUT')) as X ) 
With DATA Primary Index (PK) on Commit Preserve Rows;

------------------------------------------------------------------------------------------------------
--------------------- CREATE VT_APPT_MES TABLE---------------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE VT_APPT_MES AS (
	SELECT Y.*,
	ROW_NUMBER() OVER (PARTITION BY PK ORDER BY PAT_ENC_CSN_ID) AS RN		
	FROM(SELECT DISTINCT 
		TRIM(WTL.PAT_ENC_CSN_ID) || TRIM(WTL_DP.LINE) as PK, 
		WTL.PAT_ENC_CSN_ID,
		WTL.PAT_ID as EPT_CID,
		EPT_MAP.INTERNAL_ID as EPT_DotOne,
		ZCWTL.NAME as WL_STATUS_EPT_7255,
		WTL.WT_PREF_TIMES as WT_PREF_DATE_EPT_7295,
		PRC.PRC_NAME as VISIT_TYPE_EPT_7280,
		WTL_DP.LINE as PROV_DEP_LINE_NUM,
		SER.PROV_NAME as WT_PROV_NAME_EPT_7265,
		DEP.DEPARTMENT_NAME as WT_DEP_NAME_EPT_7260,
		' ' as WT_DISPLY_NOTE_EPT_7296,
		APPT.APPT_MESSAGE as APPT_MES_EPT_7620
		FROM 
		PAT_ENC_WT_LST  WTL
		INNER JOIN EPT_MAP on WTL.PAT_ID=EPT_MAP.CID 
		LEFT JOIN ZC_WAIT_STATUS ZCWTL on WTL.WAIT_STATUS_C=ZCWTL.WAIT_STATUS_C
		LEFT JOIN CLARITY_PRC PRC on WTL.PRC_ID=PRC.PRC_ID
		LEFT JOIN PAT_ENC_WT_LST_DP WTL_DP on WTL.PAT_ENC_CSN_ID=WTL_DP.PAT_ENC_CSN_ID
		LEFT JOIN PAT_ENC_WT_LST_NT WTL_NT on WTL.PAT_ENC_CSN_ID=WTL_NT.PAT_ENC_CSN_ID 
		LEFT JOIN CLARITY_SER SER on WTL_DP.PROV_ID=SER.PROV_ID
		LEFT JOIN CLARITY_DEP DEP on WTL_DP.DEPARTMENT_ID=DEP.DEPARTMENT_ID
		LEFT JOINn PAT_ENC_APPT_MSG APPT on WTL.PAT_ENC_CSN_ID=APPT.PAT_ENC_CSN_ID
		WHERE 
		WTL.WAIT_STATUS_C='1' --Pending Status
		AND DEP.DEPARTMENT_NAME in any ('CARD FRNK', 'CARD RKCK', 'CARD SOUT')) as Y )
With DATA Primary Index (PK) on Commit Preserve Rows;
---------------------------------------------------------------------------------------------------------------------------------------------
/*Test Temp Table, If Needed*/
--Select * From VT_APPT_MES;
--Select * From VT_DIS_NOTE;

/*Drop Temp Table, If Needed*/
--Drop Table VT_APPT_MES;
--Drop Table VT_DIS_NOTE;
----------------------------------------------------------------------------------------------------------------------------------------------

/*CREATE TEMP TABLES WITH THE RECURSIVE ROWS */
------------------------------------------------------------------------------------------------------
--------------------- CREATE REC_DIS_NOTE TABLE------------------------
------------------------------------------------------------------------------------------------------
CREATE VOLATILE TABLE REC_DIS_NOTE AS (
WITH RECURSIVE REC_TEST (
	PK_1,
	EPT_15,
	EPT_11,
	EPT_1,
	EPT_7255,
	EPT_7295,
	EPT_7280,
	DP_LINE_NUM,
	EPT_7265,
	EPT_7260,
	EPT_7296,
	EPT_7620,
	LVL) 
as (SELECT 
	PK,
	PAT_ENC_CSN_ID,
	EPT_CID,
	EPT_DotOne,
	WL_STATUS_EPT_7255,
	WT_PREF_DATE_EPT_7295,
	VISIT_TYPE_EPT_7280,
	PROV_DEP_LINE_NUM,
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	WT_DISPLY_NOTE_EPT_7296(VARCHAR(3000)),
	APPT_MES_EPT_7620 (VARCHAR(3000)),
	1
    FROM VT_DIS_NOTE
    WHERE RN = '1'
UNION ALL
    SELECT 
	PK,
	PAT_ENC_CSN_ID,
	EPT_CID,
	EPT_DotOne,
	WL_STATUS_EPT_7255,
	WT_PREF_DATE_EPT_7295,
	VISIT_TYPE_EPT_7280,
	PROV_DEP_LINE_NUM,
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	TRIM(WT_DISPLY_NOTE_EPT_7296) || ' ' || EPT_7296, 
	TRIM(APPT_MES_EPT_7620)  || ' ' || EPT_7260,
	LVL+1
    FROM VT_DIS_NOTE 
    INNER JOIN REC_TEST on PK = PK_1 and VT_DIS_NOTE.RN = REC_TEST.LVL+1)
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
	EPT_15,
	EPT_11,
	EPT_1,
	EPT_7255,
	EPT_7295,
	EPT_7280,
	DP_LINE_NUM,
	EPT_7265,
	EPT_7260,
	EPT_7296,
	EPT_7620,
	LVL) 
as (SELECT 
	PK,
	PAT_ENC_CSN_ID,
	EPT_CID,
	EPT_DotOne,
	WL_STATUS_EPT_7255,
	WT_PREF_DATE_EPT_7295,
	VISIT_TYPE_EPT_7280,
	PROV_DEP_LINE_NUM,
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	WT_DISPLY_NOTE_EPT_7296(VARCHAR(3000)),
	APPT_MES_EPT_7620 (VARCHAR(3000)),
	1
    FROM VT_APPT_MES
    WHERE RN = '1'
UNION ALL
    SELECT 
	PK,
	PAT_ENC_CSN_ID,
	EPT_CID,
	EPT_DotOne,
	WL_STATUS_EPT_7255,
	WT_PREF_DATE_EPT_7295,
	VISIT_TYPE_EPT_7280,
	PROV_DEP_LINE_NUM,
	WT_PROV_NAME_EPT_7265,
	WT_DEP_NAME_EPT_7260,
	TRIM(WT_DISPLY_NOTE_EPT_7296) || ' ' || EPT_7296, 
	TRIM(APPT_MES_EPT_7620)  || ' ' || EPT_7260,
	LVL+1
    FROM VT_APPT_MES 
    INNER JOIN REC_TEST on PK = PK_1 and VT_APPT_MES.RN = REC_TEST.LVL+1)
SELECT *
FROM REC_TEST
QUALIFY RANK() OVER(PARTITION BY PK_1 ORDER BY LVL DESC) = 1) 
With DATA Primary Index (PK_1) on Commit Preserve Rows;
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
	NOTE.EPT_7255,
	TRIM(NOTE.EPT_7295) || '/' || '01' as PREF_DATE_EPT_7295,
	NOTE.EPT_7280,
	NOTE.DP_LINE_NUM,
	NOTE.EPT_7265,
	NOTE.EPT_7260,
	CASE When MES.EPT_7296=' ' Then NOTE.EPT_7296 Else Null END as NOTE_EPT_7296,
	CASE When NOTE.EPT_7620=' ' Then MES.EPT_7620 Else Null END as MES_EPT_7620
FROM REC_DIS_NOTE NOTE
INNER JOIN REC_APPT_MES MES on NOTE.PK_1=MES.PK_1 
ORDER BY NOTE.EPT_1 ASC, NOTE.DP_LINE_NUM ASC
