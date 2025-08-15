// mailgunEmailValidator.js
import { LightningElement, track, api } from 'lwc';
import validateEmailFromServer from '@salesforce/apex/MailgunValidateService.validateEmail';

export default class MailgunEmailValidator extends LightningElement {
    @track email = '';
    @track isLoading = false;
    @track result;
    @track error;
    @track showValidIcon = false;
    @track showInvalidIcon = false;
    @track firstName = '';
    @track lastName = '';

    
    /** Debounce delay in ms (configurable) */
    @api debounceDelay = 400;

    /** HTML5-inspired regex: requires at least one dot in the domain */
    emailPattern =
        "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$";

    _debounce;

    // -------------------------
    // Event handlers
    // -------------------------

    handleNameBlur(event) {
    const field = event.target.name; // "firstname" or "lastname"
    let value = event.target.value || '';

    // Capitalize first letter of each word
    value = this._capitalizeName(value);

    // Update both the input and the tracked property
    event.target.value = value;
    this[field] = value;
}


    handleInputChange(event) {
    const field = event.target.name;
    let value = event.target.value;

    if (field === 'firstname' || field === 'lastname') {
        value = this._capitalizeName(value);
        // Update the input's value immediately to reflect capitalization
        event.target.value = value;
    }

    this[field] = value;
}


    // Capitalize first letter of each word, support accented letters
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
        input.reportValidity();
        this.error = null;
        this.result = null;

        if (!this.email) {
            // empty field: no API call, no error
            return;
        }

        if (!this._isEmailFormatValid(this.email)) {
            const msg = 'Format d’email invalide (ex. prenom.nom@domaine.fr)';
            input.setCustomValidity(msg);
            input.reportValidity();
            return;
        }

        await this._callMailgunValidation(input);
    }

    // -------------------------
    // Helpers (client-side)
    // -------------------------
    // _isEmailFormatValid(value) {
    //     const regex = new RegExp(this.emailPattern);
    //     return regex.test(value);
    // }
    _isEmailFormatValid(value) {
        const regex = new RegExp(this.emailPattern);
        const isValid = regex.test(value);
        this.showValidIcon = isValid; 
        this.showInvalidIcon = !isValid && value.length > 0;
        return isValid;
    }

    get _emailInputEl() {
        return this.template.querySelector('lightning-input[data-id="email"]');
    }

    // -------------------------
    // Server call + result handling
    // -------------------------
    // async _callMailgunValidation(input) {
    //     this.isLoading = true;
    //     try {
    //         const res = await validateEmailFromServer({ email: this.email });
    //         this.result = res;

    //         // Derive validity from Mailgun result (practical rules)
    //         const resultLower = ((res && res.result) || '').toLowerCase();
    //         const riskLower = ((res && res.risk) || '').toLowerCase();
    //         const resultIsBad = ['undeliverable', 'do_not_send', 'unknown', 'catch_all'].includes(resultLower);
    //         const riskIsHigh = riskLower === 'high';

    //         const isOk = (res && res.is_valid === true) && !resultIsBad && !riskIsHigh;

    //         if (isOk) {
    //             input.setCustomValidity('');
    //         } else {
    //             input.setCustomValidity(this._buildMailgunMessageFR(res));
    //         }
    //         input.reportValidity();
    //     } catch (err) {
    //         const msg = this._parseError(err) ||
    //             'Erreur lors de la validation distante. Réessayez ultérieurement.';
    //         this.error = msg;
    //         input.setCustomValidity(msg);
    //         input.reportValidity();
    //     } finally {
    //         this.isLoading = false;
    //     }
    // }
    async _callMailgunValidation(input) {
        this.isLoading = true;
        try {
            const res = await validateEmailFromServer({ email: this.email });
            this.result = res;

            const resultLower = ((res && res.result) || '').toLowerCase();
            const riskLower = ((res && res.risk) || '').toLowerCase();
            const resultIsBad = ['undeliverable', 'do_not_send', 'unknown', 'catch_all'].includes(resultLower);
            const riskIsHigh = riskLower === 'high';

            const isOk = (res && res.is_valid === true) && !resultIsBad && !riskIsHigh;

            this.showValidIcon = isOk;
            this.showInvalidIcon = !isOk;

            if (isOk) {
                input.setCustomValidity('');
                    // Dispatch event to parent with the validated email
    this.dispatchEvent(
        new CustomEvent('emailvalidated', { detail: this.email })
    );
            } else {
                input.setCustomValidity(this._buildMailgunMessageFR(res));
            }
            input.reportValidity();
        } catch (err) {
            const msg = this._parseError(err) ||
                'Erreur lors de la validation distante. Réessayez ultérieurement.';
            this.error = msg;
            this.showValidIcon = false;
            this.showInvalidIcon = true;
            input.setCustomValidity(msg);
            input.reportValidity();
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
        if (risk === 'high') return 'Risque élevé identifié par Mailgun.';

        if (api.reason) return `Adresse invalide (${api.reason}).`;
        if (api.reasons && Array.isArray(api.reasons) && api.reasons.length) {
            return `Adresse invalide (${api.reasons.join(', ')}).`;
        }
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