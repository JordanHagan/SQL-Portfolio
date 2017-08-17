		Select Distinct 
		PATIENT.PAT_MRN_ID,
		ENC.PAT_ENC_CSN_ID,
		ENC.ENC_TYPE_TITLE,
		ENC.CONTACT_DATE,
		OB.OB_HX_OUTCOME_DT, 
		OB.OB_HX_GEST_AGE, 
		ENC.BMI,
		ENC.WEIGHT/16,
		ENC.HEIGHT,
		ENC3.OB_TOTAL_WT_GAIN/16 as OB_TOTAL_WEIGHT_GAIN
		From PAT_ENC ENC 
		Left Join PAT_ENC_3 ENC3 on ENC.PAT_ENC_CSN_ID=ENC3.PAT_ENC_CSN
		Left Join PATIENT on ENC.PAT_ID=PATIENT.PAT_ID
		Left Join OB_HISTORY OB on ENC.PAT_ID=OB.PAT_ID
		Inner Join (Select Distinct 
							PAT_ENC.PAT_ID,
							MAX(PAT_ENC.CONTACT_DATE) as MAX_ENC_DATE
							From PAT_ENC 
							Left Join PAT_ENC_3 on PAT_ENC.PAT_ENC_CSN_ID=PAT_ENC_3.PAT_ENC_CSN
							Left Join PATIENT on PAT_ENC.PAT_ID=PATIENT.PAT_ID
							Left Join OB_HISTORY OB on PAT_ENC.PAT_ID=OB.PAT_ID
							Where 
							PAT_ENC.CONTACT_DATE >= CURRENT_DATE-700 --Encounters in the last 700 days
							And PAT_ENC.CONTACT_DATE < CURRENT_DATE --Encounters before today
							And OB_HX_OUTCOME_DT > CURRENT_DATE-365 --OB Outcome Date in the last year
							And OB_HX_OUTCOME_DT > PAT_ENC.CONTACT_DATE --Encounter Date is less than the Outcome Date
							And OB_HX_OUTCOME_DT is not null --Patient had a baby
							And OB_TOTAL_WT_GAIN is not null --Weight Gain Recorded
							And PAT_ENC.PAT_ID  not in (Select Distinct PAT_ID From PATIENT_TYPE Where PATIENT_TYPE_C='1214') --Test Patient Elimination
							And PAT_ENC.ENC_TYPE_TITLE in any ('OFFICE VISIT','HOSPITAL ENCOUNTER','OB OFFICE VISIT','PROCEDURE ONLY') --Visit Type
							Group By 1
							) as PAT_MAX_WEIGHT on ENC.PAT_ID=PAT_MAX_WEIGHT.PAT_ID
							And ENC.CONTACT_DATE=PAT_MAX_WEIGHT.MAX_ENC_DATE
		Where 
		ENC.CONTACT_DATE >= CURRENT_DATE-700 --Encounters in the last 700 days
		And ENC.CONTACT_DATE < CURRENT_DATE --Encounters before today
		And OB_HX_OUTCOME_DT > CURRENT_DATE-365 --OB Outcome Date in the last year
		And OB_HX_OUTCOME_DT > ENC.CONTACT_DATE --Encounter Date is less than the Outcome Date
		And OB_HX_OUTCOME_DT is not null --Patient had a baby
		And OB_TOTAL_WEIGHT_GAIN is not null --Weight Gain Recorded
		And ENC.PAT_ID  not in (Select Distinct PAT_ID From PATIENT_TYPE Where PATIENT_TYPE_C='1214') --Test Patient Elimination
		And ENC_TYPE_TITLE in any ('OFFICE VISIT','HOSPITAL ENCOUNTER','OB OFFICE VISIT','PROCEDURE ONLY') --Visit Type
		-------
		UNION ALL 
		------
		Select Distinct 
		PATIENT.PAT_MRN_ID,
		ENC.PAT_ENC_CSN_ID,
		ENC.ENC_TYPE_TITLE,
		ENC.CONTACT_DATE,
		OB.OB_HX_OUTCOME_DT, 
		OB.OB_HX_GEST_AGE, 
		ENC.BMI,
		ENC.WEIGHT/16,
		ENC.HEIGHT,
		ENC3.OB_TOTAL_WT_GAIN/16 as OB_TOTAL_WEIGHT_GAIN
		From PAT_ENC ENC 
		Left Join PAT_ENC_3 ENC3 on ENC.PAT_ENC_CSN_ID=ENC3.PAT_ENC_CSN
		Left Join PATIENT on ENC.PAT_ID=PATIENT.PAT_ID
		Left Join OB_HISTORY OB on ENC.PAT_ID=OB.PAT_ID
		Inner Join (Select Distinct 
							PAT_ENC.PAT_ID,
							MIN(PAT_ENC.CONTACT_DATE) as MAX_ENC_DATE
							From PAT_ENC 
							Left Join PAT_ENC_3 on PAT_ENC.PAT_ENC_CSN_ID=PAT_ENC_3.PAT_ENC_CSN
							Left Join PATIENT on PAT_ENC.PAT_ID=PATIENT.PAT_ID
							Left Join OB_HISTORY OB on PAT_ENC.PAT_ID=OB.PAT_ID
							Where 
							PAT_ENC.CONTACT_DATE >= CURRENT_DATE-700 --Encounters in the last 700 days
							And PAT_ENC.CONTACT_DATE < CURRENT_DATE --Encounters before today
							And OB_HX_OUTCOME_DT > CURRENT_DATE-365 --OB Outcome Date in the last year
							And OB_HX_OUTCOME_DT > PAT_ENC.CONTACT_DATE --Encounter Date is less than the Outcome Date
							And OB_HX_OUTCOME_DT is not null --Patient had a baby
							And OB_TOTAL_WT_GAIN is not null --Weight Gain Recorded
							And PAT_ENC.PAT_ID  not in (Select Distinct PAT_ID From PATIENT_TYPE Where PATIENT_TYPE_C='1214') --Test Patient Elimination
							And PAT_ENC.ENC_TYPE_TITLE in any ('OFFICE VISIT','HOSPITAL ENCOUNTER','OB OFFICE VISIT','PROCEDURE ONLY') --Visit Type
							Group By 1
							) as PAT_MIN_WEIGHT on ENC.PAT_ID=PAT_MIN_WEIGHT.PAT_ID
							And ENC.CONTACT_DATE=PAT_MIN_WEIGHT.MAX_ENC_DATE
		Where 
		ENC.CONTACT_DATE >= CURRENT_DATE-700 --Encounters in the last 700 days
		And ENC.CONTACT_DATE < CURRENT_DATE --Encounters before today
		And OB_HX_OUTCOME_DT > CURRENT_DATE-365 --OB Outcome Date in the last year
		And OB_HX_OUTCOME_DT > ENC.CONTACT_DATE --Encounter Date is less than the Outcome Date
		And OB_HX_OUTCOME_DT is not null --Patient had a baby
		And OB_TOTAL_WEIGHT_GAIN is not null --Weight Gain Recorded
		And ENC.PAT_ID  not in (Select Distinct PAT_ID From PATIENT_TYPE Where PATIENT_TYPE_C='1214') --Test Patient Elimination
		And ENC_TYPE_TITLE in any ('OFFICE VISIT','HOSPITAL ENCOUNTER','OB OFFICE VISIT','PROCEDURE ONLY') --Visit Type








