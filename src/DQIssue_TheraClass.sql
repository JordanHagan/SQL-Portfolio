
Select Z.Name as TheraClassName, M.Thera_Class_C, M.Name as MedicationName
From HCCLCO6.Clarity_Medication M
Inner Join HCCLCO6.ZC_Thera_Class Z
on M.Thera_Class_C=Z.Thera_Class_C
Where M.Name like 'HYDROXYCHLOROQUINE%'
or M.name like 'FLUCONAZOLE%'
or M.name like 'NYSTATIN%'
or M.name like 'ACYCLOVIR%'
Group by (1,2,3)
Order By (2);



Select Z.Name as TheraClassName, M.Thera_Class_C, M.Name as MedicationName
From HCCLCO6.Clarity_Medication M
Inner Join HCCLCO6.ZC_Thera_Class Z
on M.Thera_Class_C=Z.Thera_Class_C
Where M.Name like 'AMOXICILLIN%'
or M.name like 'AZITHROMYCIN%'
or M.name like 'CEPHALEXIN%'
or M.name like 'CEFAZOLIN%'
or M.name like 'CIPROFLOXACIN%'
or M.name like 'DICLOXACILLIN%'
Group by (1,2,3)
Order By (3);

Select*
from HCCLCO6.ZC_Thera_Class Z
Where Thera_Class_C=12020
or Thera_Class_C=12023; 

Select*
from HCCLCO6.ZC_Thera_Class Z
Where Name like '%INFECTIVE%'; 

	
	
	--AND	("CLARITY_MEDICATION"."THERA_CLASS_C"=12020 
---	OR	"CLARITY_MEDICATION"."THERA_CLASS_C"=12023)
	
	