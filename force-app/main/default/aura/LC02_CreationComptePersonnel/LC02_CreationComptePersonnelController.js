({
    handleEmailValidation : function(component, event, helper) {
        var email = component.get("v.clientDet.clEmail");

        if (!email) {
            component.set("v.isEmailValid", false);
            component.set("v.emailMessage", "Veuillez saisir une adresse email.");
            return;
        }

        var action = component.get("c.validate"); // Apex method
        action.setParams({ email: email });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isEmailValid", result.isValid);
                component.set("v.emailMessage", result.message);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var msg = (errors && errors[0] && errors[0].message) ? errors[0].message : "Erreur inconnue.";
                component.set("v.isEmailValid", false);
                component.set("v.emailMessage", msg);
            }
        });

        $A.enqueueAction(action);
    }
})