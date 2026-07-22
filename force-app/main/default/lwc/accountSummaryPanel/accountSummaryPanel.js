import { LightningElement, api } from 'lwc';

export default class AccountSummaryPanel extends LightningElement {
    @api accountId;
    fields = [
        'Id', 'AccountNumber', 'Rating', 'Phone',
        'Name', 'email__c','totalContacts__c','BillingState', 'BillingCity', 'BillingPostalCode', 'BillingStreet','Models__c','Panels__c','Total_Cost__c','Area_Sq_feet__c'
    ];
}
