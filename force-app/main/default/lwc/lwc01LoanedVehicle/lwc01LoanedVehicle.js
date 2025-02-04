/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 22-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   18-11-2022   Aaliyah Mohungoo   Initial Version
**/
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement ,api} from 'lwc';

export default class Lwc01LoanedVehicle extends LightningElement {
    @api loan;
    @api changeColorToRed = ' ';  
    @api buttondisable;
    clickedButtonTerminate;

    


    connectedCallback(){
        var dateToday = new Date(); // date
        var insuranceEndDate = new Date(this.loan.LoanedVehicle__r.LoanEndDate__c);
        var differenceInTime = insuranceEndDate.getTime() - dateToday.getTime();
        var differenceInDay = differenceInTime/(3600*1000*24);
        if(differenceInDay < 3){
            this.changeColorToRed = 'background: red;';
        }       
    }
    handleClick(){
        const event = new CustomEvent('handleclick', {
            // detail contains only primitives
            detail: 'endloan',
            bubbles: true,
            composed:true
        });
        // Fire the event from c-tile
        this.dispatchEvent(event);
    }
}