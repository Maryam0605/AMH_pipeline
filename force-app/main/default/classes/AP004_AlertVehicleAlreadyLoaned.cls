/**
 * @description       :
 * @author            : Aaliyah Mohungoo
 * @group             :
 * @last modified on  : 26-10-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   26-10-2022   Aaliyah Mohungoo   Initial Version
 **/
public with sharing class AP004_AlertVehicleAlreadyLoaned {
    public static void CannotAssignVehicleLoaned(List<Case> lstCas) {
        // create a set to store vehicle ID
        Set<Id> setId = new Set<Id>();
        // loop through the filter handler where the field is not null and store ID
        for (Case vehID : lstCas) {
            setId.add(vehID.LoanedVehicle__c);
        }
        // create a list to do a select on vehicle
        List<Vehicle__c> lstId = new List<Vehicle__c>();

        // select id from vehicle where id is in the set and status is loaned
        lstId = [SELECT Id FROM Vehicle__c WHERE id IN :setId AND Status__c = 'loaned'];

        // to avoid duplicate ID, met li dans un set et aussi pour servi enbas
        Set<Id> setVehLoaned = new Set<Id>();
        for (Vehicle__c vehIDLoaned : lstId) {
            setVehLoaned.add(vehIDLoaned.Id);
        }

        for (Case casNew : lstCas) {
            if (setVehLoaned.contains(casNew.LoanedVehicle__c)) {
                casNew.adderror('Cannot assign vehicle that is already on loan');
            }
        }
    }
}