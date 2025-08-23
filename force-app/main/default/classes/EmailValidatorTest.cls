/**
 * @description       : 
 * @author            : AMH
 * @group             : 
 * @last modified on  : 08-22-2025
 * @last modified by  : AMH 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   08-22-2025   AMH   Initial Version
**/
@IsTest
private class EmailValidatorTest {

    private class MailgunValidateMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');

            String endpoint = req.getEndpoint();
            String email = '';
            if (endpoint.contains('address=')) {
                email = endpoint.substringAfter('address=').substringBefore('&');
                email = EncodingUtil.urlDecode(email, 'UTF-8');
            }

            if (email == 'good@email.com') {
                res.setBody('{"result":"deliverable","risk":"low"}');
                res.setStatusCode(200);
            } else if (email == 'typo@email.cm') {
                res.setBody('{"result":"undeliverable","risk":"low","did_you_mean":"typo@email.com"}');
                res.setStatusCode(200);
            } else if (email == 'risky@email.com') {
                // Realistic Mailgun response for disposable burner mail
                res.setBody('{"address":"alias@burnermail.io","engagement":{"engaging":false,"is_bot":false},"is_disposable_address":true,"is_role_address":false,"reason":["mailbox_is_disposable_address"],"result":"do_not_send","risk":"high"}');
                res.setStatusCode(200);
            } else if (email == 'catchall@email.com') {
                res.setBody('{"result":"catch_all","risk":"low"}');
                res.setStatusCode(200);
            } else if (email == 'donotsend@email.com') {
                res.setBody('{"result":"do_not_send","risk":"low"}');
                res.setStatusCode(200);
            } else if (email == 'unknown@email.com') {
                res.setBody('{"result":"unknown","risk":"low"}');
                res.setStatusCode(200);
            } else {
                res.setBody('{"message":"Internal Error"}');
                res.setStatusCode(500);
            }
            return res;
        }
    }

    @IsTest
    static void testValidEmail() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('good@email.com');
        System.assertEquals(true, vr.isValid);
        System.assertEquals('L\'adresse email est valide.', vr.message);
    }

    @IsTest
    static void testUndeliverableWithSuggestion() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('typo@email.cm');
        System.assertEquals(false, vr.isValid);
        System.assert(vr.message.contains('Vouliez-vous dire'));
    }

    @IsTest
    static void testRiskHighDisposable() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('risky@email.com');
        System.assertEquals(false, vr.isValid);
        // Expect do_not_send message, because buildMailgunMessageFR checks that first
        System.assertEquals('Adresse à risque (do_not_send) selon Mailgun.', vr.message);
    }

    @IsTest
    static void testCatchAll() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('catchall@email.com');
        System.assertEquals(false, vr.isValid);
        System.assertEquals('Domaine catch-all : validité incertaine.', vr.message);
    }

    @IsTest
    static void testDoNotSend() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('donotsend@email.com');
        System.assertEquals(false, vr.isValid);
        System.assertEquals('Adresse à risque (do_not_send) selon Mailgun.', vr.message);
    }

    @IsTest
    static void testUnknown() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('unknown@email.com');
        System.assertEquals(false, vr.isValid);
        System.assertEquals('Statut inconnu : réessayez plus tard.', vr.message);
    }

    @IsTest
    static void testFormatInvalid() {
        EmailValidator.ValidationResult vr = EmailValidator.validate('bad-email-format');
        System.assertEquals(false, vr.isValid);
        System.assert(vr.message.contains('Format d’email invalide'));
    }

    @IsTest
    static void testApiError() {
        Test.setMock(HttpCalloutMock.class, new MailgunValidateMock());
        EmailValidator.ValidationResult vr = EmailValidator.validate('error@email.com');
        System.assertEquals(false, vr.isValid);
        System.assert(vr.message.startsWith('Erreur lors de la validation distante'));
    }
}