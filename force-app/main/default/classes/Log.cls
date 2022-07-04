public without sharing class Log {

    /**
     * @description Method for raising request for exception insertiong flow
     * @param  exception Expected Exception object instance for calculating extra details
     */
    public static void logException(Exception ex){
        System.debug(LoggingLevel.ERROR, 'logException');
    }
    /**
     * @description Method raises platform event to the bus/channel
     * @return   returns true if event raised succesfully
     */
    public Boolean raisePlatformEvent(){
        System.debug(LoggingLevel.ERROR, 'raisePlatformEvent');
        return true;        
    }
    /**
     * @description Calculates current scope governance limits used
     * @return   returns various limits details as wrapper object 
     */
    public GovernanceLimitsWrapper calculateGovernanceLimits(){
        GovernanceLimitsWrapper wrapper = new GovernanceLimitsWrapper();
        return wrapper;
    }
    /**
     * @description method takes wrapper and formats it separately. 
     * This method is separated for SOC.
     * @param  wrapper Accepts GovernanceLimitsWrapper instance
     * @return         returns formatted string. To be inserted to DB
     */
    public string formatGovernanceLimits(GovernanceLimitsWrapper wrapper){

        System.debug(LoggingLevel.ERROR, 'formatGovernanceLimits');
        return 'test';
    }
    /**
     * @description Method determines if all the framework code is to be used
     * @return   returns true if it is enabled
     */
    public Boolean isLoggingEnabled(){
        //This check depends on metadata record created. Need to add logic for determining if it is to be enabled.
        return true;
    }
    /**
     * @description This method will create and fill in data in custom exception object. 
     * @param  ex Exception instance to be handled.
     * @return    returns literal Exception_Log__c object.
     */
    public Exception_Log__c handleInboundException(Exception ex){
        Exception_Log__c exObject = new Exception_Log__c();
        return exObject;
    }
    /**
     * @description This methode will extract stack trace from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Stack Trace.
     */
    private String getStackTrace(Exception ex)
    {
        return ex?.getStackTraceString();
    }
    /**
     * @descriptionThis methode will extract class name from exception instance. 
     * @param  ex Exception instance.
     * @return    returns class name.
     */
    private String getClassName(Exception ex){
        return   ex.getStackTraceString()?.substringBefore('\n').substringAfter('.')?.substringBefore('.');
    }
    /**
     * @descriptionThis methode will extract methode name from exception instance. 
     * @param  ex Exception instance.
     * @return    returns methode name.
     * */
    private String getMethodeName(Exception ex){
        return  ex.getStackTraceString()?.substringBefore('\n').substringBefore(':')?.substringAfter(className)?.substringAfter('.');
    }
    /**
     * @descriptionThis methode will extract Exception type from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Exception type. 
     */
    private String getExceptionTypeName(Exception ex){
        return  ex.getTypeName()?.substringAfter('.');
    }
    /**
     * @descriptionThis methode will extract Exception message from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Exception message.
     */
    private String getExceptionMessage(Exception ex){
        return  ex.getMessage();
    }
    /**
    * @descriptionThis methode will extract Line number of file where exception instance created. 
     * @param  ex Exception instance.
     * @return    returns Line number of Exception oaccur file.
     */
    private String getLinenumber(Exception ex){
        return  ex.getLineNumber();
    }
    /**
    * @descriptionThis methode will extract Query limits and other limits from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Limits details.
     */
    private String getQueryLimit(Exception ex){
        return   '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries() + '\n'+'2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows() +'\n' + '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements() + '\n' +'4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime() ;
    }

     /**
    * @descriptionThis methode will extract Query limits and other limits from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Additional details.
     */
    private String getAdditionalInfo(Exception ex){
        String exceptionTypeName =getExceptionTypeName(ex);
        String additionalDetails = '';           
        if(String.isNotBlank(exceptionTypeName) && exceptionTypeName.equalsIgnoreCase('DMLException'))
        {
            additionalDetails = ExceptionEventTriggerHandler.getDMLData((DMLException)e);
           
        }
        if(String.isNotBlank(exceptionTypeName) && exceptionTypeName.equalsIgnoreCase('QueryException'))
        {
           //Commenting temporary 
            additionalDetails += getQueryData((QueryException)e);
        }
        return additionalDetails;
    }
    /**
     * Purpose : To export DMLException causing field
     */
    private static string getDMLData(Exception eRecord)
    {
        Integer filedCount = eRecord.getNumDml();
        String DMLdetails = '';
        for(Integer i=0;i<filedCount;i++)
        {
            DMLdetails =eRecord.getDmlId(i) +'\t'+eRecord.getDmlFieldNames(i)+'\t'+eRecord.getDmlMessage(i) +'\t'+eRecord.getDmltype(i)+'\n';
        }
        return DMLdetails;
    }
    /**
     * Purpose : To export QueryException causing field
     */
    private static string getQueryData(QueryException eRecord)
    {
        String inaccessinleFieldWithApiName ='';
        Map<String, Set<String>> inaccessibleFields = eRecord.getInaccessibleFields();
        for(String ObkectApi :inaccessibleFields.keySet() )
        {
            inaccessinleFieldWithApiName += ObkectApi +'\t'+ inaccessibleFields.get(ObkectApi)+'\n';
        }
        return inaccessinleFieldWithApiName;
    } 
    
}
