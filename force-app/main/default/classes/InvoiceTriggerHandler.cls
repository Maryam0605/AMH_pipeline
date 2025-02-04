/**
 * @File Name          : <CaseTrigger>.trigger
 * @Description        : <As a customer i should receive an email (contact email) when my invoice is created
                            The email subject should be ‘Ti Vitesse: Invoice-<<invoice number>>’
                            The email content should contain the following details:
                            Price including VAT,Case type, Case reason,Last Payment date,vehicle registration number>
 * @Author             : <Spoon Consulting>
 * @Group              : 
 * @Last Modified By   : Aaliyah Mohungoo
 * @Last Modified On   : 21-11-2022
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      Modification
 *==============================================================================
 * 1.0    25-10-2022                    <AMO>      Initial Version
**/
public with sharing class InvoiceTriggerHandler {
    /**
         * @description <As a customer i should receive an email (contact email) when my invoice is created
                            The email subject should be ‘Ti Vitesse: Invoice-<<invoice number>>’
                            The email content should contain the following details:
                            Price including VAT,Case type, Case reason,Last Payment date,vehicle registration number>
         * @author Aaliyah Mohungoo | 25/10/2022
         * @return filtering of list of invoice to send a mail .
         **/
        // case study 2
    public void handleAfterInsert(List<Invoice__c> lstNewInv) {
        // handler logic
        List<Invoice__c> lstInv = new List<Invoice__c>();
        for (Invoice__c invNew : lstNewInv) {
            if(invNew.Contact__r != NULL){
                 lstInv.add(invNew);
                }
        }
        if (lstInv.size() > 0) {
            AP002_SendEmailWhenInvoiceCreated.sendEmailFromInvoice(lstInv);
        }
    }
    // case study 3
    public void handleBeforeDelete(List<Invoice__c> lstOldInv) {
        // handler logic
        List<Invoice__c> lstInv = new List<Invoice__c>();
        for (Invoice__c invNew : lstOldInv) {
            if (invNew.LastPaymentDate__c > System.now()) {
            lstInv.add(invNew);
            }
        }
        if (lstInv.size() > 0) {
            AP003_AlertDeleteInvoice.preventDeleteInvoice(lstInv);
        }
    }
}