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
    public static void raisePlatformEvent(Exception ex){
        Exception_Log_Platform_Event__e event = new Exception_Log_Platform_Event__e(
    	Additional_Details__c=getAdditionalInfo(ex),
    	Class_Name__c = getClassName(ex),
    	Exception_Message__c =getExceptionMessage(ex),
    	Exception_Stack__c=getStackTrace(ex),
    	Exception_Type__c =getExceptionTypeName(ex),
    	Governance_Limits__c=getQueryLimit(ex),
    	Method_Name__c=getMethodeName(ex),
    	Related_Record_Id__c=''
        );
        EventBus.publish(event);
        System.debug('raisePlatformEvent');       
    }
    /**
     * @description Calculates current scope governance limits used
     * @return   returns various limits details as wrapper object 
     */
    public static GovernanceLimitsWrapper calculateGovernanceLimits(){
        GovernanceLimitsWrapper wrapper = new GovernanceLimitsWrapper();
        return wrapper;
    }
    /**
     * @description method takes wrapper and formats it separately. 
     * This method is separated for SOC.
     * @param  wrapper Accepts GovernanceLimitsWrapper instance
     * @return         returns formatted string. To be inserted to DB
     */
    public static string formatGovernanceLimits(GovernanceLimitsWrapper wrapper){

        System.debug(LoggingLevel.ERROR, 'formatGovernanceLimits');
        return 'test';
    }
    /**
     * @description Method determines if all the framework code is to be used
     * @return   returns true if it is enabled
     */
    public static Boolean isLoggingEnabled(){
        //This check depends on metadata record created. Need to add logic for determining if it is to be enabled.
        return true;
    }
    /**
     * @description This method will create and fill in data in custom exception object. 
     * @param  ex Exception instance to be handled.
     * @return    returns literal Exception_Log__c object.
     */
    public static Exception_Log__c handleInboundException(Exception ex){
        Exception_Log__c exObject = new Exception_Log__c();
        return exObject;
    }
    /**
     * @description This methode will extract stack trace from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Stack Trace.
     */
    private static String getStackTrace(Exception ex)
    {
        return ex?.getStackTraceString();
    }
    /**
     * @descriptionThis methode will extract class name from exception instance. 
     * @param  ex Exception instance.
     * @return    returns class name.
     */
    private static String getClassName(Exception ex){
        return   ex.getStackTraceString()?.substringBefore('\n').substringAfter('.')?.substringBefore('.');
    }
    /**
     * @descriptionThis methode will extract methode name from exception instance. 
     * @param  ex Exception instance.
     * @return    returns methode name.
     * */
    private static String getMethodeName(Exception ex){
        String className = getClassName(ex);
        return  ex.getStackTraceString()?.substringBefore('\n').substringBefore(':')?.substringAfter(className)?.substringAfter('.');
    }
    /**
     * @descriptionThis methode will extract Exception type from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Exception type. 
     */
    private static String getExceptionTypeName(Exception ex){
        return  ex.getTypeName()?.substringAfter('.');
    }
    /**
     * @descriptionThis methode will extract Exception message from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Exception message.
     */
    private static String getExceptionMessage(Exception ex){
        return  ex.getMessage();
    }
    /**
    * @descriptionThis methode will extract Line number of file where exception instance created. 
     * @param  ex Exception instance.
     * @return    returns Line number of Exception oaccur file.
     */
    private static Integer getLinenumber(Exception ex){
        return  ex.getLineNumber();
    }
    /**
    * @descriptionThis methode will extract Query limits and other limits from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Limits details.
     */
    private static String getQueryLimit(Exception ex){
        return   '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries() + '\n'+'2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows() +'\n' + '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements() + '\n' +'4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime() ;
    }

     /**
    * @descriptionThis methode will extract Query limits and other limits from exception instance. 
     * @param  ex Exception instance.
     * @return    returns Additional details.
     */
    private static String getAdditionalInfo(Exception ex){
        String exceptionTypeName =getExceptionTypeName(ex);
        String additionalDetails = '';           
        if(String.isNotBlank(exceptionTypeName) && exceptionTypeName.equalsIgnoreCase('DMLException'))
        {
            additionalDetails = Log.getDMLData((DMLException)ex);
           
        }
        if(String.isNotBlank(exceptionTypeName) && exceptionTypeName.equalsIgnoreCase('QueryException'))
        {
           //Commenting temporary 
            additionalDetails += getQueryData((QueryException)ex);
        }
        return additionalDetails;
    }

    /**
     * @description getDMLData Extracting extra details from DML exception
     * @param  eRecord eRecord exception record
     * @return         return extra details
     */
    private static string getDMLData(DmlException eRecord){
        Integer fieldCount = eRecord.getNumDml();
        String dmlDetails = '';
        for(Integer i=0;i<fieldCount;i++){
            dmlDetails =eRecord.getDmlId(i) +'\t'+eRecord.getDmlFieldNames(i)+'\t'+eRecord.getDmlMessage(i) +'\t'+eRecord.getDmltype(i)+'\n';
        }
        return dmlDetails;
    }

    /**
     * @description getQueryData Extracting extra details from Query exception
     * @param  eRecord eRecord exception record
     * @return         return extra details
     */
    private static string getQueryData(QueryException eRecord){
        String inaccessinleFieldWithApiName ='';
        Map<String, Set<String>> inaccessibleFields = eRecord.getInaccessibleFields();
        for(String objectApi :inaccessibleFields.keySet() )
        {
            inaccessinleFieldWithApiName += objectApi +'\t'+ inaccessibleFields.get(objectApi)+'\n';
        }
        return inaccessinleFieldWithApiName;
    }
    public static void logExceptionOld(String className, String methodName , String errorString){
        Exception_Log__c exInstance = new Exception_Log__c();
        exInstance.Additional_Details__c = 'Here are some additional details';
        exInstance.Class_Name__c  = className;
        exInstance.Exception_Message__c = errorString;
        exInstance.Exception_Stack__c ='exEvent?.Exception_Stack__c;';
        exInstance.Exception_Type__c ='exEvent?.Exception_Type__c';
        exInstance.Governance_Limits__c ='exEvent?.Governance_Limits__c';
        exInstance.Method_Name__c = methodName;
        insert exInstance;
    } 
    
}