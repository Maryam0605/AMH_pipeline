/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-11-2022   Aaliyah Mohungoo   Initial Version
**/
import { LightningElement,api } from 'lwc';

import displayListVehicles from '@salesforce/apex/LWC01_displayListVehicles.displayListVehicles';

export default class VehicleItem extends LightningElement {
    @api cId 
    @api vehicles; 
        connectedCallback(){
            console.log("connected call back");
            // pass the variable recordId and store the results in vehicle
            displayListVehicles({contactId: this.cId}).then((result) => {
                this.vehicles =result;
                console.log(this.vehicles); // check the list
            // catch ERROR
            }).catch(error => {
                console.log('Error: ' + error);
            });        
        }
        activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
}