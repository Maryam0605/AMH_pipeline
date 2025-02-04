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
import { api, LightningElement ,wire} from 'lwc';
import findVehicles from '@salesforce/apex/AP01_DisplayVehicle.findVehicles';

export default class TestLWC extends LightningElement {
    @api recordId 
    @wire(findVehicles, {Id:'$recordId'}) vehicles;
    get aaliyah()
    {
    console.log(this.vehicles.data);
    }
}