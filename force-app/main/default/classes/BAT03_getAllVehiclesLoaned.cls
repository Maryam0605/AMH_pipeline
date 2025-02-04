/**
 * @description       :
 * @author            : Aaliyah Mohungoo
 * @group             :
 * @last modified on  : 23-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   23-11-2022   Aaliyah Mohungoo   Initial Version
 **/
global class BAT03_getAllVehiclesLoaned implements Database.Batchable<sObject> {
  global Database.QueryLocator start(Database.BatchableContext BC) {
    // collect the batches of records or objects to be passed to execute

    String query = 'SELECT Id, isBeingLoaned__c, LoanStartDate__c, LoanEndDate__c FROM Vehicle__c WHERE ((LoanStartDate__c <= TODAY AND LoanEndDate__c >= TODAY) AND isBeingLoaned__c = false) OR ((NOT(LoanStartDate__c <= TODAY AND LoanEndDate__c >= TODAY)) AND isBeingLoaned__c = true)';
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<Vehicle__c> vehList) {
    system.debug('>>>>> START the execute method <<<<<');

    for (Vehicle__c veh : vehList) {
      if (
        veh.LoanStartDate__c <= system.TODAY() &&
        veh.LoanEndDate__c >= system.TODAY()
      ) {
        veh.isBeingLoaned__c = true;
      } else {
        veh.isBeingLoaned__c = false;
      }
    }
    try {
      if (vehList.size() > 0) {
        update vehList;
      }
    } catch (Exception e) {
      System.debug(e);
    }
  }

  global void finish(Database.BatchableContext BC) {
    // execute any post-processing operations like sending email
  }
}