import { LightningElement, track } from 'lwc';
import sendAccountsEmail from '@salesforce/apex/AccountEmailController.sendAccountsEmail';
import getAccountsCSV from '@salesforce/apex/AccountEmailController.getAccountsCSV';

export default class AccountEmail extends LightningElement {
    @track email = '';
    @track subject = '';
    @track body = '';
    @track recordLimit = 10; // default size

    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    handleSend() {
        sendAccountsEmail({ 
            email: this.email, 
            subject: this.subject, 
            body: this.body, 
            recordLimit: parseInt(this.recordLimit, 10) 
        })
        .then(() => alert('Email sent successfully!'))
        .catch(error => {
            console.error(JSON.stringify(error));
            alert('Error sending email: ' + (error?.body?.message || error?.message || 'Unknown error'));
        });
    }

    handleDownload() {
        getAccountsCSV({ recordLimit: parseInt(this.recordLimit, 10) })
        .then(result => {
            const blob = new Blob([result], { type: 'application/vnd.ms-excel' });
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'Accounts.csv';
            link.click();
        })
        .catch(error => {
            console.error(JSON.stringify(error));
            alert('Error downloading accounts: ' + (error?.body?.message || error?.message || 'Unknown error'));
        });
    }
}
