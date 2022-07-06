trigger ExceptionEventTrigger on Exception_Log_Platform_Event__e (after insert) {
    /**
     * Purpose : Below code is use to extract data from published event and store it into Exception object 
     */
   List<Exception_Log__c> exceptionListToInsert = new List<Exception_Log__c>();
   Exception_Log__c exceptionInstance = new Exception_Log__c();
   for(Exception_Log_Platform_Event__e exEvent : trigger.new)
   {
    //clear previous instance fields
    exceptionInstance.clear();
    exceptionInstance.Additional_Details__c =exEvent?.Additional_Details__c;
    exceptionInstance.Class_Name__c  =exEvent?.Class_Name__c;
    exceptionInstance.Exception_Message__c =exEvent?.Exception_Message__c;
    exceptionInstance.Exception_Stack__c =exEvent?.Exception_Stack__c;
    exceptionInstance.Exception_Type__c =exEvent?.Exception_Type__c;
    exceptionInstance.Governance_Limits__c =exEvent?.Governance_Limits__c;
    exceptionInstance.Method_Name__c =exEvent?.Method_Name__c;
    //Check for null stack trace
    if(String.isNotBlank(exceptionInstance.Exception_Stack__c)){
        exceptionListToInsert.add(exceptionInstance);
    }
   }
   
   //Insert Exceptions 
   Database.SaveResult[] srList = Database.insert(exceptionListToInsert, false);

    // Iterate through each returned result
    for (Database.SaveResult sr : srList) {
        if (!sr.isSuccess()) {
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
            }
        }
    }

}