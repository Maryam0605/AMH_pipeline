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
trigger AccountTrigger on Account (after update, before delete, after insert, before insert, after delete) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    // if(Trigger.isAfter && Trigger.isUpdate){
    //     handler.handlerAfterUpdate(Trigger.newMap,Trigger.oldMap);
    // }
    // if(Trigger.isBefore && Trigger.isDelete){
    //     handler.handlerBeforeDelete(Trigger.old);
    // }
    // if(Trigger.isAfter && Trigger.isInsert){
    //     handler.handlerAfterInsert(Trigger.new);
    // }
    // if(Trigger.isBefore && Trigger.isInsert){
    //     handler.handlerBeforeInsert(Trigger.new);
    // }
    if(Trigger.isAfter && Trigger.isDelete){
        handler.handlerAfterDelete(Trigger.old);
    }

}