public with sharing class ExceptionEventTriggerHandler {
    public ExceptionEventTriggerHandler() {
    System.debug('');      

    }
    //ExceptionEventTriggerHandler.errorCausing();
    public static void errorCausing()
    {
        try{
            List<Account> acList = new List<Account>();
            Account ac = new Account();
            ac.Site = 'okGoogle';
            ac.Name = 'ok';
            Account ac1 = new Account();
            acList.add(ac);
            acList.add(ac1);
            insert acList;
          // List<Account> accounts = [SELECT Website, (SELECT Email FROM Contacts) FROM Account WITH USER_MODE];
        }
        catch (Exception ex)
        {
            ExceptionEventTriggerHandler.getExData(ex);
        }
    }
    /**
     * purpose : To extract data from Exception log
     */
    public static void getExData(Exception e )
    {
        try {
           
            String stackTrace = e.getStackTraceString()?.substringBefore('\n');
            String className =  e.getStackTraceString()?.substringBefore('\n').substringAfter('.')?.substringBefore('.');
            String methodName =  e.getStackTraceString()?.substringBefore('\n').substringBefore(':')?.substringAfter(className)?.substringAfter('.');
            String exceptionTypeName =e.getTypeName()?.substringAfter('.');
            String exceptionMessage = e.getMessage();
            Integer lineNumber = e.getLineNumber();
            String queryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries() + '\n'+'2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows() +'\n' + '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements() + '\n' +'4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime() ;
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
            system.debug('logLevel-->'+ additionalDetails);
            system.debug('1---->' +stackTrace +'\n' + className + '\n' + methodName + '\n' + queryLimit + '\n' + exceptionMessage + '\n' + exceptionTypeName + '\n' + lineNumber);



        } catch (Exception ex) {
            system.debug('logLevel' + ex.getStackTraceString());
        }
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