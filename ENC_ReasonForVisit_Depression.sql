SELECT Distinct
ENC.PAT_ID, 
ENC.CONTACT_DATE,
VISIT.ENC_REASON_NAME as REASON_FOR_VISIT,
ZCTYPE.NAME as ENC_TYPE,
EDG.DX_NAME, 
EDG.CODE as V_HX_ICD9_LIST,
ORD.ORDERING_DATE as MED_ORDER_DATE, 
MED.NAME as MED_NAME,
ZCDrug.NAME as MED_PHARM_CLASS

FROM 
PAT_ENC ENC
Left Join ZC_DISP_ENC_TYPE ZCType on ENC.ENC_TYPE_C=ZCType.DISP_ENC_TYPE_C
Inner Join PAT_ENC_DX DX on ENC.PAT_ENC_CSN_ID=DX.PAT_ENC_CSN_ID
Left Join PAT_ENC_RSN_VISIT VISIT on ENC.PAT_ENC_CSN_ID=VISIT.PAT_ENC_CSN_ID
Inner Join (Select CLARITY_EDG.DX_ID, DX_NAME, CODE_LIST, EFF_END_DATE, EFF_START_DATE, V_EDG_HX_ICD9.CODE, CLARITY_EDG.CURRENT_ICD9_LIST
					From CLARITY_EDG 
					Left Join EDG_HX_ICD9_LIST on CLARITY_EDG.DX_ID=EDG_HX_ICD9_LIST.DX_ID 
					Left Join V_EDG_HX_ICD9 on CLARITY_EDG.DX_ID=V_EDG_HX_ICD9.DX_ID) as EDG --makes sure that you bring in the EFF_START_DATE and EFF_END_DATE for the ICD-9 Codes to match up later
		on EDG.DX_ID=DX.DX_ID
Left Join ORDER_MED ORD on ENC.PAT_ENC_CSN_ID=ORD.PAT_ENC_CSN_ID
Left Join CLARITY_MEDICATION MED on MED.MEDICATION_ID=ORD.MEDICATION_ID
Inner Join ZC_PHARM_CLASS ZCDrug on MED.PHARM_CLASS_C=ZCDrug.PHARM_CLASS_C

WHERE
(ENC.CONTACT_DATE <= EDG.EFF_END_DATE
and ENC.CONTACT_DATE >= EDG.EFF_START_DATE) --make sure the ICD-9 codes apply to your date range
and DX_NAME like '%DEPRESSION%' --This is an example of limiting your results to Depression Diagnosises 
--and ENC.CONTACT_DATE > '01/14/2014'
and ZCDrug.NAME like '%ANTIDEPRESSANTS%' --This is an example of limiting your results to where the pharmacy class is = antidepressants.  I would suggest getting specific drug ID or names from the doctor and using that are limiting criteria instead
and VISIT.ENC_REASON_NAME like 'PHARMACY NEW MEMBER MED PROGRAM%' --Reason for Visit
