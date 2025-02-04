/**
 * @description       : 
 * @author            : Sambhav Bholah
 * @group             : 
 * @last modified on  : 11-21-2023
 * @last modified by  : Sambhav Bholah
**/
public with sharing class WS03_Manga {

    public static String endPointPrefix = System.label.animeChanPrefixEndpoint;

    public static Map<String, Object> fetchQuote (String characterName){
        System.debug('>> STARTS');

        Map<String, Object> mapResult = new Map<String, Object>();

        characterName = characterName.toLowerCase();

        String endPoint = endPointPrefix + '/api/random/character?name=' + characterName;
        System.debug('>> endPoint is '+ endPoint);

        try {
            Http m_http = new Http();
			HttpRequest req = new HttpRequest();

            req.setEndpoint(endPoint);
            req.setHeader('Accept', '*application/json');
			req.setHeader('Accept-Encoding', 'gzip, deflate, br');
			req.setHeader('Connection', 'keep-alive');
			req.setHeader('Content-Type', 'application/json');

            req.setMethod('GET');

            httpResponse response = m_http.send(req);

            if (response.getStatusCode() == 200) {
                System.debug('>> SBL SUCCESS');
				System.debug('>> response is' + response);
				System.debug('>> the body  : ' + response.getBody());

                AnimeResponse responseWrapper = (AnimeResponse)JSON.deserialize(response.getBody(), AnimeResponse.class);

                System.debug('>>responseWrapper ' + responseWrapper.anime);
                System.debug('>>responseWrapper character' + responseWrapper.character);
                System.debug('>>responseWrapper quote' + responseWrapper.quote);

                mapResult.put('quote', responseWrapper.quote);
            }else{
                System.debug('>> response is' + response);
				System.debug('>> the body  : ' + response.getBody());

                Map<String, Object> errorMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (errorMap.containsKey('error')) {
                    String errorMessage = (String) errorMap.get('error');
                    System.debug('Error message: ' + errorMessage);
                    mapResult.put('error', errorMessage);
                }

               

            }
        }catch(Exception e){
            mapResult.put('error', true);
			mapResult.put('error', e.getMessage());
        }

        System.debug('>> mapResult is ' + mapResult);
        return mapResult;
    }

    public class AnimeResponse {
        public String anime;
        public String character;
        public String quote;
    }
}