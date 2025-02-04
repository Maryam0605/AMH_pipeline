/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   03-11-2022   Aaliyah Mohungoo   Initial Version
**/
import { LightningElement ,api} from 'lwc';
import findVehicles from '@salesforce/apex/AP01_DisplayVehicle.findVehicles';
export default class Lwc01viewcase extends LightningElement {
    @api recordId 
    @api vehicles=[]; 
        connectedCallback(){
            console.log("connected call back");
            // pass the variable recordId and store the results in vehicle
            findVehicles({recordId: this.recordId}).then((result) => {
                this.vehicles = result;
                console.log(this.vehicles); // check the list
            // catch ERROR
            }).catch(error => {
                console.log('Error: ' + error);
            });        
        }
 }