/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 18-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   18-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP01_UpdateAccount_UseCaseWS {
    public static void updateAccount(List<Account> lstAcc){
        for(Account acc: lstAcc){
            WS01_RequestNewAccountREST.getResponse(acc.Id,acc.Email__c);
        }

    }
 
}