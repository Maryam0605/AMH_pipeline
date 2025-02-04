/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 11-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   11-11-2022   Aaliyah Mohungoo   Initial Version
**/
trigger ContactTrigger on Contact (before insert) {
    ContactTriggerHandler handler = new ContactTriggerHandler();
    if (Trigger.isbefore && Trigger.isInsert) {
        handler.handleBeforeInsert(
          Trigger.new
        );
      }

}