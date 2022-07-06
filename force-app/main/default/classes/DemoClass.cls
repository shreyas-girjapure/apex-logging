public with sharing class DemoClass {
    public DemoClass() {

    }
    //DemoClass.raiseDMLException();
    public static void raiseDMLException()
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
            
            }
        catch (Exception ex)
        {            
            Log.raisePlatformEvent(ex);
            //Log.raisePlatformEvent(ex);
        }
    }
    public static void queryDMLException()
    {
        try{
            List<Account> acList = new List<Account>();
            //to execute below exception remove FLS of System admin for Website field
             List<Account> accounts = [SELECT Website, (SELECT Email FROM Contacts) FROM Account WITH USER_MODE];
        }
        catch (Exception ex){            
            Log.raisePlatformEvent(ex);           
        }
    }
    // Slow debug method for CPU time display
    public static void slowDebugMethod(){
        for(Integer i = 0 ; i < 100000 ;i++){
            System.debug('slowing down');
        }
    }
    // Old utility logging methods
    public static void errorCausingRegular(){
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
        catch (Exception ex){            
            Log.logExceptionOld('myClass','myMethod','failed to insert records');
        }
    }

}