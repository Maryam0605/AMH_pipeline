import { LightningElement, api } from "lwc";
import searchCompany from "@salesforce/apex/CompanySearchController.searchCompany";

export default class LwcCompanySearch extends LightningElement {
    //@api title = "Recherche Entreprise";
   // @api label = "Tapez une raison sociale ou un SIRET";
    @api styles = "background-color: #FFFFFF;border-radius: 0.25rem;padding: 1rem;border: 1px solid rgb(221, 219, 218);";
    @api titleStyle;
    @api labelStyle;
    @api disabled = false;

    searchStr;
    companyLst;
    displayCompanyLst = false;
    selectedCompany;

    handleKeyUp(event) {
        this.searchStr = event.target.value;
        window.clearTimeout(this.delayTimeout);
        if (this.searchStr.length >= 2) {
            this.delayTimeout = setTimeout(() => {
                this.doSearch(this.searchStr);
            }, 400);
        } else {
            this.displayCompanyLst = false;
        }
    }

    doSearch(strSearch) {
        searchCompany({ searchStr: strSearch })
            .then((result) => {
                this.companyLst = result;
                this.displayCompanyLst = result && result.length > 0;
            })
            .catch((error) => {
                console.error("Erreur recherche société:", error);
                this.companyLst = [];
                this.displayCompanyLst = false;
            });
    }

    handleOptionSelect(event) {
        const selectedSiret = event.currentTarget.dataset.id;
        this.selectedCompany = this.companyLst.find((c) => c.siret === selectedSiret);
        this.searchStr = this.selectedCompany.raisonSociale;
        this.displayCompanyLst = false;

        // Dispatch event vers parent (Aura ou autre LWC)
        this.dispatchEvent(new CustomEvent("companychange", {
            detail: { record: this.selectedCompany }
        }));
    }

    handleRemoveSelectedOption() {
        this.searchStr = "";
        this.selectedCompany = undefined;
        this.displayCompanyLst = false;
        this.dispatchEvent(new CustomEvent("companychange", { detail: { record: null } }));
    }
}