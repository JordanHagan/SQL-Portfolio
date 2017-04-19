Select Distinct
ob_patients.pat_id,
ob_patients.pat_name,
ob_patients.pat_mrn,
ob_patients.expected_delivery_date,
ob_patients.outcome_date,
ob_patients.gestational_age,
procs_ordered.proc_date, 
procs_ordered.RESULT_DATE,
procs_ordered.proc_code,
procs_ordered.proc_description,
procs_ordered.ORD_VALUE,
procs_ordered.proc_status,
procs_ordered.LOC_NAME
/*CONTACT_DATE as dx_noted_date,
DX_NAME*/
from
		(
		select distinct
		t1.pat_id as pat_id,
		t1.pat_name as pat_name,
		t1.pat_mrn_id as pat_mrn,
		t1.edd_dt as expected_delivery_date,
		t2.ob_hx_outcome_dt as outcome_date,
		t2.ob_hx_gest_age as gestational_age
		from
		patient t1 join 
		ob_history t2 on (t1.pat_id = t2.pat_id)
		where
		t1.edd_dt is null and
		t2.ob_hx_outcome_dt > add_months(current_date,-50)
		union all
		select distinct
		t1.pat_id,
		t1.pat_name,
		t1.pat_mrn_id,
		t1.edd_dt as expected_delivery_date,
		null as outcome_date,
		trim(cast((280 + (current_date - t1.edd_dt))/7 as int)) || 'w ' || trim((280 + (current_date - t1.edd_dt)) - (7*cast((280 + (current_date - t1.edd_dt))/7 as int))) || 'd' as gestational_age 
		from
		patient t1
		where
		t1.edd_dt >= current_date
		) 
ob_patients left outer join
		(
		select
		t1.ordering_date as proc_date, 
		t1.pat_id,
		t1.proc_code as proc_code,
		t1.description as proc_description,
		t2.name as proc_status,
		RES.RESULT_DATE, 
		RES.ORD_VALUE,
		LOC_NAME
		from 
		order_proc t1 join 
		zc_order_status t2 on (t1.order_status_c = t2.order_status_c) 
		left join ORDER_RESULTS RES on t1.ORDER_PROC_ID=RES.ORDER_PROC_ID
		left join PAT_ENC ENC on t1.PAT_ENC_CSN_ID=ENC.PAT_ENC_CSN_ID
		inner join CLARITY_DEP DEP on ENC.DEPARTMENT_ID=DEP.DEPARTMENT_ID
		Inner Join CLARITY_LOC LOC on DEP.REV_LOC_ID=LOC.LOC_ID
		where 
			(t1.description like '%HEMOGLOBIN%' or t1.description like '%GLUCOSE%') and 
			t1.order_status_c in any ('1','2','5') and --ORDER STATUS
			t1.ordering_date >= add_months(current_date,-50)
			)
		procs_ordered on (ob_patients.pat_id = procs_ordered.pat_id and procs_ordered.proc_date >= add_months(current_date,-50))
Inner Join (Select Distinct PAT_ID, CONTACT_DATE,DX_NAME
		From PAT_ENC_DX DX
		Inner Join KPBICO.EDG_HX_MASTER MASTER on MASTER.DX_ID=DX.DX_ID
		Where DX_NAME like any ('GESTATIONAL DM%','%HISTORY OF GESTATIONAL DIABETES MELLITUS%','%HX OF GESTATIONAL DM%')
		And CONTACT_DATE <= EFF_END_DATE
		And CONTACT_DATE >= EFF_START_DATE --ENCOUNTER DIAGNOSIS
		---
		UNION ALL
		---
		Select Distinct  PAT_ID, NOTED_DATE as CONTACT_DATE,  DX_NAME
		From PROBLEM_LIST
		Inner Join KPBICO.EDG_HX_MASTER on PROBLEM_LIST.DX_ID=EDG_HX_MASTER.DX_ID
		Where EDG_HX_MASTER.DX_NAME like any ('GESTATIONAL DM%','%HISTORY OF GESTATIONAL DIABETES MELLITUS%','%HX OF GESTATIONAL DM%')
		And DATE_OF_ENTRY <= EFF_END_DATE
		And DATE_OF_ENTRY >= EFF_START_DATE --PROBLEM LIST DIAGNOSIS
) as DM_DX on ob_patients.PAT_ID=DM_DX.PAT_ID 
and (DM_DX.CONTACT_DATE between ob_patients.outcome_date-275 and ob_patients.outcome_date or DM_DX.CONTACT_DATE between ob_patients.expected_delivery_date-275 and ob_patients.expected_delivery_date)
/*Where proc_date>outcome_date ONLY TEST DONE AFTER DELIVERY */
order by 1,7
