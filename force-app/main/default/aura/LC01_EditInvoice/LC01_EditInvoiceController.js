/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 16-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   31-10-2022   Aaliyah Mohungoo   Initial Version
**/
({
    //child fire event
    fireComponentEvent : function(cmp, event) {
        // Get the component event by using the
        // name value from aura:registerEvent
        var cmpEvent = cmp.getEvent("childEvent");
        cmpEvent.setParams({
            "invoiceRecord" : "showModel" }); // show the record of the lastest invoive in the model
        cmpEvent.fire();
    },
    //child fire event
    onSubmitEvent : function(cmp, event) {
        var cmpEvent = cmp.getEvent("childEvent");
        cmpEvent.setParams({
            "message" : "Successful" }); // the event message is succesfull
        cmpEvent.fire(); 
    },
    // to open the model
     openModel: function(component, event, helper) {
        component.set('v.showModel', true);
    },
    // to close the model
    closeModel: function(component, event, helper) {
        component.set('v.showModel', false);
    },
})