/**
 * @File Name          : CaseTriggerHandler.cls
 * @Description        : <Case 1: Handler to filter after update:
 * As an agent, i want an invoice to be created after a claim has
 * been processed so as to issue payment to the customer>
 * @Author             : <Spoon Consulting>
 * @Group              :
 * @Last Modified By   : Aaliyah Mohungoo
 * @Last Modified On   : 21-11-2022
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      Modification
 *==============================================================================
 * 1.0    25-10-2022     <AMO>      Initial Version
 **/
public with sharing class CaseTriggerHandler {
    /**
         * @description An an agent,i want to create an invoice automatically after a claim status is 
         * changed to payment with last payment date to be 3 month after date of creation
            Given a case status has been updated to “Payment”, an invoice should be created with
            the lookup fields account ,contact and case set to the corresponding case
            the last payment date to 3 month after date of creation <3
         * @author Aaliyah Mohungoo | 25/10/2022
         * @return filtering of list of case for status .
         **/
    /////////Try 1
    /*
    public void handleAfterUpdate(List<Case> lstNewCas, Map<Id, Case> mapOldCas) {
        // handler logic
        List<Invoice__c> lstInv = new List<Invoice__c>();
        for (Case casNew : lstNewCas) {
            Case caseRecOld = mapOldCas.get(casNew.Id); // ggnr value de sa ID new case la, store li dans
            //caseRecOld instance
            if (casNew.Status != caseRecOld.Status) {
                if (casNew.Status == 'Payment') {
                    Invoice__c inv = new Invoice__c(Account__c = casNew.AccountId, Case__c = casNew.Id, Contact__c = casNew.ContactId);

                    lstInv.add(inv);
                }
            }
        }
        if (lstInv.size() > 0) {
            insert lstInv;
        }
    }*/
    //case study 1 after update
    public void handleAfterUpdate(List<Case> lstNewCas, Map<Id, Case> mapOldCas) {
        // handler logic
        List<Case> lstCas = new List<Case>();
        for (Case casNew : lstNewCas) {
            Case caseRecOld = mapOldCas.get(casNew.Id); // ggnr value de sa ID new case la, store li dans
            //caseRecOld instance
            if (casNew.Status != caseRecOld.Status && casNew.Status == 'Payment') {
                lstCas.add(casNew);
            }
            
        }
        if (lstCas.size() > 0) {
            AP001_CreateInvoice.createInvoiceFromCase(lstCas);
        }
    }

    //case study 4 before insert and update
    public void handleBeforeInsert(List<Case> lstNewCas) {
        // handler logic
        List<Case> lstCas = new List<Case>();
        for (Case casNew : lstNewCas) {
            if (casNew.LoanedVehicle__c != null) {
                lstCas.add(casNew);
            }
        }
        if (lstCas.size() > 0) {
            AP004_AlertVehicleAlreadyLoaned.CannotAssignVehicleLoaned(lstCas);
        }
    }
    //update
     //case study 4 before insert and update
     public void handleBeforeUpdate(List<Case> lstNewCas, Map<Id, Case> mapOldCas) {
        // handler logic
        List<Case> lstCas = new List<Case>();
        for (Case casNew : lstNewCas) {
            if (casNew.LoanedVehicle__c != null) {
                lstCas.add(casNew);
            }
        }
        if (lstCas.size() > 0) {
            AP004_AlertVehicleAlreadyLoaned.CannotAssignVehicleLoaned(lstCas);
        }
    }
}