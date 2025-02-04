/**
 * @description       :
 * @author            : Aaliyah Mohungoo
 * @group             :
 * @last modified on  : 23-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   11-11-2022   Aaliyah Mohungoo   Initial Version
 **/
public with sharing class ContactTriggerHandler {
  public void handleBeforeInsert(List<Contact> lstNewCon) {
    List<Contact> lstCon = new List<Contact>();
    
    for (Contact con : lstNewCon) {
      lstCon.add(con);
  
    }
    if (lstCon.size() > 0) {
        AP01_UpdateLastNameWithAccName.updateLastNameWithAccountName(lstCon);
    }
  }
}