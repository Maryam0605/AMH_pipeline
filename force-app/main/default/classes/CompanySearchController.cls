/**
 * @description       : 
 * @author            : AMH
 * @group             : 
 * @last modified on  : 08-22-2025
 * @last modified by  : AMH
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   08-22-2025   AMH   Initial Version
**/
public with sharing class CompanySearchController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> searchCompany(String searchStr) {
        HttpRequest req = new HttpRequest();
        // ⚠️ Make sure you configured a Named Credential "PappersAPI" with the base URL + API key
        req.setEndpoint('callout:PappersAPI/v2?q=' + EncodingUtil.urlEncode(searchStr, 'UTF-8') + 
                        '&longueur=5&cibles=nom_entreprise,siren');
        req.setMethod('GET');
        
        
System.debug('>>> Full URL: ' + req.getEndpoint());
System.debug('>>> Headers: ' + req.getHeader('Authorization'));
System.debug('>>> Body: ' + req.getBody());

        Http http = new Http();
        HttpResponse res = http.send(req);

        List<Map<String, String>> suggestions = new List<Map<String, String>>();

        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            // ✅ FIX: The data is inside "resultats_nom_entreprise"
            if (result.containsKey('resultats_nom_entreprise')) {
                for (Object comp : (List<Object>) result.get('resultats_nom_entreprise')) {
                    Map<String, Object> company = (Map<String, Object>) comp;

                    Map<String, String> record = new Map<String, String>();
                    // Use "mention" (highlighted name) for display
                    //record.put('raisonSociale', (String) company.get('mention'));
                    String rawMention = (String) company.get('mention');
                    String cleanMention = rawMention != null 
                        ? rawMention.replaceAll('<[^>]+>', '') 
                        : '';
                    record.put('raisonSociale', cleanMention);
                    // Use siren (or SIRET inside "siege")
                    record.put('siret', (String) company.get('siren'));

                    suggestions.add(record);
                }
            }
        } else {
            System.debug('❌ Error from Pappers API: ' + res.getStatusCode() + ' - ' + res.getBody());
        }
        return suggestions;
    }
}