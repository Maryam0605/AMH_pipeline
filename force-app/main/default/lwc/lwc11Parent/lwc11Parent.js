import { LightningElement, track } from 'lwc';

export default class Lwc11Parent extends LightningElement {
    @track childEmail = '';

    // Call child property directly
    getChildEmail() {
        const childCmp = this.template.querySelector('c-mailgun-email-validator');
        if (childCmp) {
            this.childEmail = childCmp.email; // Access the child email
            console.log('Child email:', this.childEmail);
        }
    }

    // Listen to custom event dispatched by child
    handleEmailValidated(event) {
        this.childEmail = event.detail; // event.detail should carry validated email
        console.log('Email validated by child:', this.childEmail);
    }
}