/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 21-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   25-10-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP003_AlertDeleteInvoice {
    public static void preventDeleteInvoice(List<Invoice__c> lstInv){

       // List<Invoice__c> lstInvGetRecords = [SELECT  LastPaymentDate__c FROM Invoice__c WHERE Id IN: lstInv];

        for (Invoice__c inv : lstInv) {
          
                inv.adderror('Cannot delete invoice before last payment date');
            
            
        }

    }
}