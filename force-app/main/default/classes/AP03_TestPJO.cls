/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 08-11-2022
 * @last modified by  : Aaliyah Mohungoo 
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   08-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP03_TestPJO Implements Database.AllowsCallouts{

    static AccountDetails currAccount = new AccountDetails();
    
    @future(callout=true)
        public static void getAccountInfo(Id accountId) {
            Map<String, String> body = new Map<String, String>();
            currAccount.accountId = accountId;
            
            // Get email and construct map 
            List<Account> lstAccount = new List<Account>([SELECT Id, Name, Email__c FROM Account WHERE Id = :accountId]);
    
            // Construct body
            body.put('Email', lstAccount[0].Email__c);
    
            // Get access token
           // String accessToken = getAccessToken();
    
            try{
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                // Move endpoint to label
                request.setEndpoint('https://spoonconsultingltd3-dev-ed.develop.my.salesforce.com/services/apexrest/WS01_AccountDetails');
                request.setMethod('POST');
                //request.setHeader('Authorization', 'Bearer ' + accessToken);
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                // Set the body as a JSON object
                String jsonBody = JSON.serialize(body);
                System.debug('>> jsonBody '+jsonBody);
                request.setBody(jsonBody);
                // request.setBody('{"Email":"dhovisha.munbodh@spoonconsulting.com"}');
                System.debug('sendAccountInfo request: ' + request);
                HttpResponse response = http.send(request);
                System.debug('sendAccountInfo response: ' + response);
    
                // Parse the JSON response
                if(response.getStatusCode() != 200) {
                    System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                } else {
                    System.debug(response.getBody());
                    Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    System.debug('>> mapResult '+mapResult); 
     
                    currAccount.email = (String) mapResult.get('Email Address');
                    currAccount.rating = (String) mapResult.get('Rating');
                    currAccount.customerPriority = (String) mapResult.get('CustomerPriority');
                    currAccount.mobile = (String) mapResult.get('Mobile');
                    currAccount.region = (String) mapResult.get('Region');
                    currAccount.SLA = (String) mapResult.get('SLA');
                    currAccount.SLAExpirationDate = (String) mapResult.get('SLAExpirationDate');
                    currAccount.SLASerialNumber = (String) mapResult.get('SLASerialNumber');
                    currAccount.upsellOpportunity = (String) mapResult.get('UpsellOpportunity');
                    currAccount.website = (String) mapResult.get('Website');
                    
                    currAccount.dateSynchro = system.now();
                    currAccount.errMessage = '';
                    
                    System.debug('currAccount '+currAccount);
    
                    // Save to record
                    //saveAccountInfo(currAccount, false);
                }
            }catch(Exception ex){
                System.debug('An exception occurred:'+ex.getMessage());
            }
    
            // return response;
        }
    
            // Wrapper class
            public class AccountDetails {
                public String accountId;
                public String email;
                public String rating;
                public String customerPriority;
                public String mobile;
                public String region;
                public String SLA;
                public String SLAExpirationDate;
                public String SLASerialNumber;
                public String upsellOpportunity;
                public String website;
                // Error 
                public String errMessage;
                public Datetime dateSynchro;
            }
    }