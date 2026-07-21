import { LightningElement, track } from 'lwc';
import sendEmailWithPdf from '@salesforce/apex/EmailController.sendEmailWithPdf';

export default class SolarEstimator extends LightningElement {
    @track area;
    @track model;
    @track phone;
    @track email;
    @track estimationData = {};
    @track approxDiscount = 0;
    @track enteredDiscount = 0;
    @track finalCost = 0;
    @track discountApplied = false;
    @track showResults = false;
    @track showEmailInput = false;
    @track showDiscountInput = false;

    // Picklist models
    modelOptions = [
        { label: 'SolarPulse Basic 3kW System', value: 'basic' },
        { label: 'SolarPulse Standard 5kW System', value: 'standard' },
        { label: 'SolarPulse Pro 7kW System', value: 'pro' },
        { label: 'SolarPulse Premium 10kW System', value: 'premium' },
        { label: 'SolarPulse Ultra 15kW System', value: 'ultra' }
    ];

    handleAreaChange(e) { this.area = e.target.value; }
    handleModelChange(e) { this.model = e.target.value; }
    handlePhoneChange(e) { this.phone = e.target.value; }
    handleEmailChange(e) { this.email = e.target.value; }
    handleDiscountChange(e) { this.enteredDiscount = parseFloat(e.target.value) || 0; }

    calculate() {
        // Example: set dummy data, replace with lookup from systemModels
        this.estimationData = { cost: 420000, name: 'SolarPulse Standard 5kW System' };
        this.approxDiscount = Math.round(this.estimationData.cost * 0.10); // 10% approx
        this.showResults = true;
    }

    clearForm() {
        this.area = '';
        this.model = '';
        this.phone = '';
        this.email = '';
        this.estimationData = {};
        this.approxDiscount = 0;
        this.enteredDiscount = 0;
        this.finalCost = 0;
        this.discountApplied = false;
        this.showResults = false;
        this.showEmailInput = false;
        this.showDiscountInput = false;
    }

    showEmailField() { this.showEmailInput = true; }

    async sendEstimation() {
        try {
            await sendEmailWithPdf({
                recipientEmail: this.email,
                estimation: JSON.stringify(this.estimationData)
            });
            alert('Estimation slip sent successfully!');
            this.showEmailInput = false;
        } catch (error) {
            console.error(error);
            alert('Failed to send email.');
        }
    }

    toggleDiscount() { this.showDiscountInput = !this.showDiscountInput; }

    applyDiscount() {
        if (this.enteredDiscount <= 0) {
            alert('Please enter a valid discount.');
            return;
        }
        if (this.enteredDiscount > this.approxDiscount) {
            alert(`Discount cannot exceed ₹${this.approxDiscount}`);
            return;
        }
        this.finalCost = this.estimationData.cost - this.enteredDiscount;
        this.discountApplied = true;
    }

    downloadPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        doc.setFontSize(16);
        doc.text("Solar Quotation Estimation Slip", 70, 20);

        doc.setFontSize(11);
        doc.text(`System Package: ${this.estimationData.name}`, 20, 40);
        doc.text(`System Cost: ₹${this.estimationData.cost}`, 20, 48);
        doc.text(`Approx Discount: ₹${this.approxDiscount}`, 20, 56);
        if (this.discountApplied) {
            doc.text(`Final Cost After Discount: ₹${this.finalCost}`, 20, 64);
        }
        doc.text(`Phone: ${this.phone || 'N/A'}`, 20, 72);

        doc.save(`EstimationSlip_${this.estimationData.name}.pdf`);
    }
}
