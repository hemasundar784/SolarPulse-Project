import { LightningElement, api, wire } from 'lwc';
import getInstallations from '@salesforce/apex/CustomerWorkspaceController.getInstallations';

export default class InstallationListPanel extends LightningElement {
    @api accountId;

    columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Manager', fieldName: 'Assigned_Manager__c' },
    { label: 'Contract Value', fieldName: 'Contract_Value__c', type: 'currency' },
    { label: 'Panel Count', fieldName: 'Panel_Count__c', type: 'number' },
    { label: 'Region', fieldName: 'Region__c' },
    { label: 'Scheduled Date', fieldName: 'Scheduled_Date__c', type: 'date' },
    { label: 'Deadline', fieldName: 'Deadline_Date__c', type: 'date' },
    { label: 'Days to Deadline', fieldName: 'Days_to_Deadline__c', type: 'number' },
    { label: 'Total Routes', fieldName: 'Total_Routes__c', type: 'number' },
    { label: 'Model', fieldName: 'Solar_Panel_Model__c' }
    ];


    @wire(getInstallations, { accountId: '$accountId' })
    installations;
}
