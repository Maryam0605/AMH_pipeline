/**
 * @description       : 
 * @author            : AMH
 * @group             : 
 * @last modified on  : 08-14-2025
 * @last modified by  : AMH 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   08-14-2025   AMH   Initial Version
**/
public with sharing class EmailValidator {

    // HTML5-inspired regex (same as your LWC)
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
    // Validate with Mailgun API
    // -------------------------
    @AuraEnabled
    public static Map<String, Object> validateEmailWithMailgun(String email) {
        if (!isValidFormat(email)) {
            throw new AuraHandledException('Format d’email invalide (ex. prenom.nom@domaine.fr)');
        }

        // Call your existing MailgunValidateService
        return MailgunValidateService.validateEmail(email);
    }

    // -------------------------
    // Simple combined check
    // Returns Boolean + message (true = valid)
    // -------------------------
    public class ValidationResult {
        @AuraEnabled public Boolean isValid;
        @AuraEnabled public String message;
    }

    public static ValidationResult validate(String email) {
        ValidationResult result = new ValidationResult();

        if (!isValidFormat(email)) {
            result.isValid = false;
            result.message = 'Format d’email invalide (ex. prenom.nom@domaine.fr)';
            return result;
        }

        try {
            Map<String, Object> apiRes = MailgunValidateService.validateEmail(email);

            String res = ((String)apiRes.get('result') ?? '').toLowerCase();
            String risk = ((String)apiRes.get('risk') ?? '').toLowerCase();
            Boolean isBad = res == 'undeliverable' || res == 'do_not_send' || res == 'catch_all' || res == 'unknown';
            Boolean highRisk = risk == 'high';

            if ((Boolean)apiRes.get('is_valid') && !isBad && !highRisk) {
                result.isValid = true;
                result.message = 'Email valide';
            } else {
                result.isValid = false;
                result.message = buildMailgunMessageFR(apiRes);
            }

        } catch(Exception ex) {
            result.isValid = false;
            result.message = 'Erreur lors de la validation distante : ' + ex.getMessage();
        }

        return result;
    }

    // -------------------------
    // Convert Mailgun result to FR message
    // -------------------------
    private static String buildMailgunMessageFR(Map<String,Object> api) {
        if (api == null) return 'Adresse invalide selon le service de validation.';
        if (api.containsKey('did_you_mean')) return 'Adresse invalide. Vouliez-vous dire : ' + api.get('did_you_mean') + ' ?';

        String result = ((String)api.get('result') ?? '').toLowerCase();
        String risk = ((String)api.get('risk') ?? '').toLowerCase();

        if (result == 'undeliverable') return 'Adresse non distribuable selon Mailgun.';
        if (result == 'do_not_send') return 'Adresse à risque (do_not_send) selon Mailgun.';
        if (result == 'catch_all') return 'Domaine catch-all : validité incertaine.';
        if (result == 'unknown') return 'Statut inconnu : réessayez plus tard.';
        if (risk == 'high') return 'Risque élevé identifié par Mailgun.';

        if (api.containsKey('reason')) return 'Adresse invalide (' + api.get('reason') + ').';
        if (api.containsKey('reasons')) {
            List<String> reasons = (List<String>) api.get('reasons');
            if (!reasons.isEmpty()) return 'Adresse invalide (' + String.join(reasons, ', ') + ').';
        }

        return 'Cette adresse ne peut pas être validée.';
    }
}