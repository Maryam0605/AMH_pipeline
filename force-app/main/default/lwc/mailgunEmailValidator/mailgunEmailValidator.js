import { LightningElement, track } from 'lwc';
import validateEmail from '@salesforce/apex/MailgunValidateService.validateEmail';

export default class MailgunEmailValidator extends LightningElement {
    @track email = '';
    @track isLoading = false;
    @track result;
    @track error;

    // Computed getter for disabling the button
    get disableButton() {
        return this.isLoading || !this.email;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
        this.error = null;
        this.result = null;
    }

    async handleValidate() {
        this.error = null;
        this.result = null;

        if (!this.email) {
            this.error = 'Please enter an email address';
            return;
        }

        this.isLoading = true;
        try {
            const res = await validateEmail({ email: this.email });
            this.result = res;
        } catch (err) {
            this.error = (err && err.body && err.body.message)
                ? err.body.message
                : (err && err.message)
                    ? err.message
                    : JSON.stringify(err);
        } finally {
            this.isLoading = false;
        }
    }
}