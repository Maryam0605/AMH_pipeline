/**
 * @description       : 
 * @author            : Sambhav Bholah
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Sambhav Bholah
**/
public with sharing class AP11_Manga {

    public class MangaInput{
        @InvocableVariable(required=true)
      public String inputCharacter;
    }

    public class MangaOutput {
        @InvocableVariable(required=true)
        public String outputQuote;
      }

    @InvocableMethod(label='Get Manga Quote')
    public static List<MangaOutput> getMangaQuote(List<MangaInput> lstCharacterInput){
        System.debug('>> SBL getMangaQuote starts');
        System.debug('>> lstCharacterInput' + lstCharacterInput);

        List<MangaOutput> lstMangaOutput = new List<MangaOutput>();

        for (MangaInput mangaInput : lstCharacterInput) {

            
            Map<String, Object> mapResult = WS03_Manga.fetchQuote(mangaInput.inputCharacter);

            if (mapResult != null) {
                MangaOutput mangaOutput = new MangaOutput();

                if(mapResult.get('quote') != null){
                    mangaOutput.outputQuote =  (String)mapResult.get('quote');
                }else {
                    mangaOutput.outputQuote =  (String) mapResult.get('error');
                }

                lstMangaOutput.add(mangaOutput);
            }
        }

        System.debug('>> lstMangaOutput' + lstMangaOutput);
        return lstMangaOutput;
        
    }
}