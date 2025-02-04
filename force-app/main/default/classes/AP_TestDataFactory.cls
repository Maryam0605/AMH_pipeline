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
public with sharing class AP_TestDataFactory {
        // Create Account
        public static List<Account> createAccounts(Integer numAcc) {
            List<Account> lstAcc = new List<Account>();
            for(Integer i=0; i<numAcc; i++){
                Account accObj = new Account();
                accObj.Name = 'test';
                accObj.Region__c='North';
                accObj.Phone='57563913';
                accObj.BillingStreet = 'Royal Rd';
                accObj.BillingCity = 'Moka';
                accObj.BillingCountry = 'Mauritius';
                lstAcc.add(accObj);
            }
            return lstAcc;
        }
    
       // Create Case
       public static List<Case> createCases(Integer numCase) {
        List<Case> lstCas = new List<Case>();
        for(Integer i=0; i<numCase; i++){
            Case caseObj = new Case();
            caseObj.Status ='New';
            caseObj.Origin = 'Phone';
            caseObj.Subject = 'testing';
            lstCas.add(caseObj);
        }
        return lstCas;
    }
    
    // Create Invoice
    public static List<Invoice__c> createInvoices(Integer numInv) {
        List<Invoice__c> lstInv = new List<Invoice__c>();
        for(Integer i=0; i<numInv; i++){
            Invoice__c invoiceObj = new Invoice__c();
            invoiceObj.Vat__c = 2;
            invoiceObj.Name = 'test';
           // invoiceObj.Case__c = caseObj.Id;
            lstInv.add(invoiceObj);
        }
        return lstInv;
    }
    // Create User
    public static List<User> createUsers(Integer numUser) {
        List<User> lstUsers = new List<User>();
        for(Integer i=0; i<numUser; i++)
        {
            User user = new User();
            user.email = 'aaliyah.mohungoo@spoonconsulting.com';
            user.ProfileId = UserInfo.getProfileId();
            user.UserName = 'sponalia6@testorg.com';  
            user.LastName='testing';          
            user.Alias =  'TST1';
            user.TimeZoneSidKey = 'America/New_York';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LocaleSidKey = 'en_US';
            user.LanguageLocaleKey = 'en_US';
            lstUsers.add(user);
        }
        return lstUsers;
    }
}