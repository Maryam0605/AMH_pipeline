/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 14-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   14-11-2022   Aaliyah Mohungoo   Initial Version
**/
@RestResource(urlMapping='/WS01_CreateAccount')
global without sharing class WS01_CreateAccount {
    
    @HttpPost
    global static Map<String,String> sendAccountInfo (){
        
        Map<String,String> resultmap = new map <String,String>();
        list<Account> accLst = new list<Account>();
        
        RestRequest req = RestContext.request;

        String body = req.requestBody.toString();
        Map<String, Object> params =  (Map<String, Object>)JSON.deserializeUntyped(body);
        
        String fullName = params.get('Name') != null ? String.valueOf(params.get('Name')) : null;
        String region = params.get('Region') != null ? String.valueOf(params.get('Region')) : null;  
        String  BillingStreet = params.get('BillingStreet') != null ? String.valueOf(params.get('BillingStreet')) : null;
        String  BillingCity = params.get('BillingCity') != null ? String.valueOf(params.get('BillingCity')) : null;  
        String   BillingCountry = params.get('BillingCountry') != null ? String.valueOf(params.get('BillingCountry')) : null;
            
        if(fullName == null){
            resultmap = new Map<String,String>{'error' => 'Name is null'};
        }
        else if(region == null){
            resultmap = new Map<String,String>{'error' => 'Region is null'};
        }
        else {
            Account ac = new Account (Name = fullName, region__c = region, BillingStreet=BillingStreet, BillingCity=BillingCity, BillingCountry=BillingCountry);
            accLst.add(ac);
            insert accLst;
            resultmap = new Map<String,String>{'success' => 'Account was properly created, Id: ' + accLst[0].Id };
        }
        return resultmap;
    }
}