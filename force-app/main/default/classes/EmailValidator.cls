/**
 * @description       : 
 * @author            : AMH
 * @group             : 
 * @last modified on  : 08-19-2025
 * @last modified by  : AMH 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   08-19-2025   AMH   Initial Version
**/
public with sharing class EmailValidator {

    private static final String EMAIL_REGEX = 
        '^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$';

    // -------------------------
    // Validate format only
    // -------------------------
    public static Boolean isValidFormat(String email) {
        if (String.isBlank(email)) return false;
        Pattern p = Pattern.compile(EMAIL_REGEX);
        Matcher m = p.matcher(email);
        return m.matches();
    }

    // -------------------------
    // Validation result wrapper
    // -------------------------
    public class ValidationResult {
        @AuraEnabled public Boolean isValid;
        @AuraEnabled public String message;
    }

    // -------------------------
    // Combined validation
    // -------------------------
    @AuraEnabled
    public static ValidationResult validate(String email) {
        ValidationResult vr = new ValidationResult();

        if (!isValidFormat(email)) {
            vr.isValid = false;
            vr.message = 'Format d’email invalide (ex. prenom.nom@domaine.fr)';
            return vr;
        }

        try {
            Map<String, Object> apiRes = MailgunValidateService.validateEmail(email);

            // Extract fields safely
            String res = apiRes.containsKey('result') && apiRes.get('result') != null 
                ? String.valueOf(apiRes.get('result')).toLowerCase() 
                : '';
            String risk = apiRes.containsKey('risk') && apiRes.get('risk') != null 
                ? String.valueOf(apiRes.get('risk')).toLowerCase() 
                : '';

            Boolean riskIsHigh = 'high'.equalsIgnoreCase(risk);
            Boolean isOk = 'deliverable'.equalsIgnoreCase(res) && !riskIsHigh;

            if (isOk) {
                vr.isValid = true;
                vr.message = 'L\'adresse email est valide.';
            } else {
                vr.isValid = false;
                vr.message = buildMailgunMessageFR(apiRes);
            }

        } catch (Exception ex) {
            vr.isValid = false;
            vr.message = 'Erreur lors de la validation distante : ' + ex.getMessage();
        }

        return vr;
    }

    // -------------------------
    // Convert Mailgun result to FR message
    // -------------------------
    private static String buildMailgunMessageFR(Map<String,Object> api) {
        if (api == null) return 'Adresse invalide selon le service de validation.';

        if (api.containsKey('did_you_mean') && api.get('did_you_mean') != null) {
            return 'Adresse invalide. Vouliez-vous dire : ' + String.valueOf(api.get('did_you_mean')) + ' ?';
        }

        String result = api.containsKey('result') && api.get('result') != null 
            ? String.valueOf(api.get('result')).toLowerCase() 
            : '';
        String risk = api.containsKey('risk') && api.get('risk') != null 
            ? String.valueOf(api.get('risk')).toLowerCase() 
            : '';

        if ('undeliverable'.equalsIgnoreCase(result)) return 'Adresse non distribuable selon Mailgun.';
        if ('do_not_send'.equalsIgnoreCase(result)) return 'Adresse à risque (do_not_send) selon Mailgun.';
        if ('catch_all'.equalsIgnoreCase(result)) return 'Domaine catch-all : validité incertaine.';
        if ('unknown'.equalsIgnoreCase(result)) return 'Statut inconnu : réessayez plus tard.';
        if ('deliverable'.equalsIgnoreCase(result)) return 'L\'adresse email est valide.';
        if ('high'.equalsIgnoreCase(risk)) return 'Risque élevé identifié par Mailgun.';

        return 'Cette adresse ne peut pas être validée.';
    }
}