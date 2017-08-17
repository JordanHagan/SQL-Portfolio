/*
REPROT: 102

Implant Log By Date
Medical Center:
Location:
Service:
Report Date Range:

Please Note** The "Cost" is the supplier costs 

*/
Select SR.Name as "Service", ORLOG.Surgery_Date  as "Date",  ST.Name as "Log Status", ORLOG.Room_ID as "Room", ORLOG.Log_Name as "Log Name",  ZCI.Name as "Manufacturer Name",  ID.Identity_ID as MRN, I.Implant_Name as "Implant Name",  PHY.PROV_NAME as "Surgeon/Service", DX.Dx_Name as "Postop Diagnosis", 
PROC.Proc_Name as "Procedure Name", LOGIMP.IMPLANT_ACTION_NAM as "Implant Action", LOGIMP.IMPLANT_NUM_USED as "Qty. Used", MA.Man_Pack_Price as "Cost per Unit", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost"
from OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join Identity_ID ID
on ORLOG.Pat_ID=ID.Pat_ID
Inner Join Clarity_SER PHY
on IMP.IMP_STAFF_ID=PHY.PROV_ID
Inner Join ZC_OR_STATUS ST
on ORLOG.STATUS_C=ST.STATUS_C
Left Outer Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_LOG_IMPLANTS LOGIMP
on ORLOG.Log_ID=LOGIMP.LOG_ID
Inner Join OR_LOG_POSTOP_DIAG POST
on POST.Log_ID=ORLOG.Log_ID
Inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=ORLOG.Service_C
Inner Join (Select clarity_edg.dx_id, dx_name, code_list,  eff_end_date,  eff_start_date 
					From clarity_edg
  					Left Outer Join edg_hx_icd9_list 
					on clarity_edg.dx_id=edg_hx_icd9_list.dx_id) as DX
	on DX.DX_ID=POST.POSTOP_DX_CODES_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=ORLOG.Log_ID			
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
And ORLOG.Surgery_Date <= dx.eff_end_date 
And ORLOG.Surgery_Date >= dx.eff_start_date
And LOGIMP.IMPLANT_ACTION_NAM = 'IMPLANTED'
Order By (6);



/*
REPORT: 104

Implant Manufacturers by Total Cost and Volume
Medical Center:
Location:
Date Range:
Service: All

The commented out area is where you can filter for certain  Implant Status'

Status_C is equal or does not equal

10-RECEIVED   
   
  20-IMPLANTED   
   
  30-EXPLANTED   
   
  40-LOANED   
   
  50-RETURNED   
   
  60-DESTROYED   
   
  70-RECALLED   
   
  80-WASTED   
   
  90-IMPLANTED - OUT OF SERVICE   

*/
Select ZCI.Name as "Implant Manufacturer", Count (ORLOG.LOG_ID) as "Total Volume"
from OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=ORLOG.Service_C
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
--and I.Status_C='20' 
Group By (1)
Order By "Total Volume" desc;



/*
REPORT  106

Top Ten Implants - Implant Manufactorers by Cost
Medical Center:
Date Range:

Please Note** The "Cost" is the supplier costs 

*/
Select Top 10 ZCI.Name as "Implant Manufacturer", Sum (MA.Man_Pack_Price) as "Total Cost"
from OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
Group By (1)
Order By "Total Cost" desc;



/* 
REPORT  107

Top Ten Implant Manufacturers By Volumne
Medical Center:
Date Range:

*/
Select Top 10 ZCI.Name as "Implant Manufacturer", Count (ORLOG.Pat_ID) as "Total Volume"
from OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
Group By (1)
Order By "Total Volume" desc;




/*
REPORT 108

Implant Cost and Usage by Service & Surgeon

Medical Center:
Date Range:
Service Area:

Assiming the MPN is the Supplier Number and that the cost is the Supplier Costs
*/

Select SR.Name as "Service", PHY.PROV_NAME as "Surgeon", ORLOG.Surgery_Date  as "Date", ORLOG.Log_Name as "Log Name",  ZCI.Name as "Manufacturer Name", DX.Dx_Name as "Postop Diagnosis", /*MPN*/  SP.LAST_SUPPLIER_NUM as "MPN",  I.Implant_Name as "Implant Name", 
 LOGIMP.IMPLANT_NUM_USED as "Qty. Used", LOGIMP.IMPLANT_ACTION_NAM as "Implant Action", MA.Man_Pack_Price as "Cost per Unit", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost"
from OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join Clarity_SER PHY
on IMP.IMP_STAFF_ID=PHY.PROV_ID
Left Outer Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_LOG_IMPLANTS LOGIMP
on ORLOG.Log_ID=LOGIMP.LOG_ID
Inner Join OR_LOG_POSTOP_DIAG POST
on POST.Log_ID=ORLOG.Log_ID
Inner Join OR_SPLY SP
on I.INVENTORY_ITEM_ID=SP.Supply_ID
Inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=ORLOG.Service_C
Inner Join (Select clarity_edg.dx_id, dx_name, code_list,  eff_end_date,  eff_start_date 
					From clarity_edg
  					Left Outer Join edg_hx_icd9_list 
					on clarity_edg.dx_id=edg_hx_icd9_list.dx_id) as DX
	on DX.DX_ID=POST.POSTOP_DX_CODES_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=ORLOG.Log_ID			
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
And ORLOG.Surgery_Date <= dx.eff_end_date 
And ORLOG.Surgery_Date >= dx.eff_start_date
And LOGIMP.IMPLANT_ACTION_NAM =any('IMPLANTED','WASTED')
Order By (1);

/*
REPORT 109

Case Cost by Patient
Medical Center
Date Range 

**NEEDS REVIEW/WORK

*/
Select ID.Identity_ID as "Patient/MRN", PHY.PROV_NAME as "Surgeon/Phy", PROC.Proc_Name as "Procedure Name", LOGS.Log_Name as "Log Name",  ST.Name as "Log Status", LOGS.Surgery_Date  as "Date",S.Supply_Name as "Material Name ", TY.Name as "Material Type", 
MA.Man_Pack_Price as "Cost per Unit", PK.Supplies_Used as "Qty. Used", ("Qty. Used"*"Cost per Unit") as "Total Cost"
From OR_SPLY S
Inner Join ZC_OR_TYPE_OF_ITEM TY
on S.TYPE_OF_ITEM_C=TY.TYPE_OF_ITEM_C
Left Outer Join OR_SPLY_MANFACTR MA
on S.Supply_ID=MA.Item_ID
Inner Join (Select OR_LOG.LOG_ID, OR_LOG.PAT_ID, OR_LOG.Log_Name, OR_LOG.Surgery_Date, OR_LOG.Status_c, OR_LOG_CDP.CDP_NAME_ID
					From OR_LOG
					Inner Join OR_LOG_CDP
					on OR_LOG.LOG_ID=OR_LOG_CDP.LOG_ID) as LOGS
		on S.SUPPLY_ID=LOGS.CDP_NAME_ID
Inner Join OR_PKLST_SUP_LIST PK
on S.Supply_ID=PK.Supply_ID
Inner Join ZC_OR_STATUS ST
on LOGS.STATUS_C=ST.STATUS_C
Inner Join OR_LOG_SURG_RSC SURG
on LOGS.LOG_ID=SURG.LOG_ID
Inner Join Clarity_SER PHY
on SURG.SRG_STF_RES_ID=PHY.PROV_ID
Inner Join Identity_ID ID
on LOGS.Pat_ID=ID.Pat_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=LOGS.Log_ID		
Where TY.Name  not like all ( '%IMPLANT%', '%DRUG%')
--And LOGS.Surgery_Date between '2012-01-01 00:00:00' and '2013-03-31 00:00:00'
and S.ACTIVE_YN='Y'
Order by (1);




/*
REPORT 110

Case Cost by Procedure

Medical Center:
Date Range:
Procedure:
Surgeon:

*/
Select PROC.Proc_Name as "Procedure Name", PHY.PROV_NAME as "Surgeon",  Count(ORLOG.PAT_ID) as "Log Count", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost", ("Total Cost"/"Log Count") as "Avg. Cost"
from OR_IMP I
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join Clarity_SER PHY
on IMP.IMP_STAFF_ID=PHY.PROV_ID
Left Outer Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_LOG_IMPLANTS LOGIMP
on ORLOG.Log_ID=LOGIMP.LOG_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=ORLOG.Log_ID			
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
And LOGIMP.IMPLANT_ACTION_NAM = 'IMPLANTED'
Order By (5) desc
Group By (1,2,4);




/*
REPORT 116

Case Cost by Service

Medical Center:
Date Range:
Service:
Surgeon:

*/
Select SR.Name as "Service",  PHY.PROV_NAME as "Surgeon", Count(ORLOG.PAT_ID) as "Log Count", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost", ("Total Cost"/"Log Count") as "Avg. Cost"
from OR_IMP I
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join Clarity_SER PHY
on IMP.IMP_STAFF_ID=PHY.PROV_ID
Left Outer Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_LOG_IMPLANTS LOGIMP
on ORLOG.Log_ID=LOGIMP.LOG_ID
Inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=ORLOG.Service_C	
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
And LOGIMP.IMPLANT_ACTION_NAM = 'IMPLANTED'
Order By (5) desc
Group By (1,2,4);



/*
REPORT 119

Log Supply REport by Supply Stpye and Total Spend

Medical Center:
Date Range:
Service:
Surgeon:

**NEEDS REVIEW and HELP

*/
Select LOGS.Log_Name as "Log Name",  ST.Name as "Log Status",  RN.PROV_NAME as "Circulating RN",  /*****as "Service"*/  PHY.PROV_NAME as "Surgeon", PROC.Proc_Name as "Procedure(s)", TY.Name as "Supply Type", S.Supply_Name as "Supply Name ", SPMAN.Name  as "Manufacturer", 
SPMAN.MAN_CTLG_NUM as "Model Number", /****as "TMS Number", */
PK.Supplies_Used as "Qty. Used", MA.Man_Pack_Price as "Cost per Unit", ("Qty. Used"*"Cost per Unit") as "Total Cost"
From OR_SPLY S
Inner Join (Select OR_SPLY_MANFACTR.ITEM_ID, ZC_OR_MANUFACTURER.NAME, OR_SPLY_MANFACTR.MAN_CTLG_NUM
					From  ZC_OR_MANUFACTURER
					Inner Join OR_SPLY_MANFACTR
					on ZC_OR_MANUFACTURER.MANUFACTURER_C=OR_SPLY_MANFACTR.MANUFACTURER_C) as SPMAN
	on SPMAN.ITEM_ID=S.Supply_ID
Inner Join ZC_OR_TYPE_OF_ITEM TY
on S.TYPE_OF_ITEM_C=TY.TYPE_OF_ITEM_C
Left Outer Join OR_SPLY_MANFACTR MA
on S.Supply_ID=MA.Item_ID
Inner Join (Select OR_LOG.LOG_ID, OR_LOG.PAT_ID, OR_LOG.Log_Name, OR_LOG.Surgery_Date, OR_LOG.Status_c, OR_LOG_CDP.CDP_NAME_ID
					From OR_LOG
					Inner Join OR_LOG_CDP
					on OR_LOG.LOG_ID=OR_LOG_CDP.LOG_ID) as LOGS
		on S.SUPPLY_ID=LOGS.CDP_NAME_ID
Inner Join OR_PKLST_SUP_LIST PK
on S.Supply_ID=PK.Supply_ID
Inner Join ZC_OR_STATUS ST
on LOGS.STATUS_C=ST.STATUS_C
Inner Join OR_LOG_SURG_RSC SURG
on LOGS.LOG_ID=SURG.LOG_ID
Inner Join Clarity_SER PHY
on SURG.SRG_STF_RES_ID=PHY.PROV_ID
Left Outer Join (Select OR_LOG_SURG_RSC.LOG_ID, OR_LOG_SURG_RSC.SRG_STF_RES_ID, CLARITY_SER.PROV_NAME, CLARITY_SER.PROV_TYPE
							From OR_LOG_SURG_RSC
							Inner Join Clarity_SER
							on OR_LOG_SURG_RSC.SRG_STF_RES_ID=Clarity_SER.PROV_ID
							Where Clarity_SER.Prov_Type='REGISTERED NURSE') as RN
					on RN.LOG_ID=LOGS.LOG_ID
Inner Join Identity_ID ID
on LOGS.Pat_ID=ID.Pat_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=LOGS.Log_ID		
Where TY.Name  not like all ( '%IMPLANT%', '%DRUG%')
--And LOGS.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
and S.ACTIVE_YN='Y'
Group by (1,2,3,4,5,6,7,8,9,10,11)
Order by (4);


/*
REPORT 120

Supply Cost for Similar Proecdure by Surgeron

Medical Center:
Date Range:
Procedure:
Surgeon:

*/
Select PROC.Proc_Name as "Procedure Name", PHY.PROV_NAME as "Surgeon",  Count(LOGS.LOG_ID) as "Log Count", Sum(MA.Man_Pack_Price) as "Total Cost", ("Log Count"/"Total Cost") as "Avg. Cost"
From OR_SPLY S
Left Outer Join OR_SPLY_MANFACTR MA
on S.Supply_ID=MA.Item_ID
Inner Join ZC_OR_TYPE_OF_ITEM TY
on S.TYPE_OF_ITEM_C=TY.TYPE_OF_ITEM_C
Inner Join (Select OR_LOG.LOG_ID, OR_LOG.PAT_ID, OR_LOG.Log_Name, OR_LOG.Surgery_Date, OR_LOG.Status_c, OR_LOG_CDP.CDP_NAME_ID
					From OR_LOG
					Inner Join OR_LOG_CDP
					on OR_LOG.LOG_ID=OR_LOG_CDP.LOG_ID) as LOGS
		on S.SUPPLY_ID=LOGS.CDP_NAME_ID
Inner Join OR_LOG_SURG_RSC SURG
on LOGS.LOG_ID=SURG.LOG_ID
Inner Join Clarity_SER PHY
on SURG.SRG_STF_RES_ID=PHY.PROV_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=LOGS.Log_ID		
Where TY.Name  not like all ( '%IMPLANT%', '%DRUG%')
--And LOGS.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
and S.ACTIVE_YN='Y'
Group by (1,2)
Order by (3) desc;


/*
REPORT 121a

Total Joints Hips and Knees Implants 

Medical Center:
Procedure:
Date Range:

*/
Select SP.LAST_SUPPLIER_NUM as "MPN", ID.Identity_ID as MRN, ORLOG.Log_Name as "Log Number", PROC.Proc_Name as "Work Type", PHY.PROV_NAME as "Surgeon/Service", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost", ORLOG.Surgery_Date  as "Date", ZCI.Name as "Manufacturer Name",
/*COMPONENTS*/  I.Implant_Name as "Description", LOGIMP.IMPLANT_NUM_USED as "Qty. Used", MA.Man_Pack_Price as "Cost per Item", DX.ICD9_CODE
from OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join Identity_ID ID
on ORLOG.Pat_ID=ID.Pat_ID
Inner Join OR_LOG_POSTOP_DIAG POST
on POST.Log_ID=ORLOG.Log_ID
Inner Join Clarity_SER PHY
on IMP.IMP_STAFF_ID=PHY.PROV_ID
Left Outer Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_LOG_IMPLANTS LOGIMP
on ORLOG.Log_ID=LOGIMP.LOG_ID
Inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=ORLOG.Service_C
Inner Join OR_SPLY SP
on I.INVENTORY_ITEM_ID=SP.Supply_ID
Inner Join (Select clarity_edg.dx_id, dx_name, code_list,  eff_end_date,  eff_start_date, ICD9_CODE 
     From clarity_edg
       Left Outer Join edg_hx_icd9_list 
     on clarity_edg.dx_id=edg_hx_icd9_list.dx_id) as DX
 on DX.DX_ID=POST.POSTOP_DX_CODES_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
     From OR_LOG_ALL_PROC
     Inner Join OR_PROC
     on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=ORLOG.Log_ID   
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
And ORLOG.Surgery_Date <= dx.eff_end_date 
And ORLOG.Surgery_Date >= dx.eff_start_date
---And LOGIMP.IMPLANT_ACTION_NAM = 'IMPLANTED'
Group By (1,2,3,4,5,7,8,9,10,11,12)
Order By (6);




/*
REPORT 132

Implant Log by Date

Medical Center:
Service:
Report Date Range:


*/
Select SR.Name as "Service", ORLOG.Surgery_Date  as "Date",  ST.Name as "Log Status", ORLOG.Room_ID as "Room", ORLOG.Log_Name as "Log Name", ID.Identity_ID as MRN,  I.Implant_Name as "Implant Name", PHY.PROV_NAME as "Surgeon/Service", DX.Dx_Name as "Postop Diagnosis", 
PROC.Proc_Name as "Procedure Name", LOGIMP.IMPLANT_ACTION_NAM as "Implant Action", LOGIMP.IMPLANT_NUM_USED as "Qty. Used", MA.Man_Pack_Price as "Cost per Unit", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost"
from OR_IMP I
Inner Join OR_IMP_IMPLANT  IMP
on IMP.Implant_ID=I.Implant_ID
Inner Join OR_LOG ORLOG
on IMP.IMPLANT_LOG_ID=ORLOG.LOG_ID
Inner Join Identity_ID ID
on ORLOG.Pat_ID=ID.Pat_ID
Left Outer Join Clarity_SER PHY
on IMP.IMP_STAFF_ID=PHY.PROV_ID
Inner Join ZC_OR_STATUS ST
on ORLOG.STATUS_C=ST.STATUS_C
Left Outer Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_LOG_IMPLANTS LOGIMP
on ORLOG.Log_ID=LOGIMP.LOG_ID
Inner Join OR_LOG_POSTOP_DIAG POST
on POST.Log_ID=ORLOG.Log_ID
Inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=ORLOG.Service_C
Inner Join (Select clarity_edg.dx_id, dx_name, code_list,  eff_end_date,  eff_start_date 
					From clarity_edg
  					Left Outer Join edg_hx_icd9_list 
					on clarity_edg.dx_id=edg_hx_icd9_list.dx_id) as DX
	on DX.DX_ID=POST.POSTOP_DX_CODES_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  on PROC.Log_ID=ORLOG.Log_ID			
Where ORLOG.Surgery_Date between '2013-03-01 00:00:00' and '2013-03-31 00:00:00'
And ORLOG.Surgery_Date <= dx.eff_end_date 
And ORLOG.Surgery_Date >= dx.eff_start_date
And LOGIMP.IMPLANT_ACTION_NAM = 'WASTED'
Order By (6);





--RANDOM REPORTS and HELP


--What cost is best?
Select  ZCI.Name, I.Charge_Code, SP.Cost_Per_Unit_OT, PK.Sup_Unit_Cost, SU.Supplier_Price, MA.Man_Pack_Price
From OR_IMP I
Inner Join ZC_OR_MANUFACTURER ZCI
on I.Manufacturer_C=ZCI.Manufacturer_C
Inner Join OR_PKLST_SUP_LIST PK
on I.INVENTORY_ITEM_ID=PK.SUPPLY_ID
Inner Join OR_SPLY_OVTM SP
on I.INVENTORY_ITEM_ID=SP.ITEM_ID
Inner Join OR_SPLY_SUPPLIER SU
on I.INVENTORY_ITEM_ID=SU.ITEM_ID
Inner Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Where SP.Effective_Date between '03/01/2013' and '03/30/2013';

Select SU.Supplier_Price, MA.Man_Pack_Price
From OR_IMP I
Inner Join OR_SPLY_MANFACTR MA
on I.INVENTORY_ITEM_ID=MA.Item_ID
Inner Join OR_SPLY_SUPPLIER SU
on I.INVENTORY_ITEM_ID=SU.ITEM_ID
Where MA.Man_Pack_Price<>SU.Supplier_Price



--Where to pull the supply cost from
Select S.Supply_Name, OT.Cost_Per_Unit_OT, SU.Supplier_Price
From OR_SPLY S
Inner Join OR_SPLY_OVTM OT
on OT.Item_ID=S.Supply_ID
Inner Join OR_SPLY_SUPPLIER SU
on S.Supply_ID=SU.ITEM_ID
Where OT.Cost_Per_Unit_OT is null
and SU.Supplier_Price is not null;

