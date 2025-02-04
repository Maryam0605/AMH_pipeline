/**
 * @File Name          : <CaseTrigger>.trigger
 * @Description        : <As a customer i should receive an email (contact email) when my invoice is created
                            The email subject should be ‘Ti Vitesse: Invoice-<<invoice number>>’
                            The email content should contain the following details:
                            Price including VAT
                            Case type
                            Case reason
                            Last Payment date
                            vehicle registration numbe
>
 * @Author             : <Spoon Consulting>
 * @Group              : 
 * @Last Modified By   : Aaliyah Mohungoo
 * @Last Modified On   : 26-10-2022
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      Modification
 *==============================================================================
 * 1.0    25-10-2022                    <AMO>      Initial Version
**/
trigger InvoiceTrigger on Invoice__c(after insert, before delete) {
    InvoiceTriggerHandler handler = new InvoiceTriggerHandler();
    if (Trigger.isAfter && Trigger.isInsert) {
        handler.handleAfterInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isDelete) {
        handler.handleBeforeDelete(Trigger.old);
    }

}