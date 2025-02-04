/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 05-12-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   24-11-2022   Aaliyah Mohungoo   Initial Version
**/

public with sharing class AccountTriggerHandler {
    // public void handlerAfterUpdate(Map<Id,Account> mapNewAcc, Map<Id,Account> mapOldAcc) {
    //      //question 1 start
    //     // Map: AccountId et Account la so ban details
    //     Map<Id,Account> mapAcc = new Map<Id,Account>();
    //     for(Id accIdKey: mapOldAcc.keySet()){
    //         if(mapNewAcc.get(accIdKey).BillingCity != mapOldAcc.get(accIdKey).BillingCity){
    //             mapAcc.put(accIdKey, mapNewAcc.get(accIdKey));
    //         }           
    //     }
    //     if(mapAcc.size()> 0){
    //         AP01_updateRelatedOpportunities.updateOpportunities(mapAcc);
    //     }
    //     //question 1 end

    //     //question 5 start
    //     Map<Id,Account> mapAccPhone = new Map<Id,Account>();
    //     for(Id accIdKey: mapOldAcc.keySet()){
    //         if(mapNewAcc.get(accIdKey).Phone != mapOldAcc.get(accIdKey).Phone){
    //             mapAccPhone.put(accIdKey, mapNewAcc.get(accIdKey));
    //         }           
    //     }
    //     if(mapAccPhone.size()> 0){
    //         AP05_updateContactPhone.updateContactPhoneOldNew(mapAccPhone, mapOldAcc);
    //     }
    //     //question 5 end

    // }
    // public void handlerBeforeDelete(List<Account> lstOldAcc){       
    //         AP03_preventAccountDelete.preventAccDelete(lstOldAcc);        
    // }
    // public void handlerAfterInsert(List<Account> lstNewAcc){
    //     List<Account> lstAcc = new List<Account>();
    //     for(Account acc: lstNewAcc){
    //         if(acc.Industry == 'Banking'){
    //             lstAcc.add(acc);
    //         }
    //     }
    //     if(lstAcc.size()> 0){
    //     AP04_createContactForAcc.createContact(lstAcc);
    //     }
    // }
   
    // public void handlerBeforeInsert(List<Account> lstNewAcc){
    //      // question 7 start
    //     AP07_preventDuplicateAccount.preventDuplicateAccount(lstNewAcc);
    //      // question 7 end

    //     // question 9 start
    //     List<Account> lstAcc = new List<Account>();
    //     for(Account acc: lstNewAcc){
    //         if(acc.Industry == 'Education'){
    //             lstAcc.add(acc);
    //         }
    //     }
    //     if(lstAcc.size()> 0){
    //         AP09_assignOwner.assignOwnerToNishal(lstAcc);
    //     }
    //     // question 9 end 
    // }

    // question 10 
    public void handlerAfterDelete(List<Account> lstOldAcc){
        List<Account> lstAccEmail = new List<Account>();
        for(Account acc: lstOldAcc){
            if(acc.Email__c != Null){
                lstAccEmail.add(acc);
            }
        }
        if(lstAccEmail.size()>0){
            AP10_sendEmailDelete.sendEmail(lstAccEmail);
        }
    }
}