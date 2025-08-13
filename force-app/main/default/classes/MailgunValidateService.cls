/**
 * @description       : 
 * @author            : AMH
 * @group             : 
 * @last modified on  : 08-11-2025
 * @last modified by  : AMH
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   08-11-2025   AMH   Initial Version
**/
// MailgunValidateService.cls
public with sharing class MailgunValidateService {
    // Named Credential name (prefix with callout:)
    private static final String NAMED_CRED = 'callout:Mailgun_Validate';

    @AuraEnabled(cacheable=false)
    public static Map<String,Object> validateEmail(String email) {
        if (String.isBlank(email)) {
            throw new AuraHandledException('Email is required');
        }
        //build endpoint (provider_lookup=true gives provider checks)
        // String endpoint = NAMED_CRED + '/v4/address/validate?address=' 
        //                   + EncodingUtil.urlEncode(email, 'UTF-8')
        //                   + '&provider_lookup=true';
        String endpoint = 'callout:Mailgun_Validate/v4/address/validate?address='
    + EncodingUtil.urlEncode(email, 'UTF-8')
    + '&provider_lookup=true';


        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(120000);

        try {
            HttpResponse res = http.send(req);
            Integer status = res.getStatusCode();
            if (status == 200) {
                // parse JSON body into a Map
                Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                // return parsed mailgun object directly
                return parsed;
            } else {
                // surface api error
                String body = res.getBody();
                throw new AuraHandledException('Mailgun returned status ' + status + ': ' + body);
            }
        } catch (System.CalloutException ex) {
            throw new AuraHandledException('Callout error: ' + ex.getMessage());
        }
    }
}