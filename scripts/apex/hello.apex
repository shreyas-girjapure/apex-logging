//Anonymous Code for Raising Platform Event.

Exception_Log_Platform_Event__e event = new Exception_Log_Platform_Event__e(
    	Additional_Details__c='Additonal Details',
    	Class_Name__c = 'Class Shreyas',
    	Exception_Message__c ='Exception Message',
    	Exception_Stack__c='Exception Hello',
    	Exception_Type__c ='Exception Type',
    	Governance_Limits__c='Governance Limits',
    	Method_Name__c='Method Name',
    	Related_Record_Id__c='Related Record'
);
EventBus.publish(event);