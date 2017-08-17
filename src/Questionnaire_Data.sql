--MY CHART  PATIENTS

Select distinct QFQ.FORM_ID, 
QQ.Quest_ID, 
QQ.QUEST_NAME, 
QOVTM.QUESTION, 
QOVTM.Contact_Date, 
PAT.PAT_MRN_ID, 
PAT.Pat_Name, 
PAT.Quest_Answer,
PAT.CONTACT_DATE
From CL_QQUEST QQ 
Left Outer Join CL_QQUEST_OVTM QOVTM on QOVTM.Quest_ID=QQ.Quest_ID
Left Outer Join CL_QFORM_QUEST QFQ on QFQ.Quest_ID=QQ.Quest_ID
Left Outer Join CL_QQUEST_RESP QR on  QQ.Quest_ID=QR.Quest_ID
Left Outer Join CL_QQUEST_QFRESP QF on QF.Question_ID=QQ.Quest_ID
Inner Join (Select PAT_ENC_QUESR.CONTACT_DATE, PATIENT.Pat_ID, PATIENT.Pat_Name, PATIENT.Birth_Date, PATIENT.Sex, PATIENT.PAT_MRN_ID, PAT_ENC_QUESR.QUEST_ID, PAT_ENC_QUESR.QUEST_DATE, PAT_ENC_QUESR.Quest_Answer
     From PATIENT 
     Inner Join PAT_ENC_QUESR
     on PAT_ENC_QUESR.PAT_ID=PATIENT.PAT_ID) as PAT
   on PAT.QUEST_ID=QQ.QUEST_ID
Where QFQ.FORM_ID='14076'
And QQ.QUEST_ID='1403923'
And QOVTM.Contact_Date=(Select Max(Contact_Date) as Contact_Date
            From CL_QQUEST_OVTM OVTM
            Where OVTM.Quest_ID=QOVTM.Quest_ID)
Group By (1,2,3,4,5,6,7,8,9,10)
Order By PAT_MRN_ID, QQ.QUEST_ID;

