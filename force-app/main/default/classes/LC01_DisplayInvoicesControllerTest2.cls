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
public with sharing class LC01_DisplayInvoicesControllerTest2 {
    @TestSetup
    static void makeData(){
        List<User> lstUser = AP_TestDataFactory.createUsers(1);
        insert(lstUser);

        System.runas(lstUser[0]){

            List<Case> lstCas = AP_TestDataFactory.createCases(1);
            insert(lstCas);

            List<Invoice__c> lstInv =  AP_TestDataFactory.createInvoices(1);
            lstInv[0].Case__c = lstCas[0].Id;
            insert(lstInv);
        }    

    }
    @isTest public static void testGetInvoice() {
        List<Case> lstCase = new List<Case>();
        List<Invoice__c> lstInv = new List<Invoice__c>();

        List<User> lstUsers = [SELECT Id, name FROM USER WHERE LastName='Testing' ];
        System.runas(lstUsers[0]){
            Test.startTest();
            lstCase = [SELECT Id FROM Case WHERE Status ='New'];
            lstInv = LC01_DisplayInvoicesController.getInvoice(lstCase[0].Id);
            //lstInv = LC01_DisplayInvoicesController.getInvoice('test');
            List<Invoice__c> lstInv2 = [
                SELECT
                  Name,
                  AmountWithVat__c,
                  InvoiceDate__c,
                  Account__c,
                  AmountWithoutVat__c,
                  Contact__c
                FROM Invoice__c
                WHERE Case__c = :lstCase[0].Id
                ORDER BY CreatedDate DESC
              ];
             
            Test.stopTest();
            System.assertEquals(lstInv,lstInv2,'good');
            //System.assert( lstInv.size()==0,'wrong');
            //System.assertEquals(1,lstInv2.size(),'good');
        }

    }
}