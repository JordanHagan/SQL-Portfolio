--Meaningful Use Diagnostic Service
Select 
ZC.NAME as  ENC_TYPE_NAME,
SER.PROV_NAME,
SER.PROV_SPECIALTY,
DEP.DEPARTMENT_NAME, 
DEP.SPECIALTY as DEP_SPCIALTY,
PRC.PRC_NAME as VISIT_TYPE,
COUNT(*)
From PAT_ENC
Inner Join (Select PROV_NAME, ZCSPEC.NAME as PROV_SPECIALTY, CLINICIAN_TITLE, SER.PROV_ID
					From CLARITY_SER SER 
					Inner Join CLARITY_SER_SPEC SPEC on SER.PROV_ID=SPEC.PROV_ID
					Inner Join ZC_SPECIALTY ZCSPEC on SPEC.SPECIALTY_C=ZCSPEC.SPECIALTY_C	
					Where LINE='1'				
					) as SER on PAT_ENC.VISIT_PROV_ID=SER.PROV_ID
Inner Join CLARITY_DEP DEP on PAT_ENC.DEPARTMENT_ID=DEP.DEPARTMENT_ID
Inner Join ZC_DISP_ENC_TYPE ZC on ZC.DISP_ENC_TYPE_C=PAT_ENC.ENC_TYPE_C
Inner Join CLARITY_PRC PRC on PAT_ENC.APPT_PRC_ID=PRC.PRC_ID
Where ZC.NAME = 'Diagnostic Services'
And PAT_ENC.CONTACT_DATE between date '2014-02-01' and date '2014-05-01'
And PRC.PRC_ID in any
('140234', --PPD READ
'140300', --BP GROUP
'140339', --BP NURSE
'140107', --VENTURE
'140857', --WORKSITE
'140909') --PREVENTION 
Order By PROV_NAME asc
Group By (1,2,3,4,5,6);



--REASON FOR VISIT
Select ENC_REASON_ID,
ENC_REASON_NAME,
SER.CLINICIAN_TITLE,
SER.PROV_SPECIALTY,
COUNT(*)
From PAT_ENC_RSN_VISIT RSN
Inner Join PAT_ENC on RSN.PAT_ENC_CSN_ID=PAT_ENC.PAT_ENC_CSN_ID
Inner Join (Select PROV_NAME, ZCSPEC.NAME as PROV_SPECIALTY, CLINICIAN_TITLE, SER.PROV_ID
					From CLARITY_SER SER 
					Inner Join CLARITY_SER_SPEC SPEC on SER.PROV_ID=SPEC.PROV_ID
					Inner Join ZC_SPECIALTY ZCSPEC on SPEC.SPECIALTY_C=ZCSPEC.SPECIALTY_C	
					Where LINE='1'				
					) as SER on PAT_ENC.VISIT_PROV_ID=SER.PROV_ID
Inner Join ZC_DISP_ENC_TYPE ZC on ZC.DISP_ENC_TYPE_C=PAT_ENC.ENC_TYPE_C
Where RSN.CM_CT_OWNER_ID='120140' --Colorado Region
And PAT_ENC.CONTACT_DATE between date '2012-04-01' and  CURRENT_DATE
And CLINICIAN_TITLE is not null
And ENC_REASON_ID is not null
And ZC.NAME in any ('Allergy Injection',
'Allied Health/Nurse Visit',
'ALLIED HEALTH/NURSE VISIT - MH/BH',
'Assisted Living',
'Assisted Living MHBH',
'Consultation',
'Consultation MHBH',
'Diagnostic Services',
'Education',
'Group Visit',
'GROUP VISIT - MH/BH',
'Home Visit',
'Hospice',
'Hospice MHBH',
'Immunization',
'Long Term Care',
'Long Term Care MHBH',
'Nursing Facility',
'OB Office Visit',
'Office Visit',
'OFFICE VISIT - MH/BH',
'Palliative Care',
'Procedure Only',
'Procedure Only MHBH',
'Skilled Nursing MHBH',
'Telemedicine',
'Visit Continuation')
Order By ENC_REASON_NAME ASC, CLINICIAN_TITLE ASC, PROV_SPECIALTY ASC
Group By (1,2,3,4)

