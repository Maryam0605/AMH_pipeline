/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 20-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   17-11-2022   Aaliyah Mohungoo   Initial Version
**/
import { LightningElement,api } from 'lwc';
import loanVehicles from '@salesforce/apex/LWC01_retrieveVehicleDetails.loanVehicles';
import CustomerVehicles from '@salesforce/apex/LWC01_retrieveVehicleDetails.CustomerVehicles';
import removeLoanStatus from '@salesforce/apex/LWC01_terminateLoanUS2.removeLoanStatus';

export default class Lwc01DisplayDetails extends LightningElement {
    @api recordId 
    // loan vehicle
    loanvehicles=[]; 
    // customer vehicle
    customervehicles=[]; 
    endLoan;
    buttondisabled = false;

    connectedCallback(){

            console.log('CC button Disable: ', this.buttondisabled);
            console.log("connected call loaned back");
            // pass the variable recordId and store the results in vehicle
            loanVehicles({loanId: this.recordId}).then((result) => {
                this.loanvehicles =result;
                console.log(this.loanvehicles); // check the loan list
                if(this.loanvehicles[0].LoanedVehicle__c !== '' && this.loanvehicles[0].LoanedVehicle__r.status__c === 'available')
                {
                    this.buttondisabled = true; 
                }
            // catch ERROR
            }).catch(error => {
                console.log('Error: ' + error);
            });        
           

            console.log("connected call customer back");
            CustomerVehicles({cusId: this.recordId}).then((result1) => {
                this.customervehicles =result1;
                console.log(this.CustomerVehicles); // check the customer list
            // catch ERROR
            }).catch(error => {
                console.log('Error: ' + error);
            });             
            window.addEventListener('handleclick', this.handleContactClick);
    }
    handleContactClick = (evt) => {  
    this.buttondisabled = true; 
            
    removeLoanStatus({caseid: this.recordId}).then((result) => {
        // this.endLoan = evt.detail;
        // console.log('this.endLoan : ', this.endLoan);
         // window.location.reload();
         console.log('DD button Disable: ', this.buttondisabled) ;
        }).catch(error => {
            console.log('Error: ' + error);
        });        
    }   
       
}