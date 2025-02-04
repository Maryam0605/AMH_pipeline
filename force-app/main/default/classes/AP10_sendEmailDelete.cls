/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 05-12-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   27-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP10_sendEmailDelete {
    public static void sendEmail(List<Account> lstAccEmail) {
        String address, subject, body;
        List<Account> lstAccGetRecords = [SELECT Email__c, Name FROM Account WHERE Id IN: lstAccEmail];
        System.debug('enter');
        for(Account acc: lstAccGetRecords)
        {
            address = acc.Email__c;
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + address);
            subject = 'Account Name '+ acc.Name;
            body = 'has been deleted succesfully';
            
            // Create an email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {address};
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            // Pass this email message to the built-in sendEmail method 
            // of the Messaging class
            Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                    new Messaging.SingleEmailMessage[] { mail });
            // Call a helper method to inspect the returned results
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + results);
          
            inspectResults(results);
            
        }
      
    }
      // Helper method
      private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
    
}