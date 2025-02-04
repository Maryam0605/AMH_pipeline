/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 04-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class LWC01_displayVehicle {
    @AuraEnabled(cacheable=true)
    public static List<Vehicle__c> displayVehicles(String recordId) {
      List<Vehicle__c> lstVeh = [
        SELECT Name,Make__c, Model__c,Contact__c
        FROM Vehicle__c
        WHERE Contact__c =:recordId
      ];
      return lstVeh;
    }
}