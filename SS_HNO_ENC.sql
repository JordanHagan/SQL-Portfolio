Select Distinct 
CAST (PATIENT.PAT_MRN_ID as char(10)),
PAT_ENC.CONTACT_DATE, 
CL_PRL_SS.PROTOCOL_NAME,
EPT_SEL_SMARTSETS.SELECTED_SSET_ID,
PAT_ENC.PAT_ENC_CSN_ID,
PAT_ENC.ENC_TYPE_TITLE,
PAT_ENC.ENC_TYPE_C,
'DCT_MA' as EXTRACT_POP,
1 as PPS_touch,
CASE WHEN  extract (month from current_date) = 1
	      THEN cast(extract (year from current_date)-1 AS char(4)) || '12' 
           WHEN (extract( month from current_date)-1) between 1 and 9 
                    THEN cast(extract (year from current_date) AS char(4)) || '0' 
                             || cast((extract (month from current_date)-1) AS char(1))
 ELSE cast(extract (year from current_date)  AS char(4))               
           || cast((extract (month from current_date)-1)  AS char(2)) 
               END AS clndrmmsk

From PAT_ENC 
Left Join PATIENT on PAT_ENC.PAT_ID=PATIENT.PAT_ID 
Left Join PATIENT_TYPE on PATIENT.PAT_ID=PATIENT_TYPE.PAT_ID
Left Join EPT_SEL_SMARTSETS on PAT_ENC.PAT_ENC_CSN_ID=EPT_SEL_SMARTSETS.PAT_ENC_CSN_ID
Left Join CL_PRL_SS on EPT_SEL_SMARTSETS.SELECTED_SSET_ID=CL_PRL_SS.PROTOCOL_ID
Left Join HNO_INFO on PAT_ENC.PAT_ENC_CSN_ID=HNO_INFO.PAT_ENC_CSN_ID
Left Join HNO_NOTE_TEXT on HNO_INFO.NOTE_ID=HNO_NOTE_TEXT.NOTE_ID
Left Join CLARITY_EMP on HNO_INFO.CURRENT_AUTHOR_ID=CLARITY_EMP.USER_ID

Where
EPT_SEL_SMARTSETS.SELECTED_SSET_ID  =  1401751
And PAT_ENC.CONTACT_DATE BETWEEN add_months(current_date-extract(day from current_date)+1,-12) AND  current_date-extract(day from current_date)
And  CLARITY_EMP.PROV_ID  IS NULL  
And  (PATIENT_TYPE.PATIENT_TYPE_C   IS NULL  OR  PATIENT_TYPE.PATIENT_TYPE_C <> 1214  )
And  HNO_NOTE_TEXT.NOTE_TEXT  LIKE  '%Diabetes Care Team%'
