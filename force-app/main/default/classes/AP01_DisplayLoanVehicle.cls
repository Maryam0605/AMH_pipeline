/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   03-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP01_DisplayLoanVehicle {
    @AuraEnabled(cacheable=true)
    public static List<Case> loanVehicles(Id recordId) {
      List<case> lstcaseOnVehicle = [
        SELECT
          Id,
          LoanedVehicle__c,
          LoanedVehicle__r.EngineCapacity__c,
          LoanedVehicle__r.Name,
          LoanedVehicle__r.InsuranceEndDate__c,
          LoanedVehicle__r.InsuranceStartDate__c,
          LoanedVehicle__r.InsuredTo__c,
          LoanedVehicle__r.InsuredTo__r.Active__c
        FROM Case
        WHERE LoanedVehicle__c != NULL AND Id=:recordId
      ];
      return lstcaseOnVehicle;
    }
}