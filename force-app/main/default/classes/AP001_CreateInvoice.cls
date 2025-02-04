/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 26-10-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   25-10-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP001_CreateInvoice {
    public static void createInvoiceFromCase(List<Case> lstcas){
        List<Invoice__c> lstInvNew = new List<Invoice__c>();

        for(Case cas: lstCas)
        {
            Invoice__c inv = new Invoice__c
            (
                Case__c = cas.Id, 
                Account__c = cas.AccountId, 
                Contact__c = cas.ContactId,
                LastPaymentDate__c = cas.CreatedDate.addMonths(3)
            );

            lstInvNew.add(inv);
        }
        if(lstInvNew.size()>0)
        {
            insert lstInvNew;
        }
        
    }
}