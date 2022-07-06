public with sharing class DemoClass {
    public DemoClass() {

    }
    //DemoClass.errorCausing();
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
            Log.raisePlatformEvent(ex);
            //Log.raisePlatformEvent(ex);
        }
    }
}
