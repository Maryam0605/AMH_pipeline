/**
 * @description       :
 * @author            : Aaliyah Mohungoo
 * @group             :
 * @last modified on  : 07-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   28-10-2022   Aaliyah Mohungoo   Initial Version
 **/
public with sharing class LC01_DisplayInvoicesController {
  @AuraEnabled
  public static List<Invoice__c> getInvoice(String caseId) {
    List<Invoice__c> lstInv = new List<Invoice__c>();
    try{
      lstInv = [
        SELECT
          Name,
          AmountWithVat__c,
          InvoiceDate__c,
          Account__c,
          AmountWithoutVat__c,
          Contact__c
        FROM Invoice__c
        WHERE Case__c = :caseId
        ORDER BY CreatedDate DESC
      ];
    }catch(Exception e){
        System.debug(e.getMessage());
    }
   
    return lstInv;
  }
}