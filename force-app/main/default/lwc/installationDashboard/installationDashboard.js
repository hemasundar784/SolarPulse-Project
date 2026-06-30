import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { MessageContext, publish } from 'lightning/messageService';
import INSTALLATION_MC from '@salesforce/messageChannel/InstallationUpdateChannel__c';
import NAME_FIELD   from '@salesforce/schema/Installation__c.Name';
import STATUS_FIELD from '@salesforce/schema/Installation__c.Status__c';
export default class InstallationDashboard extends LightningElement {
    @api recordId;         
    @track isLoading = false;
    @wire(MessageContext) messageContext;  
    @wire(getRecord, { recordId: "$recordId", fields: [NAME_FIELD, STATUS_FIELD] })
    record;  
    get installationName()   { return getFieldValue(this.record.data, NAME_FIELD); }
    get installationStatus() { return getFieldValue(this.record.data, STATUS_FIELD); }
    connectedCallback() {
        console.log('[Dashboard] connectedCallback — recordId:', this.recordId);
    }
    renderedCallback() {
        console.log('[Dashboard] renderedCallback — DOM updated');
    }
    errorCallback(error, stack) {
        console.error('[Dashboard] errorCallback:', error, stack);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Component Error', message: error.message, variant: 'error'
        }));
    }
    handleRouteUpdated(event) {
        const { routeId, newStatus } = event.detail;
        publish(this.messageContext, INSTALLATION_MC, { routeId, newStatus });
        this.dispatchEvent(new ShowToastEvent({
            title: 'Route Updated',
            message: `Route ${routeId} is now ${newStatus}`,
            variant: 'success'
        }));
    }
}