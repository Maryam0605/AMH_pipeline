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
public with sharing class AP03_TestPJOTest {


    @TestSetup
    static void setup(){

        List<User> lstuser = AP_TestDataFactory.createUsers(1);
        INSERT lstuser;

        List<Account> lstAcc = AP_TestDataFactory.createAccounts(1);
        INSERT lstAcc;
        
    }
    @isTest
    public static void testCallout()
    {
        List<User> lstuser = [SELECT Id FROM User];

        System.runas(lstuser[0])
        {
            List<Account> lstAcc = [SELECT Id FROM Account];
        
            //set mock callout class
            //set mock - pe activate sa class, li pou repon nou ban kitchose ki ena dan class la
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

            AP03_TestPJO.getAccountInfo(lstAcc[0].Id);
        }

    }
       
}