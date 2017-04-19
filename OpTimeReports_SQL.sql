
/********************************/
/******Op Time Reports******/
/********************************/


/*
REPROT: 102  - Implant Log By Date
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Order By (6);



/*
REPORT: 104  --  Implant Manufacturers by Total Cost and Volume
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
--And I.Status_C='20' 
Group By (1)
Order By "Total Volume" desc;



/*
REPORT  106  --  Top Ten Implants - Implant Manufactorers by Cost
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
REPORT  107  --  Top Ten Implant Manufacturers By Volumne
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Group By (1)
Order By "Total Volume" desc;



/*
REPORT 108  --  Implant Cost and Usage by Service & Surgeon
*/
Select SR.Name as "Service", PHY.PROV_NAME as "Surgeon", ORLOG.Surgery_Date  as "Date", ORLOG.Log_Name as "Log Name",  ZCI.Name as "Manufacturer Name", DX.Dx_Name as "Postop Diagnosis", SP.LAST_SUPPLIER_NUM as "MPN",  I.Implant_Name as "Implant Name", 
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Order By (1);


/*
REPORT 109  --  Case Cost by Patient
*/
Select ID.Identity_ID as "Patient/MRN", PHY.PROV_NAME as "Surgeon/Phy", PROC.Proc_Name as "Procedure Name", LOGS.Log_Name as "Log Name",  ST.Name as "Log Status", LOGS.Surgery_Date  as "Date",S.Supply_Name as "Material Name ", TY.Name as "Material Type", 
MA.Man_Pack_Price as "Cost per Unit", MA.Supplies_Used as "Qty. Used", ("Qty. Used"*"Cost per Unit") as "Total Cost"
From OR_SPLY S
Inner Join (Select OR_LOG.LOG_ID, OR_LOG.PAT_ID, OR_LOG.Log_Name, OR_LOG.Surgery_Date, OR_LOG.Status_c, OR_LOG_CDP.CDP_NAME_ID
					From OR_LOG
					Inner Join OR_LOG_CDP
					on OR_LOG.LOG_ID=OR_LOG_CDP.LOG_ID
					Where OR_LOG.Surgery_Date between '2010-01-01 00:00:00' and '2013-03-31 00:00:00') as LOGS
		on S.SUPPLY_ID=LOGS.CDP_NAME_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  		on PROC.Log_ID=LOGS.Log_ID	
Inner Join (Select OR_SPLY_MANFACTR.Man_Pack_Price, OR_PKLST_SUP_LIST.Supplies_Used, OR_PKLST_SUP_LIST.Supply_ID
					From  OR_SPLY_MANFACTR 
					Inner Join OR_PKLST_SUP_LIST
					on OR_PKLST_SUP_LIST.Supply_ID=OR_SPLY_MANFACTR.Item_ID
					Where OR_PKLST_SUP_LIST.Supplies_Used is not null
					and OR_SPLY_MANFACTR.Man_Pack_Price is not null) as MA
		on MA.Supply_ID=S.Supply_ID
Inner Join ZC_OR_TYPE_OF_ITEM TY
on S.TYPE_OF_ITEM_C=TY.TYPE_OF_ITEM_C
Inner Join ZC_OR_STATUS ST
on LOGS.STATUS_C=ST.STATUS_C
Inner Join (Select LOG_ID, PROV_NAME, PROV_ID, PROV_TYPE
	From OR_LOG_ALL_SURG 
	Inner Join CLARITY_SER
	On CLARITY_SER.PROV_ID=OR_LOG_ALL_SURG.SURG_ID) as PHY
on PHY.LOG_ID=LOGS.LOG_ID
Inner Join Identity_ID ID
on LOGS.Pat_ID=ID.Pat_ID
Where TY.Name  not like all ( '%IMPLANT%', '%DRUG%')
and PHY.Prov_Type = 'Physician'
and S.ACTIVE_YN='Y'
and LOGS.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Group By (1,2,3,4,5,6,7,8,9,10)
Order by (1);



/*
REPORT 110  --  Case Cost by Procedure
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Order By (5) desc
Group By (1,2,4);



/*
REPORT 116  --  Case Cost by Service
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Order By (5) desc
Group By (1,2,4);



/*
REPORT 119  --  Log Supply REport by Supply Stpye and Total Spend
*/
Select LOGS.Log_Name as "Log Name",  ST.Name as "Log Status",  RN.PROV_NAME as "Circulating RN", SR.Name as "Service", PHY.PROV_NAME as "Surgeon", PROC.Proc_Name as "Procedure(s)", TY.Name as "Supply Type", S.Supply_Name as "Supply Name ", SPMAN.Name  as "Manufacturer", 
SPMAN.MAN_CTLG_NUM as "Model Number", MA.Supplies_Used as "Qty. Used", MA.Man_Pack_Price as "Cost per Unit", ("Qty. Used"*"Cost per Unit") as "Total Cost"
From OR_SPLY S
Inner Join (Select OR_SPLY_MANFACTR.ITEM_ID, ZC_OR_MANUFACTURER.NAME, OR_SPLY_MANFACTR.MAN_CTLG_NUM
					From  ZC_OR_MANUFACTURER
					Inner Join OR_SPLY_MANFACTR
					on ZC_OR_MANUFACTURER.MANUFACTURER_C=OR_SPLY_MANFACTR.MANUFACTURER_C
					Where ZC_OR_MANUFACTURER.MANUFACTURER_C is not null)  as SPMAN
		on SPMAN.ITEM_ID=S.Supply_ID
Inner Join (Select OR_SPLY_MANFACTR.Man_Pack_Price, OR_PKLST_SUP_LIST.Supplies_Used, OR_PKLST_SUP_LIST.Supply_ID
					From  OR_SPLY_MANFACTR 
					Inner Join OR_PKLST_SUP_LIST
					on OR_PKLST_SUP_LIST.Supply_ID=OR_SPLY_MANFACTR.Item_ID
					Where OR_PKLST_SUP_LIST.Supplies_Used is not null
					and OR_SPLY_MANFACTR.Man_Pack_Price is not null) as MA
		on MA.Supply_ID=S.Supply_ID
Inner Join (Select OR_LOG.LOG_ID, OR_LOG.PAT_ID, OR_LOG.Log_Name, OR_LOG.Surgery_Date, OR_LOG.Status_c, OR_LOG.Service_C, OR_LOG_CDP.CDP_NAME_ID
					From OR_LOG
					Inner Join OR_LOG_CDP
					on OR_LOG.LOG_ID=OR_LOG_CDP.LOG_ID
					Where OR_LOG.Surgery_Date between '2010-01-01 00:00:00' and '2013-03-31 00:00:00') as LOGS
		on S.SUPPLY_ID=LOGS.CDP_NAME_ID
Left Outer Join (Select OR_LOG_ALL_SURG.LOG_ID, OR_LOG_ALL_SURG.SURG_ID, CLARITY_SER.PROV_NAME, CLARITY_SER.PROV_TYPE
					From OR_LOG_ALL_SURG
					Inner Join Clarity_SER
					on OR_LOG_ALL_SURG.SURG_ID=Clarity_SER.PROV_ID
					Where Clarity_SER.Prov_Type='REGISTERED NURSE') as RN
		on RN.LOG_ID=LOGS.LOG_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID
					Where OR_PROC.Proc_Name is not null) as PROC
  		on PROC.Log_ID=LOGS.Log_ID	
Inner Join (Select CLARITY_SER.Prov_Name, CLARITY_SER.Prov_Type, CLARITY_SER.Prov_ID, OR_LOG_ALL_SURG.Log_ID
					From Clarity_SER
					Inner Join OR_LOG_ALL_SURG
					on OR_LOG_ALL_SURG.SURG_ID=CLARITY_SER.Prov_ID
					Where CLARITY_SER.Prov_Type='Physician') as PHY
		on PHY.LOG_ID=LOGS.LOG_ID	
Inner Join Identity_ID ID
on LOGS.Pat_ID=ID.Pat_ID
Inner Join ZC_OR_STATUS ST
on LOGS.STATUS_C=ST.STATUS_C
Inner Join ZC_OR_TYPE_OF_ITEM TY
on S.TYPE_OF_ITEM_C=TY.TYPE_OF_ITEM_C
Inner join ZC_OR_SERVICE SR
on SR.SERVICE_C=LOGS.Service_C	
Where TY.Name  not like all ( '%IMPLANT%', '%DRUG%')
and S.ACTIVE_YN='Y'
and LOGS.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Group by (1,2,3,4,5,6,7,8,9,10,11,12)
Order by (4);




/*
REPORT 120  --  Supply Cost for Similar Proecdure by Surgeron
*/
Select PROC.Proc_Name as "Procedure Name", PHY.PROV_NAME as "Surgeon",  Count(LOGS.LOG_ID) as "Log Count", Sum(MA.Man_Pack_Price) as "Total Cost", ("Log Count"/"Total Cost") as "Avg. Cost"
From OR_SPLY S
Inner Join (Select OR_LOG.LOG_ID, OR_LOG.PAT_ID, OR_LOG.Log_Name, OR_LOG.Surgery_Date, OR_LOG.Status_c, OR_LOG_CDP.CDP_NAME_ID
					From OR_LOG
					Inner Join OR_LOG_CDP
					on OR_LOG.LOG_ID=OR_LOG_CDP.LOG_ID
					Where OR_LOG.Surgery_Date between '2010-03-01 00:00:00' and '2013-03-31 00:00:00') as LOGS
		on S.SUPPLY_ID=LOGS.CDP_NAME_ID
Inner Join (Select OR_PROC.Proc_Name, OR_LOG_ALL_PROC.Log_ID
					From OR_LOG_ALL_PROC
					Inner Join OR_PROC
					on OR_PROC.OR_PROC_ID=OR_LOG_ALL_PROC.OR_PROC_ID) as PROC
  		on PROC.Log_ID=LOGS.Log_ID
 Inner Join (Select LOG_ID, PROV_NAME, PROV_ID, PROV_TYPE
	From OR_LOG_ALL_SURG 
	Inner Join CLARITY_SER
	On CLARITY_SER.PROV_ID=OR_LOG_ALL_SURG.SURG_ID) as PHY
on PHY.LOG_ID=LOGS.LOG_ID
Left Outer Join OR_SPLY_MANFACTR MA
on S.Supply_ID=MA.Item_ID
Inner Join ZC_OR_TYPE_OF_ITEM TY
on S.TYPE_OF_ITEM_C=TY.TYPE_OF_ITEM_C
Where TY.Name  not like all ( '%IMPLANT%', '%DRUG%')
and S.ACTIVE_YN='Y'
and LOGS.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
and MA.Man_Pack_Price is not null
Group by (1,2)
Order by (3) desc;


/*
REPORT 121a  --  Total Joints Hips and Knees Implants 
*/
Select SP.LAST_SUPPLIER_NUM as "MPN", ID.Identity_ID as MRN, ORLOG.Log_Name as "Log Number", PROC.Proc_Name as "Work Type", PHY.PROV_NAME as "Surgeon/Service", (LOGIMP.IMPLANT_NUM_USED*MA.Man_Pack_Price) as "Total Cost", ORLOG.Surgery_Date  as "Date", ZCI.Name as "Manufacturer Name",
I.Implant_Name as "Description", LOGIMP.IMPLANT_NUM_USED as "Qty. Used", MA.Man_Pack_Price as "Cost per Item", DX.ICD9_CODE
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
---And LOGIMP.IMPLANT_ACTION_NAM = 'IMPLANTED'
Group By (1,2,3,4,5,7,8,9,10,11,12)
Order By (6);




/*
REPORT 132  --  Implant Log by Date
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
And ORLOG.Pat_ID not in (Select Pat_ID From Patient_Type Where Patient_Type_C=1214)
Order By (6);

