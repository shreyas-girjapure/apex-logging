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

}