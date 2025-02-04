/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 08-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   08-11-2022   Aaliyah Mohungoo   Initial Version
**/
@isTest
public with sharing class AP02_AccountUpdateTest {
    @TestSetup
    static void makeData(){
        List<User> lstUser = AP_TestDataFactory.createUsers(1);
        insert(lstUser);

        System.runas(lstUser[0]){
            List<Account> lstAcc = AP_TestDataFactory.createAccounts(2);
            lstAcc[0].RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
            lstAcc[1].RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
            insert(lstAcc);
            
            List<Case> lstCas  =  AP_TestDataFactory.createCases(2);
            lstCas[0].AccountId = lstAcc[0].Id;
            lstCas[1].AccountId = lstAcc[1].Id;
            insert(lstCas);
        }
        
    }
    @isTest public static void testAccountCase() {
        
        Map<String,List<Account>> mapAccountAp = new Map<String,List<Account>>();

        List<User> lstUsers = [SELECT Id, name FROM USER WHERE LastName='Testing' ];
        System.runas(lstUsers[0]){
            Test.startTest();
            mapAccountAp = AP02_AccountUpdate.accountCase();
            List<Account> lstAcc = [SELECT Name ,RecordType.DeveloperName, RecordTypeId FROM Account];
            Map<String,List<Account>> mapAccount = new Map<String,List<Account>>();
            for (Account acc : lstAcc) { 
                if(mapAccount.containsKey(acc.RecordType.DeveloperName)){
                    mapAccount.get(acc.RecordType.DeveloperName).add(acc);
                }else{
                    mapAccount.put(acc.RecordType.DeveloperName, new List<Account>{acc});
                }   
            }
            Test.stopTest();    
            System.assertEquals(mapAccountAp,mapAccount,'good');    
        }

    }
}