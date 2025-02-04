/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 20-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   20-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class LWC01_retrieveVehicleDetails {
    @AuraEnabled(cacheable=true)
    public static List<Case> CustomerVehicles(Id cusId) {
      List<case> lstcaseOnCustomerVehicle = [
        SELECT
          Id,
          Vehicle__c,
          Vehicle__r.Make__c,
          Vehicle__r.Model__c,
          Vehicle__r.YearOfVehicle__c,
          Vehicle__r.RegistrationNumber__c,
          Vehicle__r.Description__c,
          Vehicle__r.Mileage__c,
          Vehicle__r.Warranty__c,
          Vehicle__r.EngineCapacity__c,
          Vehicle__r.Colour__c,
          Vehicle__r.InsuredTo__c,
          Vehicle__r.InsuranceStartDate__c,
          Vehicle__r.InsuranceEndDate__c                 
        FROM Case
        WHERE Vehicle__c != NULL AND Id=:cusId
      ];
      return lstcaseOnCustomerVehicle;
    }
    @AuraEnabled(cacheable=false)
    public static List<Case> loanVehicles(Id loanId) {
      List<case> lstcaseOnLoanVehicle = [
        SELECT
          Id,
          LoanedVehicle__c,
          LoanedVehicle__r.Make__c,
          LoanedVehicle__r.Model__c,
          LoanedVehicle__r.YearOfVehicle__c,
          LoanedVehicle__r.LoanStartDate__c,
          LoanedVehicle__r.LoanEndDate__c,
          LoanedVehicle__r.LoanedTo__c,
          LoanedVehicle__r.status__c        
        FROM Case
        WHERE LoanedVehicle__c != NULL AND Id=:loanId
      ];
      return lstcaseOnLoanVehicle;
    }
}