/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 08-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   07-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class WS01_RequestAccountInformation {
    // public static String GetAccessToken() {
    //     String accesstoken;
    //     Http http = new Http();
    //     HttpRequest request = new HttpRequest();
    //     APIGetToken__mdt accessSetting = APIGetToken__mdt.getInstance('TiBiz');
    //     System.debug(accessSetting);
    //     request.setEndpoint('https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id='+accessSetting.clientId__c+'&client_secret='+accessSetting.clientSecret__c+'&username='+accessSetting.username__c+'&password='+accessSetting.password__c);
    //     request.setMethod('POST');
    //     request.setHeader('Content-Type','application/x-www-form-urlencoded');
    //     //request.setBody('email' + email);
    //     HttpResponse response = http.send(request);
    //     // If the request is successful, parse the JSON response.
    //     System.debug(response.getStatusCode());
    //     if(response.getStatusCode() == 200) {
    //         // Deserialize the JSON string into collections of primitive data types.
    //         Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    //         System.debug(results);        
    //         System.debug(results.get('access_token'));     
    //     }
    //     return accesstoken;
    // }
    public static String makeGetCallout(){    
        APIGetToken__mdt accessSetting= APIGetToken__mdt.getInstance('TiBiz');
        System.debug(accessSetting);
        String accesstoken;

        Http http = new Http();
        HttpRequest request = new HttpRequest();

      
            request.setEndpoint('https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id='+accessSetting.clientId__c+'&client_secret='+accessSetting.clientSecret__c+'&username='+accessSetting.username__c+'&password='+accessSetting.password__c);
                  
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {

            System.debug('Success');

            map<string,Object> resultMap = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
            accesstoken = (String)resultMap.get('access_token');

        } else {
            //System.debug(response.getBody());
        }
        
        System.debug('Access Token'+accesstoken);
        return accesstoken;
    }
    public static void getResponse(String email) {

        String accesstoken=makeGetCallout();
    
        System.debug('>>>>>>>>>>>>>>>>'+accesstoken);
        Http http = new Http();
        HttpRequest httpReq = new  HttpRequest();
        
        httpReq.setEndpoint('https://spoonconsultingltd3-dev-ed.develop.my.salesforce.com/services/apexrest/WS01_AccountDetails');
        httpReq.setMethod( 'POST' );
        httpReq.setHeader( 'Content-Type', 'application/json;charset=UTF-8' );
        httpReq.setHeader( 'Accept', 'application/json' );
        httpReq.setHeader( 'Authorization', 'Bearer ' + accesstoken );
    
        String body ='{"Email":"'+email+'"}';
            
        httpReq.setBody(body);
    
            HttpResponse response = http.send(httpReq);
    
    
            if(response.getStatusCode() == 200) {
    
                System.debug('Success');
    
                map<string,Object> results = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
    
               // map<string,Object> resultMap = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
                System.debug('===>'+results);
              
    
            } else {
                //System.debug(response.getBody());
            }
    }

}