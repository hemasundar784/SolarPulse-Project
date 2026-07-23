import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBillingRecord from '@salesforce/apex/InvoiceBillingCalculator.InvoiceBillingRecord';
import searchBillingRecords from '@salesforce/apex/InvoiceBillingCalculator.searchBillingRecords';
import saveInsuranceAmount from '@salesforce/apex/InvoiceBillingCalculator.saveInsuranceAmount';
//import BILLING_TITLE from '@salesforce/label/c.Billing_Calculator_Title';

export default class Invoice extends LightningElement {
    @api recordId;
    @track selectedBillingId;
    @track searchKey = '';
    @track searchResults = [];
    @track insuranceAmount = 0;

    billing;
    wiredResult;

    label = { BILLING_TITLE };

    // Fields to display in lightning-record-form
    fieldsToDisplay = [
        'Payment_Status__c',
        'Invoice_Status__c',
        'Phone_Number__c',
        'Days_Overdue__c',
        'Remaining_Balance__c',
        'Total_Amount_Paid__c',
        'Total_Cost__c',
        'Insurance_Amount__c',
        'Insurance__c',
        'Initial_Paid__c',
        'Account__c'
    ];

    get targetId() {
        return this.recordId || this.selectedBillingId || null;
    }

    @wire(getBillingRecord, { id: '$targetId' })
    wiredBilling(result) {
        this.wiredResult = result;
        if (result.data) {
            this.billing = result.data;
            this.insuranceAmount = result.data.Insurance_Amount__c || 0;
        } else {
            this.billing = null;
        }
    }

    @wire(searchBillingRecords, { searchTerm: '$searchKey' })
    wiredSearch({ data }) {
        this.searchResults = data ? data : [];
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value;
    }

    handleSelectRecord(event) {
        event.preventDefault();
        this.selectedBillingId = event.currentTarget.dataset.id;
        this.searchResults = [];
        this.searchKey = '';
    }

    handleInsuranceChange(event) {
        this.insuranceAmount = parseFloat(event.target.value) || 0;
    }

    handleFormSuccess() {
        return refreshApex(this.wiredResult);
    }

    async handleSave() {
        try {
            await saveInsuranceAmount({ id: this.targetId, insuranceAmount: this.insuranceAmount });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Invoice Saved',
                message: 'Insurance updates recorded.',
                variant: 'success'
            }));
            return refreshApex(this.wiredResult);
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error Updating',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }

    handlePrint() {
        window.print();
    }

    get recordName() {
        return this.billing ? this.billing.Name : '';
    }

    get totalInvoiceAmount() {
        return this.billing ? (this.billing.Total_Amount__c || 0) : 0;
        }

    get payable() {
        return this.totalInvoiceAmount - this.insuranceAmount;
    }

    get isLoading() {
        return this.targetId && !this.billing;
    }

    get showPromptMessage() {
        return !this.targetId;
    }
}
