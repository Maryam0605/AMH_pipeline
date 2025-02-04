/**
 * @File Name          : <CaseTrigger>.trigger
 * @Description        : <Create a trigger after update CASE 1: As an agent, i want an invoice to be created
 *                       after a claim has been processed so as to issue payment to the customer>
 * @Author             : <Spoon Consulting>
 * @Group              :
 * @Last Modified By   : Aaliyah Mohungoo
 * @Last Modified On   : 21-11-2022
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      Modification
 *==============================================================================
 * 1.0    25-10-2022                    <AMO>      Initial Version
 **/
trigger CaseTrigger on Case(after update, before insert, before update) {
    CaseTriggerHandler handler = new CaseTriggerHandler();
    if (Trigger.isAfter && Trigger.isUpdate) {
        handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.handleBeforeInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        handler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
    }

}