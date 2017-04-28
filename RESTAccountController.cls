/*
    Task: Account Reparenting Web Service Challenge
    Created by : Mriganko Mukherjee
    Created date :28/04/2017
*/

@RestResource(urlMapping='/Account/*')

global with sharing class RESTAccountController 
{
 @HttpPost  
 global static String createAccount(String AccountName,String OptimizeID)
  {
    string response;
    Account testTemp = new account();
    boolean isAccount = false;
    list<account> listAcc = new list<account>([select id,name,OptimizeID__c from account where OptimizeID__c =:OptimizeID limit 1]);
    if(listAcc.size()==0)
    {
        listAcc = [select id,name,OptimizeID__c from account where name =:AccountName limit 1];
        if(listAcc.size()==0)
        {
            account tempAcc = new Account();
            tempAcc.name = AccountName;
            try{
                insert tempAcc;
            }
            catch(Exception e)
            {
                return string.valueof(e);
            }
            response = tempAcc.name;
        }
        else
        {
            account tempAcc = new Account();
            tempAcc.name = AccountName;
            tempAcc.ParentId = listAcc.get(0).id;
            try{
                insert tempAcc;
            }
            catch(Exception e)
            {
                return string.valueof(e);
            }
            response = tempAcc.name;
            testTemp.id =tempAcc.id;
            
        }
        
        return 'Account name: '+response+' '+'Accountid'+' '+testTemp.id;
    }
    else
    {
        String storeAccId = listAcc.get(0).id;
        list<account> listParentAcc = new list<account>([select id,name,ParentId,OptimizeID__c  from account where id =:storeAccId limit 1]);
        if(listParentAcc.get(0).ParentId!=null)
        {
            list<account> parentAcc = [select id,name,ParentId from account where id=:listParentAcc.get(0).ParentId and name =:AccountName and OptimizeID__c !=: OptimizeID and ParentId =:null limit 1];
            listAcc.get(0).ParentId = parentAcc.get(0).id;
            try{
                update listAcc;
            }
            catch(Exception e)
            {
                return string.valueof(e);
            }
            return listAcc.get(0).name;
        }
        else{
         return listParentAcc.get(0).ParentId ;
     }

}

}

}