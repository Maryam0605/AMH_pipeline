/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 18-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   17-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class LWC01_retrieveLoanVehicle {
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