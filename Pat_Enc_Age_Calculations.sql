SELECT 
pat_enc.pat_id
,pat_enc.pat_enc_csn_id
,pat_enc.contact_date
,patient.birth_date
,age as AGE_IN_PAT_ENC
,CASE When ((BIRTH_DATE (DATE))(INT)) > ((PAT_ENC.CONTACT_DATE (INT)) - '20000') Then (((((PAT_ENC.CONTACT_DATE (INT)) - (((BIRTH_DATE (DATE))(INT))))) *.0001)) Else 
((EXTRACT(YEAR FROM pat_enc.contact_date) - EXTRACT(YEAR FROM patient.birth_date) (NAMED years)) + CASE WHEN ADD_MONTHS(pat_enc.contact_date, - years * 12 ) < patient.birth_date 
THEN -1 ELSE 0 END) END as AGE_AT_CONTACT_DATE_W_DEC 
,(EXTRACT(YEAR FROM pat_enc.contact_date) - EXTRACT(YEAR FROM patient.birth_date) (NAMED years)) + CASE WHEN ADD_MONTHS(pat_enc.contact_date, - years * 12 ) < patient.birth_date 
THEN -1 ELSE 0 END AS AGE_AT_CONTACT_DATE_WO_DEC -- Calculate age in relation to contact_date 
,CAST((((((CURRENT_DATE (INT)) - (((BIRTH_DATE (DATE))(INT))))) *.0001)) AS SMALLINT) AS "CUR_AGE_WO_DEC" --Calculate age in relation to current date (Not Rounded) no decimal

FROM pat_enc
LEFT JOIN patient 
ON pat_enc.pat_id = patient.pat_id
WHERE AGE_CALC between '0' and '4'
