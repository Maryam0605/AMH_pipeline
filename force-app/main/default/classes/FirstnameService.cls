/**
 * @description       : 
 * @author            : AMH
 * @group             : 
 * @last modified on  : 08-26-2025
 * @last modified by  : AMH
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   08-25-2025   AMH   Initial Version
**/
public with sharing class FirstnameService {

    @AuraEnabled(cacheable=true)
    public static List<String> suggestFirstnames(String searchTerm) {
        // 🔹 Do not call ES for short terms
        if (String.isBlank(searchTerm) || searchTerm.length() < 3) {
            return new List<String>();
        }

        return callElasticsearch(searchTerm);
    }

    // -------------------------------
    // Elasticsearch Callout
    // -------------------------------
    private static List<String> callElasticsearch(String searchTerm) {
        List<String> suggestions = new List<String>();

        try {
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');

            // ✅ Remote Site Setting alias "ElasticFirstName"
            req.setEndpoint('callout:ElasticFirstName/firstnames/_search/template?filter_path=hits.hits');

            // ✅ Authentication & Headers
            //req.setHeader('Authorization', 'ApiKey aUR4WHdaZ0JjNW1wR0F3UzdWS1A6bVZrOWJjMXJvSlVzanRMWUsxRmJBQQ=='); // replace with real API key
            //req.setHeader('Content-Type', 'application/json');

            // ✅ Request Body (Elasticsearch Template)
            Map<String, Object> body = new Map<String, Object>();
            body.put('id', 'firstname_autocomplete_template');

            Map<String, Object> params = new Map<String, Object>();
            params.put('search_term', searchTerm);
            body.put('params', params);

            String bodyJson = JSON.serialize(body);
            req.setBody(bodyJson);

            // Debug request
            System.debug('=== Elasticsearch Callout ===');
            System.debug('Endpoint: ' + req.getEndpoint());
            System.debug('Body: ' + bodyJson);

            // 🔹 Send HTTP Request
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Debug response
            System.debug('Response Status: ' + res.getStatus());
            System.debug('Response Body: ' + res.getBody());

            // 🔹 Parse JSON only if status = 200
            if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                if (result.containsKey('hits')) {
                    Map<String, Object> hits = (Map<String, Object>) result.get('hits');

                    if (hits.containsKey('hits')) {
                        List<Object> hitList = (List<Object>) hits.get('hits');

                        // ✅ Take only the first 5 results
                        Integer limitSize = Math.min(hitList.size(), 5);

                        for (Integer i = 0; i < limitSize; i++) {
                            Map<String, Object> hit = (Map<String, Object>) hitList[i];

                            if (hit.containsKey('_source')) {
                                Map<String, Object> src = (Map<String, Object>) hit.get('_source');
// ✅ Use firstname_lowercase instead of name
    if (src.containsKey('firstname_lowercase')) {
        String fname = (String) src.get('firstname_lowercase');

        if (!String.isBlank(fname)) {
            suggestions.add(fname);
        }
    }
                            }
                        }
                    }
                }
            } else {
                System.debug('⚠️ Elasticsearch callout failed: '
                    + res.getStatusCode() + ' - ' + res.getBody());
            }

        } catch (Exception e) {
            System.debug('❌ Error during Elasticsearch callout: ' + e.getMessage());
        }

        return suggestions;
    }
}