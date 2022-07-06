public with sharing class DemoClass {
    public DemoClass() {

    }
    //DemoClass.
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
        }
    }
    // To execute two different Exception pass 1 or 2 as argument
    public static void queryDMLException(Integer num)
    {
        try{
            List<Account> acList = new List<Account>();
            //to execute below exception remove FLS of System admin for Website field
            if(num == 1)
            {
             List<Account> accounts = [SELECT Website, (SELECT Email FROM Contacts) FROM Account WITH USER_MODE];
            }
            else 
            {
                Account acc =  [SELECT Id FROM Account where Id = '000001111122222123' WITH USER_MODE];
            }
        }
        catch (Exception ex){            
            Log.raisePlatformEvent(ex);          
        }
    }

    

    public static void raiseListException()
    {
        try{
            List<Account> acList = new List<Account>();
            Account ac = new Account();
            ac = acList[0];
            }
        catch (Exception ex)
        {            
            Log.raisePlatformEvent(ex);
        }
    }

    public static void raiseMathException()
    {
        try{
            Integer i = 1/0;
            }
        catch (Exception ex)
        {            
            Log.raisePlatformEvent(ex);
        }
    }
    public static void raiseNullPointerException()
    {
        try{
            String s;
            s.toLowerCase(); }
        catch(Exception ex)
        {
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