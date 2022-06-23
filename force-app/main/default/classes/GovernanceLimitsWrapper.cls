public without sharing class GovernanceLimitsWrapper {
    //Add other limits here
    public string dmlRowLimit {get;set;}
    public string queryLimit {get;set;}
    public string dmlStatementLimit {get;set;}
    public string heapLimit {get;set;}

    public GovernanceLimitsWrapper(){
        dmlRowLimit = Limits.getDmlRows() + '/'+ Limits.getLimitDmlRows();
        System.debug(LoggingLevel.ERROR,'GovernanceLimitsWrapper');
    }


}