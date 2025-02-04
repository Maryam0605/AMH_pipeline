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
public with sharing class AP01_DisplayVehicle {
  @AuraEnabled(cacheable=true)
  public static List<Vehicle__c> findVehicles(Id recordId) {
    List<case> lstcase = [SELECT Id, Vehicle__c FROM Case WHERE Id = :recordId];

        Set<Id> setVehicleId = new Set<Id>();
        for (Case cas : lstcase) {
            setVehicleId.add(cas.Vehicle__c);
        }

        List<Vehicle__c> vehicle = [SELECT 	Make__c,Mileage__c, Model__c, LoanEndDate__c FROM Vehicle__c WHERE Id IN :setVehicleId];
        return vehicle;
  }
}