import { LightningElement, track } from 'lwc';
import sendLeadsEmail from '@salesforce/apex/LeadEmailController.sendLeadsEmail';
import getLeadsCSV from '@salesforce/apex/LeadEmailController.getLeadsCSV';

export default class EmailLeads extends LightningElement {
    @track email = '';
    @track subject = '';
    @track body = '';

    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    // Send email with leads attached
    handleSend() {
        sendLeadsEmail({ email: this.email, subject: this.subject, body: this.body })
            .then(() => {
                alert('Email sent successfully!');
            })
            .catch(error => {
            console.error(JSON.stringify(error));
            const message = error?.body?.message || error?.message || 'Unknown error';
            alert('Error sending email: ' + message);
        });

    }

    // Download leads as CSV
    handleDownload() {
    getLeadsCSV()
        .then(result => {
                // Use a safer MIME type
                const blob = new Blob([result], { type: 'application/vnd.ms-excel' });
                const link = document.createElement('a');
                link.href = URL.createObjectURL(blob);
                link.download = 'Leads.csv';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            })
            .catch(error => {
                console.error(JSON.stringify(error));
                const message = error?.body?.message || error?.message || 'Unknown error';
                alert('Error downloading leads: ' + message);
            });
    }

}
