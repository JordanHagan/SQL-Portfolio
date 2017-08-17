Select
PATIENT.PAT_MRN_ID,
ORDER_PROC.PROC_CODE,
ORDER_PROC.DESCRIPTION as PROC_DESC,
DX.DX_NAME,
DX.CURRENT_ICD9_LIST, 
DX.CODE_LIST as HX_ICD9_LIST,
DX.CODE as V_HX_ICD9_LIST,
ORDER_PROC.ABNORMAL_YN
From ORDER_PROC 
Inner Join ORDER_DX_PROC on ORDER_DX_PROC.ORDER_PROC_ID=ORDER_PROC.ORDER_PROC_ID
Inner Join (Select CLARITY_EDG.DX_ID, DX_NAME, CODE_LIST, EFF_END_DATE, EFF_START_DATE, V_EDG_HX_ICD9.CODE, CLARITY_EDG.CURRENT_ICD9_LIST
					From CLARITY_EDG 
					Left Join EDG_HX_ICD9_LIST on CLARITY_EDG.DX_ID=EDG_HX_ICD9_LIST.DX_ID --The select statement pulls the list of ICD-9 values from the EDG_HX_ICD9_LIST table.  In order to get the discrete list of ICD-9 codes an additional join to the V_EDG_HX_ICD9 would be necessary
					Left Join V_EDG_HX_ICD9 on CLARITY_EDG.DX_ID=V_EDG_HX_ICD9.DX_ID) as DX --Join CLARITY_EDG to EDG_HX_ICD9_LIST to get the Historical ICD-9 code.
		on DX.DX_ID=ORDER_DX_PROC.DX_ID
Inner Join PATIENT on ORDER_PROC.PAT_ID=PATIENT.PAT_ID
Where ORDER_PROC.ABNORMAL_YN='Y'
and (ORDER_PROC.ORDERING_DATE <= DX.EFF_END_DATE
		and ORDER_PROC.ORDERING_DATE >= DX.EFF_START_DATE) --This segment of the conditional statement looks for the Historical ICD-9 value at the contact date of the encounter.
		