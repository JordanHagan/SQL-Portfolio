

--Query to find Wound Patients and Associated Documents
--If you uncomment the Where Statement in the Subselect it will return zero records because none of the have images associated to them

Select Distinct PAT.Pat_MRN_ID, A.Referral_ID, A.External_ID_Num as REFERRAL_ID, B.PX_ID, C.Proc_Name, C.Proc_Code, A.Entry_Date, DOC.DOC_RECV_TIME, DOC.NAME as Document_Name
  From REFERRAL A
  Left Outer Join REFERRAL_PX B 
  on A.Referral_ID=B.Referral_ID
  Left Outer Join Clarity_EAP C
  on B.PX_ID=C.Proc_ID
  Inner Join Patient PAT
  on A.PAT_ID=PAT.PAT_ID
  Inner Join (Select DOC_INFORMATION.DOC_PT_ID, ZC_DOC_INFO_TYPE.NAME, DOC_INFORMATION.DOC_RECV_TIME
					From DOC_INFORMATION
					Inner Join ZC_DOC_INFO_TYPE
					on DOC_INFORMATION.DOC_INFO_TYPE_C=ZC_DOC_INFO_TYPE.DOC_INFO_TYPE_C
					--Where ZC_DOC_INFO_TYPE.Name like '%IMAG%'
					) as DOC
	On DOC.DOC_PT_ID=PAT.PAT_ID
 Where C.Proc_Code='200256'
And A.Entry_Date between '10/01/2012' and '03/31/2013'
Order By 7 desc;


--Report to find scan documents that are images (the subselect above)

Select ZC_DOC_INFO_TYPE.DOC_INFO_TYPE_C, NAME, Doc_Information.*
from doc_information
inner join ZC_DOC_INFO_TYPE
on DOC_INFORMATION.DOC_INFO_TYPE_C=ZC_DOC_INFO_TYPE.DOC_INFO_TYPE_C
Where Name like '%IMAG%' 





--Dead Ends

Select *
from PAT_ENC_AN_GPH_IMG --All Null

Select *
from Scan_Image --All Null

Select ZC_IMAGE_LOCATION.IMAGE_LOCATION_C, IMAGE_AVAIL_DTTM,ZC_IMAGE_LOCATION.*
from Order_Proc_2
Inner Join ZC_IMAGE_LOCATION
on ZC_IMAGE_LOCATION.IMAGE_LOCATION_C=ZC_IMAGE_LOCATION.IMAGE_LOCATION_C
Where Order_Proc_2.Image_Location_C is not null  --Doesn't look relevant 

Select *
from OR_PROC_IMAGES
Where IMAGE_FILENAME is not null --All Null

Select *
from CL_REMIT
Where Image_Name is not null --Doesn't look relevant

Select *
from BF1_HSP_TX_IMAGING --tbl doesn't exists

Select Proc.Order_Proc_ID, Proc.Pat_ID, Proc.Description, ID.IMAGE_INSTANCE
from ORDER_PROC PROC
Inner Join ORDER_RAD_IMG_UID  ID
On PROC.Order_Proc_ID=ID.Order_Proc_ID
Where PROC_CODE='200256'


