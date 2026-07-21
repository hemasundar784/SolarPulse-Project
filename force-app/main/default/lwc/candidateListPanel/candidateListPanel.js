import { LightningElement, wire } from 'lwc';
import getCandidates from '@salesforce/apex/CustomerWorkspaceController.getCandidates';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';

export default class CandidateListPanel extends LightningElement {
    @wire(CurrentPageReference) pageRef;

    allCandidates = [];
    filteredData = [];

    /** Datatable columns */
    tableColumns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Panel Model', fieldName: 'Solar_Panel_Model__c' },
        { label: 'Region', fieldName: 'Region__c', type: 'text' },
        { label: 'Account', fieldName: 'Account__c' },
        { label: 'Panel Count', fieldName: 'Solar_Panel_Count__c', type: 'number' },
        { label: 'deadline', fieldName: 'Deadline_Date__c', type: 'text' },
        { label: 'Days to Deadline', fieldName: 'Days_to_Deadline__c' }
    ];

    /** Getter for UI condition */
    get hasCandidates() {
        return this.filteredData && this.filteredData.length > 0;
    }

    /** Fetch data */
    @wire(getCandidates)
    wiredCandidates({ data, error }) {
        if (data) {
            this.allCandidates = data;
            this.filteredData = data;
            fireEvent(this.pageRef, 'candidatecount', {
                count: this.filteredData.length
            });
        } else if (error) {
            console.error('Error fetching candidates:', error);
            this.allCandidates = [];
            this.filteredData = [];
        }
    }

    /** Subscribe to PubSub */
    connectedCallback() {
        registerListener('candidatesearch', this.handleSearchEvent, this);
    }

    /** Cleanup */
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    /** Filter logic */
    handleSearchEvent(payload) {
        const searchKey = payload?.searchKey?.toLowerCase() || '';

        this.filteredData = this.allCandidates.filter(record =>
            record.Name?.toLowerCase().includes(searchKey) ||
            record.skill__c?.toLowerCase().includes(searchKey) ||
            record.status__c?.toLowerCase().includes(searchKey)
        );
        console.log("Filtered Data Length: "+this.filteredData.length)
        // Publish count back
        fireEvent(this.pageRef, 'candidatecount', {
            count: this.filteredData.length
        });
    }
}