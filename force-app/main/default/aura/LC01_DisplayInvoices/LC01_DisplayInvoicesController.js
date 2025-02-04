/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 16-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   28-10-2022   Aaliyah Mohungoo   Initial Version
**/
({
    doInit: function(component, event, helper) {
        var action = component.get("c.getInvoice"); // call apex class 
        
        action.setParams({
            "caseId" : component.get("v.recordId") // give the record Id
        });

        action.setCallback(this, function(response){
            var state = response.getState(); // get the status if success or error
            if(state === "SUCCESS"){
                let returnedInvoices = response.getReturnValue(); //store the respnse value in returnedinvoices
                component.set('v.latestInvoice', returnedInvoices[0]); //for lastest editable pop up
                if(returnedInvoices.length > 1){
                 //   component.set('v.listInvoices', returnedInvoices.slice(1,returnedInvoices.length));
                 component.set('v.listInvoices', returnedInvoices); // to display list
                }
            }
            else if (state === "ERROR"){
                console.log("Error");
            }
        });
        $A.enqueueAction(action); // queues up actions before sending them to the server to minimize network traffic by batching multiple actions into one request
    },
   
    handleChildEvent: function(component, event, helper){
        var message = event.getParam('message');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": message
        });
        toastEvent.fire();
    }
})