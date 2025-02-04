/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 23-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   23-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP01_UpdateLastNameWithAccName {
    public static void updateLastNameWithAccountName(List<Contact> lstcon){

        Set<Id> setAccId = new Set<Id>();

        for(Contact conId : lstcon){
            setAccId.add(conId.AccountId);
        }

        // select account name 
        List<Contact> lstConToGetAccName = [SELECT Id, AccountId, Account.Name FROM Contact WHERE AccountId IN: setAccId];
        
        Map<Id, List<Contact>> mapAccWithContact = new Map<Id, List<Contact>>();
        // map with accountID and the related contacts (list)
        for(Contact con: lstConToGetAccName){
            if(mapAccWithContact.containsKey(con.AccountId)){
                mapAccWithContact.get(con.AccountId).add(con);
            }
            else{
                mapAccWithContact.put(con.AccountId , new List<Contact>{con});
            }
        }

        for(Contact newCon: lstcon){
        for(Id accKey: mapAccWithContact.keySet()){            
                newCon.LastName = mapAccWithContact.get(accKey)[0].Account.Name + ((mapAccWithContact.get(accKey).size())+1);
            }
        }

    }
}