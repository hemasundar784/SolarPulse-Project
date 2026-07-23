import { LightningElement, api, track, wire } from 'lwc';
import generateInvoicePdf from '@salesforce/apex/InvoiceController.generateInvoicePdf';
import sendInvoiceEmail from '@salesforce/apex/InvoiceController.sendInvoiceEmail';
import getInvoices from '@salesforce/apex/InvoiceController.getInvoices';

import logoResource from '@salesforce/resourceUrl/logo';


   



export default class InvoiceCard extends LightningElement {
    logoUrl = logoResource;
    @api billingNumber;
    @api owner;
    @api installationId;
    @api totalCost;
    @api initialPaid;
    @api totalAmountPaid;
    @api remainingBalance;
    @api billingAddress;
    @api phoneNumber;
    @api paymentStatus;
    @api accountName;
    @api insuranceProvider;
    @api insuranceAmount;

    @track invoices = [];
    @track filteredInvoices = [];
    lastGeneratedPdfId;

    @wire(getInvoices)
    wiredInvoices({ error, data }) {
        if (data) {
            this.invoices = data;
            this.filteredInvoices = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleSearch(event) {
        const query = event.target.value.toLowerCase();
        this.filteredInvoices = this.invoices.filter(
            inv => inv.AccountName.toLowerCase().includes(query) || inv.BillingNumber.toLowerCase().includes(query)
        );
    }

    handleDownloadPdf() {
        generateInvoicePdf({ recordId: this.billingNumber, htmlContent: this.template.innerHTML })
            .then(result => {
                this.lastGeneratedPdfId = result;
                alert('PDF generated successfully!');
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleSendEmail() {
        sendInvoiceEmail({ 
            accountId: this.accountName, 
            contentVersionId: this.lastGeneratedPdfId, 
            recipientEmail: 'customer@example.com' // replace with actual email field
        })
        .then(() => {
            alert('Invoice sent via email successfully!');
        })
        .catch(error => {
            console.error(error);
        });
    }
}
