import { LightningElement, track, api } from 'lwc';
import suggestFirstnames from '@salesforce/apex/FirstnameService.suggestFirstnames';

export default class FirstnameSearch extends LightningElement {
    @track _value = '';
    @track suggestions = [];
    @track showDropdown = false;
    _debounce;

    @api
    get value() {
        return this._value;
    }
    set value(val) {
        this._value = val || '';
    }

    handleInput(event) {
        this._value = event.target.value;
        this.dispatchEvent(new CustomEvent('namechange', { detail: this._value }));

        if (this._value.length >= 3) {
            if (this._debounce) clearTimeout(this._debounce);
            this._debounce = setTimeout(() => this.fetchSuggestions(), 300);
        } else {
            this.suggestions = [];
            this.showDropdown = false;
        }
    }

    async fetchSuggestions() {
        try {
            const results = await suggestFirstnames({ searchTerm: this._value });
            this.suggestions = Array.isArray(results) ? results.slice(0, 5) : [];
            this.showDropdown = this.suggestions.length > 0;
        } catch (e) {
            this.suggestions = [];
            this.showDropdown = false;
        }
    }

    handleSelect(event) {
        this._value = event.target.textContent.trim();
        this.showDropdown = false;
        this.dispatchEvent(new CustomEvent('namechange', { detail: this._value }));
    }

    handleBlur() {
        setTimeout(() => {
            this.showDropdown = false;
            // still notify parent, parent will do capitalization
            this.dispatchEvent(new CustomEvent('namechange', { detail: this._value }));
        }, 200);
    }
}