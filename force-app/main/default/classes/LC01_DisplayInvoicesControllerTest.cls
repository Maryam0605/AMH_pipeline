/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 02-05-2025
 * @last modified by  : AMH
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   07-11-2022   Aaliyah Mohungoo   Initial Version
**/
@isTest
public with sharing class LC01_DisplayInvoicesControllerTest {
    @TestSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'test', Email='aaliyah.mohungoo@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sponalia6@testorg.com');
        insert u;
        System.debug(u);

        System.runas(u){ 
            
            List<Case> lstCase = new List<Case>();
            Case caseObj = new Case();
            caseObj.Status ='New';
            caseObj.Origin = 'Phone';
            caseObj.Subject = 'testing';
            lstCase.add(caseObj);
            insert lstCase;
            System.debug(caseObj.Id);

            List<Invoice__c> lstInv = new List<Invoice__c>();
            Invoice__c invoiceObj = new Invoice__c();
            invoiceObj.Name = 'test';
            invoiceObj.Case__c = caseObj.Id;
            lstInv.add(invoiceObj);
            insert lstInv;
            System.debug(invoiceObj.Id);
        }       
    } 
    @isTest public static void testInvoiceController() {
        List<Case> lstCase = new List<Case>();
        List<Invoice__c> lstInv = new List<Invoice__c>();

        List<User> lstUsers = [SELECT Id, name FROM USER WHERE LastName='Testing' ];
        System.runas(lstUsers[0]){
            Test.startTest();
            lstCase = [SELECT Id FROM Case WHERE Status ='New'];
            //lstInv = LC01_DisplayInvoicesController.getInvoice(lstCase[0].Id);
            lstInv = LC01_DisplayInvoicesController.getInvoice('test');
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
             // List<Invoice__c> lstInv3 = [SELECT Name FROM Invoice__c  WHERE Case__c = :lstCase[10].Id];
            Test.stopTest();
            //System.assertEquals(lstInv,lstInv2,'good');
            //System.assert(lstInv3,lstInv2,'wrong');
            System.assert( lstInv.size()==0,'wrong');
            //System.assertEquals(1,lstInv2.size(),'good');
        }
 
        
    }
}