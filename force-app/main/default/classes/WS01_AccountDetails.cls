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
// expose web service for me
// tibiz
@RestResource(urlMapping='/WS01_AccountDetails')
global with sharing class WS01_AccountDetails {
  @HttpPost
  global static Map<String,String> sendAccountInfo() {

    List<Account> lstAcc  = new List<Account>();
    Map<String,String> resultmap = new map <String,String>();

    //Gnr body
    RestRequest request = RestContext.request;

    // fr li vinne un string
    String body = request.requestBody.toString();
    // deserialize fr li vinne un map
    Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
      body
    );
    // check if email from map is not null 
    String email = params.get('Email') != null
      ? String.valueOf(params.get('Email')) // get value of email la
      : null;

    try {
        if (email != null) {
          lstAcc = [SELECT
                      Email__c,
                      Rating,
                      CustomerPriority__c,
                      Mobile__c,
                      Region__c,
                      SLA__c,
                      SLAExpirationDate__c,
                      SLASerialNumber__c,
                      UpsellOpportunity__c,
                      Website
                    FROM Account
                    WHERE Email__c = :email
                  ];
          resultmap = new Map<String,String>{
            'Email' => lstAcc[0].Email__c,
                    'Rating' => lstAcc[0].Rating,
                    'CustomerPriority' => lstAcc[0].CustomerPriority__c,
                    'Mobile' => lstAcc[0].Mobile__c,
                    'SLA' => lstAcc[0].SLA__c,
                    'SLAExpirationDate' => String.valueOf(lstAcc[0].SLAExpirationDate__c),
                    'SLASerialNumber' => lstAcc[0].SLASerialNumber__c,
                    'UpsellOpportunity' => lstAcc[0].UpsellOpportunity__c,
                    'Website' => lstAcc[0].Website
           };
        }
    }catch(Exception e){
        system.debug('error' + e);
    }
  
    return resultmap;
  }
}