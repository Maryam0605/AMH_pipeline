/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 24-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   21-11-2022   Aaliyah Mohungoo   Initial Version
**/
global with sharing class BAT_GetVehicles implements Database.Batchable<sObject> , Database.Stateful, Schedulable{

    global String query;
    global String strErrors;
    global integer numberOfError;
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('>>>>>start method <<<<<');
        query = 'SELECT Id, InsuranceEndDate__c, RegistrationNumber__c, Contact__c, Contact__r.Name, Contact__r.Owner.Name,OwnerId, InsuredTo__r.OwnerId FROM Vehicle__c WHERE InsuranceEndDate__c = NEXT_N_DAYS:30';
        system.debug('### query : ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Vehicle__c> lstVeh) {
        system.debug('>>>>> START the execute method <<<<<');

        list<Task> lstTskUpdate = new list<Task>();
        // key is ownerId depuis vehicle -> et so vehicle value 
        // ggnr tt vehicle de sa owner Id la 
        map<String, List<Vehicle__c>> mapContactToLstVeh = new map<String, List<Vehicle__c>>();
        
        for (Vehicle__c veh : lstVeh){
            if (mapContactToLstVeh.containsKey(veh.InsuredTo__r.OwnerId)){
                mapContactToLstVeh.get(veh.InsuredTo__r.OwnerId).add(veh);
            }
            else{
                mapContactToLstVeh.put(veh.InsuredTo__r.OwnerId, new List<Vehicle__c>{veh});
            }
        }
        system.debug(mapContactToLstVeh);
        // if map not empty create the task-(Object sa) 
        if (!mapContactToLstVeh.isEmpty()){

            for (String OwnerId : mapContactToLstVeh.keySet()){

                Task tsk = new Task();
                tsk.Subject = 'Insurance renewal reminder';
                tsk.OwnerId =  OwnerId; // task la so owner Id 
                //task.WhatId = InsuredTo__r.OwnerId;
                //tsk.WhoId = OwnerId; 
                String description = 'Reminder for registration number : ';
                String insEndDate;
                // if sa ownerId la ena plis ki 1 value 
                if (mapContactToLstVeh.get(OwnerId).size() > 0){
                    // get so value pour sa ownerId la
                    for (Vehicle__c veh : mapContactToLstVeh.get(OwnerId)){
                        // decription equal sa registration number la 
                        description += veh.RegistrationNumber__c + ' ,';
                        insEndDate = String.valueOf(veh.InsuranceEndDate__c);
                    }
                }
                // concatenate sa decription la ec so end date 
                description += 'which expires on ' + insEndDate; 
                // add the description la 
                tsk.Description = description;
                // due date plus 7, acoz due date to phone the customer is within 1 week
                tsk.ActivityDate=Date.today().addDays(7);

                lstTskUpdate.add(tsk);
            }
        }
        // if task not created donne error
        list<Database.SaveResult> results = Database.insert(lstTskUpdate,false);
        //now insert to task
        for (Integer i = 0; i < lstTskUpdate.size(); i++) {
            Database.SaveResult sr = results[i];
            if(!sr.isSuccess()){
                numberOfError++;
                //create a CSV from the errors to be sent via email
                strErrors += 'Task for customer Id ' + lstTskUpdate[i].WhatId + ' could not be created for the following reason : ' + sr.getErrors()[0] + '\r\n';
            }
        }
    }
    // ici send email
    global void finish(Database.BatchableContext BC) {
        system.debug('## finish with ' + numberOfError + ' errors');

        if(numberOfError > 0){
            //craete an email message   
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
            email.setSubject('Salesforce batch : Task assignment failure');
            email.setPlainTextBody('');            
            email.setToAddresses(new List<String>{ 'aaliyah.mohungoo@spoonconsulting.com'});
            //craete an attachment from the error msg
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('error.log');
            attachment.setBody(blob.valueOf(strErrors));
            attachment.setContentType('text/plain');
            list<Messaging.EmailFileAttachment> attachments;
            attachments = new list<Messaging.EmailFileAttachment>();
            email.setFileAttachments(attachments);//add the attachment to the email message
            //send the email
            if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
        }
    }

    global void execute (SchedulableContext sc){
        BAT_GetVehicles batchObj = new BAT_GetVehicles();
        database.executeBatch(batchObj);
    }//end execute
}