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
public with sharing class PappersService {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> suggestCompanies(String searchTerm) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PappersAPI/v2?q=' + EncodingUtil.urlEncode(searchTerm, 'UTF-8') + 
                        '&longueur=5&cibles=nom_entreprise,siren');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);

        List<Map<String, String>> suggestions = new List<Map<String, String>>();
        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            if (result.containsKey('resultats')) {
                for (Object comp : (List<Object>) result.get('resultats')) {
                    Map<String, Object> company = (Map<String, Object>) comp;
                    Map<String, String> record = new Map<String, String>();
                    record.put('raisonSociale', (String) company.get('nom_entreprise'));
                    record.put('siret', (String) company.get('siren'));
                    suggestions.add(record);
                }
            }
        }
        return suggestions;
    }
}