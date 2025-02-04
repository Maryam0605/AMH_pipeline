/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 08-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   08-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP02_AccountUpdate {
    /**
         * USE CASE 2
         * @description Find all accounts having a case and display by recordType.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Output: One map with two keys, one for each recordType
         **/
        public static Map<String,List<Account>> accountCase(){
            // Get all the account having a case
            List<Case> lstcas = [SELECT AccountId FROM Case WHERE AccountId != Null];
            // An account can have multiple case so put into a SET to remove duplicate
            Set<String> setId = new Set<String>();
            // Loop throught the list and insert into the SET
            for (Case cas : lstcas) {                
                setId.add(cas.AccountId);
            }
            // Now create a list to select the name from account where the ID is equal to the id in the SET
            List<Account> lstAcc = [SELECT Name ,RecordType.DeveloperName, RecordTypeId FROM Account WHERE Id IN: setId AND RecordTypeId != NULL];
            System.debug(lstAcc);
            // Create the Map
            Map<String,List<Account>> mapAccount = new Map<String,List<Account>>();
            // Loop throught list and check if the record type already exist 
            for (Account acc : lstAcc) { 
                // If yes add an account to it.
                if(mapAccount.containsKey(acc.RecordType.DeveloperName)){
                    mapAccount.get(acc.RecordType.DeveloperName).add(acc);
                }
                // else create a new account for that record type
                else{
                    mapAccount.put(acc.RecordType.DeveloperName, new List<Account>{acc});
                }   

            }
            if(mapAccount.size() > 0){
                System.debug('Map Account: ' + mapAccount);
            }           
            return mapAccount;
        }
}