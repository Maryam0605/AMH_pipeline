// mailgunEmailValidator.js
import { LightningElement, track, api } from 'lwc';
import validateEmailFromServer from '@salesforce/apex/MailgunValidateService.validateEmail';
import suggestCompanies from '@salesforce/apex/PappersService.suggestCompanies';

export default class MailgunEmailValidator extends LightningElement {
    @track email = '';
    @track isLoading = false;
    @track result;
    @track error;
    @track firstName = '';
    @track lastName = '';
    @track emailClass = 'email-input'; // default neutral border
    @track emailErrorMessage = '';
    @track emailMessageClass = ''; // controls text color (valid/invalid)

    /** Debounce delay in ms (configurable) */
    @api debounceDelay = 400;

    /** HTML5-inspired regex: requires at least one dot in the domain */
    emailPattern =
        "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$";

    _debounce;

@track raisonSociale = '';
    @track siret = '';

    // reçoit l'event du child
    handleCompanyChange(event) {
        const record = event.detail.record;
        if (record) {
            this.raisonSociale = record.raisonSociale;
            this.siret = record.siret;
        } else {
            this.raisonSociale = '';
            this.siret = '';
        }
    }

    // si l'utilisateur édite manuellement les inputs
    handleInputChange(event) {
        if (event.target.name === 'raisonSociale') {
            this.raisonSociale = event.target.value;
        }
        if (event.target.name === 'siret') {
            this.siret = event.target.value;
        }
    }
    // -------------------------
    // Event handlers
    // -------------------------
    handleInputChange(event) {
        const field = event.target.name;
        let value = event.target.value;

        if (field === 'firstname' || field === 'lastname') {
            value = this._capitalizeName(value);
            event.target.value = value; // update immediately
        }

        this[field] = value;
    }

    // Capitalize first letter of each word
    _capitalizeName(name) {
        if (!name) return '';
        return name
            .toLowerCase()
            .replace(/\b\p{L}/gu, match => match.toUpperCase());
    }

    handleEmailKeyup(event) {
        this.email = (event.target.value || '').trim();
        this.error = null;
        this.result = null;
        this._scheduleDebouncedValidation();
    }

    // -------------------------
    // Debounced flow
    // -------------------------
    _scheduleDebouncedValidation() {
        if (this._debounce) clearTimeout(this._debounce);
        this._debounce = setTimeout(() => this.runValidation(), this.debounceDelay);
    }

    async runValidation() {
        const input = this._emailInputEl;
        if (!input) return;

        // reset UI on each run
        input.setCustomValidity('');
        //input.reportValidity();
        this.error = null;
        this.result = null;

        if (!this.email) {
            // empty field: no API call, no error
            this.emailClass = 'email-input';
            this.emailMessageClass = '';
            this.emailErrorMessage = '';
            return;
        }

        if (!this._isEmailFormatValid(this.email)) {
            const msg = 'Format d’email invalide (ex. prenom.nom@domaine.fr)';
            this.emailClass = 'email-input invalid';
            this.emailMessageClass = 'email-text invalid';
            this.emailErrorMessage = msg;

            input.setCustomValidity(msg);
           // input.reportValidity();
            return;
        }

        await this._callMailgunValidation(input);
    }

    // -------------------------
    // Helpers (client-side)
    // -------------------------
    _isEmailFormatValid(value) {
        const regex = new RegExp(this.emailPattern);
        const isValid = regex.test(value);

        if (!value) {
            this.emailClass = 'email-input'; // neutral
            this.emailMessageClass = '';
            this.emailErrorMessage = '';
        } else if (isValid) {
            this.emailClass = 'email-input valid'; // green border
            this.emailMessageClass = 'email-text valid'; // green text
            this.emailErrorMessage = '';
        } else {
            this.emailClass = 'email-input invalid'; // red border
            this.emailMessageClass = 'email-text invalid'; // red text
            this.emailErrorMessage = 'Format d’email invalide (ex. prenom.nom@domaine.fr)';
        }

        return isValid;
    }

    get _emailInputEl() {
        return this.template.querySelector('input[data-id="email"]');
    }

    async _callMailgunValidation(input) {
        this.isLoading = true;
        try {
            const res = await validateEmailFromServer({ email: this.email });
            this.result = res;

            const resultLower = ((res && res.result) || '').toLowerCase();
            const riskLower = ((res && res.risk) || '').toLowerCase();
            const resultIsBad = ['undeliverable', 'do_not_send', 'unknown', 'catch_all'].includes(resultLower);
            const riskIsHigh = riskLower === 'high';

            const isOk = (resultLower === 'deliverable') && !riskIsHigh;

            console.log('AMH isOk ' + isOk);
            console.log('AMH resultLower ' + resultLower);
            console.log('AMH riskIsHigh ' + riskIsHigh);
            console.log('AMH riskLower ' + riskLower);

            if (isOk) {
                this.emailClass = 'email-input valid';
                this.emailMessageClass = 'email-text valid';
                this.emailErrorMessage = "L'adresse email est valide.";

                // Auto-hide success message after 3 seconds
                setTimeout(() => {
                    this.emailErrorMessage = '';
                    this.emailMessageClass = '';
                }, 3000);

                this.dispatchEvent(new CustomEvent('emailvalidated', { detail: this.email }));
            } else {
                this.emailClass = 'email-input invalid';
                this.emailMessageClass = 'email-text invalid';
                this.emailErrorMessage = this._buildMailgunMessageFR(res);
            }

            input.setCustomValidity(isOk ? "L'adresse email est valide." : this.emailErrorMessage);
            //input.reportValidity();

        } catch (err) {
            const msg = this._parseError(err) || 'Erreur lors de la validation distante. Réessayez ultérieurement.';
            this.emailClass = 'email-input invalid';
            this.emailMessageClass = 'email-text invalid';
            this.emailErrorMessage = msg;

            input.setCustomValidity(msg);
            //input.reportValidity();
        } finally {
            this.isLoading = false;
        }
    }

    _buildMailgunMessageFR(api) {
        if (!api) return 'Adresse invalide selon le service de validation.';
        if (api.did_you_mean) return `Adresse invalide. Vouliez-vous dire : ${api.did_you_mean} ?`;

        const result = ((api.result || '') + '').toLowerCase();
        const risk = ((api.risk || '') + '').toLowerCase();

        if (result === 'undeliverable') return 'Adresse non distribuable selon Mailgun.';
        if (result === 'do_not_send') return 'Adresse à risque (do_not_send) selon Mailgun.';
        if (result === 'catch_all') return 'Domaine catch-all : validité incertaine.';
        if (result === 'unknown') return 'Statut inconnu : réessayez plus tard.';
        if (result === 'deliverable') return "L'adresse email est valide.";
        if (risk === 'high') return 'Risque élevé identifié par Mailgun.';

        return 'Cette adresse ne peut pas être validée.';
    }

    _parseError(err) {
        if (!err) return null;
        if (err.body && err.body.message) return err.body.message;
        if (err.message) return err.message;
        try { return JSON.stringify(err); } catch (e) { return 'Erreur inconnue.'; }
    }

    // -------------------------
    // Cleanup
    // -------------------------
    disconnectedCallback() {
        if (this._debounce) {
            clearTimeout(this._debounce);
            this._debounce = undefined;
        }
    }
}