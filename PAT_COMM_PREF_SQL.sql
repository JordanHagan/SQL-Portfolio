SELECT Distinct 
'P215C' as MEASURE_ID,
ENC.PAT_ID, 
PATIENT.PAT_MRN_ID,
ZC_PATIENT_STATUS.NAME as PATIENT_STATUS,
CLARITY_LOC.LOC_NAME as CUR_PRIM_CARE_LOC,
IDENTITY_ID_TYPE.ID_TYPE_NAME,	
ZC_COMM_PREF.NAME as COMM_PREF_CAT_LIST,
TRIM(PAT_PERM_CMTS.PERM_CMT) as PERM_CMT,
CASE When PATIENT_MYC.PAT_ID is null Then 'N' Else 'Y' END as ACTIVE_CHART,
CASE When MEM_COVERED_YN is null Then 'N' Else MEM_COVERED_YN END as CURRENT_MEMBER,
CASE 
	When TRIM(PERM_CMT) like '%Preferred method for non-urgent communication:  Phone' or TRIM(PERM_CMT) like '%Preferred method of communication:  Phone' 
		Or TRIM(PERM_CMT) like '%Preferred method for non-urgent communication: Phone' or TRIM(PERM_CMT) like '%Preferred method of communication: Phone'  
		Then 'PHONE'
	When TRIM(PERM_CMT) like '%Preferred method for non-urgent communication: YHR Email' or TRIM(PERM_CMT) like '%Preferred method of communication: YHR Email' 
		Or TRIM(PERM_CMT) like '%Preferred method for non-urgent communication:  YHR Email' or TRIM(PERM_CMT) like '%Preferred method of communication:  YHR Email' 
		Then 'EMAIL'
	When TRIM(PERM_CMT) like '%Preferred method of communication: Letter' or TRIM(PERM_CMT) like '%Preferred method for non-urgent communication: Letter' 
		Or TRIM(PERM_CMT) like '%Preferred method of communication:  Letter' or TRIM(PERM_CMT) like '%Preferred method for non-urgent communication:  Letter' 
		Then 'LETTER'
	Else 'WILDCARD' END as PERM_CMT_CLASS

FROM 
PAT_ENC ENC
Left Join PATIENT on ENC.PAT_ID=PATIENT.PAT_ID
Left Join CLARITY_LOC on PATIENT.CUR_PRIM_LOC_ID=CLARITY_LOC.LOC_ID
Left Join PAT_COMM_PREF on ENC.PAT_ID=PAT_COMM_PREF.PAT_ID
Left Join ZC_COMM_PREF on PAT_COMM_PREF.PAT_COMM_PREF_C =ZC_COMM_PREF.COMM_PREF_C
Left Join PAT_PERM_CMTS on ENC.PAT_ID=PAT_PERM_CMTS.PAT_ID
Left Join IDENTITY_ID on ENC.PAT_ID=IDENTITY_ID.PAT_ID
Left Join IDENTITY_ID_TYPE on IDENTITY_ID.IDENTITY_TYPE_ID = IDENTITY_ID_TYPE.ID_TYPE 	
Left Join PATIENT_MYC on ENC.PAT_ID=PATIENT_MYC.PAT_ID And PATIENT_MYC.MYCHART_STATUS_C='1'
--Left Join CLARITY_SER on PATIENT.CUR_PCP_PROV_ID=CLARITY_SER.PROV_ID				
Left Join ZC_PATIENT_STATUS on PATIENT.PAT_STATUS_C=ZC_PATIENT_STATUS.PATIENT_STATUS_C
Left Join (Select PAT_ID, MAX(LINE) as MAX_LINE
					From COVERAGE_MEM_LIST
					Group By 1) as CURRENT_MEM_INFO 
		On CURRENT_MEM_INFO.PAT_ID=ENC.PAT_ID
Left Join COVERAGE_MEM_LIST on CURRENT_MEM_INFO.PAT_ID=COVERAGE_MEM_LIST.PAT_ID 
		And CURRENT_MEM_INFO.MAX_LINE=COVERAGE_MEM_LIST.LINE 
		And MEM_EFF_FROM_DATE<= date '2014-06-18'
		And (MEM_EFF_TO_DATE is null or MEM_EFF_TO_DATE > date '2014-06-18')

WHERE
(PAT_PERM_CMTS.PERM_CMT like '%Preferred method for non-urgent communication:%'
or PAT_PERM_CMTS.PERM_CMT like '%Preferred method of communication:%')
And IDENTITY_ID_TYPE.ID_TYPE='12150100'
--And PERM_CMT_CLASS='WILDCARD'


