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
public with sharing class LWC01_terminateLoanUS2 {
    @AuraEnabled(cacheable=false)
    public static void removeLoanStatus(Id caseid) {
        List<Case> lstCas = [
            SELECT LoanedVehicle__c,
            LoanedVehicle__r.LoanEndDate__c
            FROM Case
            WHERE Id = :caseid AND LoanedVehicle__c != NULL];
        System.debug('>>>>>>>>>>>>>>>>' + caseid);
        Vehicle__c veh = new Vehicle__c();
        veh.Id = lstCas[0].LoanedVehicle__c;
        veh.status__c = 'available';
        veh.LoanEndDate__c = NULL;
        veh.LoanStartDate__c = NULL;
        update veh;
    }
}