import { LightningElement, track } from 'lwc';
import sendContactsEmail from '@salesforce/apex/ContactEmailController.sendContactsEmail';
import getContactsCSV from '@salesforce/apex/ContactEmailController.getContactsCSV';

export default class ContactEmail extends LightningElement {
    @track email = '';
    @track subject = '';
    @track body = '';
    @track recordLimit = 10;
    @track stateFilter = '';
    @track cityFilter = '';
    @track streetFilter = '';

    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    handleSend() {
        sendContactsEmail({ 
            email: this.email, 
            subject: this.subject, 
            body: this.body, 
            recordLimit: parseInt(this.recordLimit, 10),
            stateFilter: this.stateFilter,
            cityFilter: this.cityFilter,
            streetFilter: this.streetFilter
        })
        .then(() => alert('Email sent successfully!'))
        .catch(error => {
            console.error(JSON.stringify(error));
            alert('Error sending email: ' + (error?.body?.message || error?.message || 'Unknown error'));
        });
    }

    handleDownload() {
        getContactsCSV({ 
            recordLimit: parseInt(this.recordLimit, 10),
            stateFilter: this.stateFilter,
            cityFilter: this.cityFilter,
            streetFilter: this.streetFilter
        })
        .then(result => {
            const blob = new Blob([result], { type: 'application/vnd.ms-excel' });
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'Contacts.csv';
            link.click();
        })
        .catch(error => {
            console.error(JSON.stringify(error));
            alert('Error downloading contacts: ' + (error?.body?.message || error?.message || 'Unknown error'));
        });
    }
}
