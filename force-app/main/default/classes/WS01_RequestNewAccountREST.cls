/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 23-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   14-11-2022   Aaliyah Mohungoo   Initial Version
**/
// callout method for webservice
//tivitesse
public with sharing class WS01_RequestNewAccountREST {
    public static String makeGetCallout(){
    
        // create a custom metadata type with custom fields and insert the cliendId, secret, username and password.
        APIGetToken__mdt accessSetting= APIGetToken__mdt.getInstance('TiBiz');
        //TiBizMehreen__mdt accessSetting= TiBizMehreen__mdt.getInstance('mehreenToken');
        System.debug(accessSetting);
        String accesstoken;

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String endPoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id='+accessSetting.clientId__c+'&client_secret='+accessSetting.clientSecret__c+'&username='+accessSetting.username__c+'&password='+accessSetting.password__c;
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      //  request.setBody('{"email":"mighty moose"}');
        
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


//method call
@future(callout=true)
public static void getResponse(String accountId, String email) {

    String accesstoken=makeGetCallout();

    System.debug('>>>>>>>>>>>>>>>>'+accesstoken);
    Http http = new Http();
    HttpRequest httpReq = new  HttpRequest();
    
    //christophor
    httpReq.setEndpoint('https://spoonconsultingltd3-dev-ed.develop.my.salesforce.com/services/apexrest/WS01_AccountDetails');
    //mehreen
    //httpReq.setEndpoint('https://spoonconsulting20-dev-ed.develop.my.salesforce.com/services/apexrest/WS01_ExposedWebService');
    httpReq.setMethod( 'POST' );
    httpReq.setHeader( 'Content-Type', 'application/json;charset=UTF-8' );
    httpReq.setHeader( 'Accept', 'application/json' );
    httpReq.setHeader( 'Authorization', 'Bearer ' + accesstoken );

    String body ='{"Email":"'+email+'"}';
        
    httpReq.setBody(body);

        HttpResponse response = http.send(httpReq);


        if(response.getStatusCode() == 200) {

            System.debug('Success');

            // map<string,Object> results = (map<string,Object>)JSON.deserializeUntyped(response.getBody());

            map<String, Object> resultMap = (map<String, Object>)JSON.deserializeUntyped(response.getBody());

           // map<string,Object> resultMap = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('===>'+resultMap);
            Account acc = new Account();

            acc.Id = accountId;
            acc.CustomerPriority__c = (String) resultMap.get('CustomerPriority');
            acc.Mobile__c = (String) resultMap.get('Mobile');
            acc.Rating = (String) resultMap.get('Rating');
                if(acc.Region__c != null){
                    acc.Region__c=  (String)resultMap.get('Region');
                }
            acc.SLA__c = (String) resultMap.get('SLA');
            // acc.SLAExpirationDate=resultMap.get('SLAExpirationDate');
            acc.SLASerialNumber__c = (String) resultMap.get('SLASerialNumber');
            acc.UpsellOpportunity__c = (String) resultMap.get('UpsellOpportunity');
            acc.Website = (String) resultMap.get('Website');

            Update acc;

          

        } else {
            System.debug(response.getStatusCode());
            System.debug(response.getBody());
        }
}
}