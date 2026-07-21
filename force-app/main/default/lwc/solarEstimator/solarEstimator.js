import { LightningElement, track } from 'lwc';
import sendEmailWithPdf from '@salesforce/apex/EmailController.sendEmailWithPdf';

const systemModels = {
    basic: {
        name: "SolarPulse Basic 3kW System",
        capacity: "3kW",
        cost: 262500,
        kwhMonth: 350,
        kwhYear: 4200,
        monthlySavings: 2450,
        annualSavings: 29400,
        savings25Yr: 735000,
        payback: "8.9 years",
        roi: "280%",
        subsidy: 90000
    },
    standard: {
        name: "SolarPulse Standard 5kW System",
        capacity: "5kW",
        cost: 420000,
        kwhMonth: 583,
        kwhYear: 7000,
        monthlySavings: 4081,
        annualSavings: 48972,
        savings25Yr: 1224300,
        payback: "8.6 years",
        roi: "291%",
        subsidy: 150000
    },
    pro: {
        name: "SolarPulse Pro 7kW System",
        capacity: "7kW",
        cost: 577500,
        kwhMonth: 817,
        kwhYear: 9800,
        monthlySavings: 5719,
        annualSavings: 68628,
        savings25Yr: 1715700,
        payback: "8.4 years",
        roi: "297%",
        subsidy: 200000
    },
    premium: {
        name: "SolarPulse Premium 10kW System",
        capacity: "10kW",
        cost: 787500,
        kwhMonth: 1167,
        kwhYear: 14000,
        monthlySavings: 8169,
        annualSavings: 98028,
        savings25Yr: 2450700,
        payback: "8.0 years",
        roi: "311%",
        subsidy: 300000
    },
    ultra: {
        name: "SolarPulse Ultra 15kW System",
        capacity: "15kW",
        cost: 1155000,
        kwhMonth: 1750,
        kwhYear: 21000,
        monthlySavings: 12250,
        annualSavings: 147000,
        savings25Yr: 3675000,
        payback: "7.8 years",
        roi: "318%",
        subsidy: 450000
    }
};

export default class SolarEstimator extends LightningElement {
    @track area;
    @track model;
    @track phone = '';
    @track email = '';
    @track estimationData = {};
    @track approxDiscount = 0;
    @track enteredDiscount = 0;
    @track finalCost = 0;
    @track discountApplied = false;
    @track showResults = false;
    @track showEmailInput = false;
    @track showDiscountInput = false;

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
        if (!this.model) {
            alert('Please select a system model.');
            return;
        }
        const selectedModel = systemModels[this.model];
        this.estimationData = selectedModel;
        this.approxDiscount = Math.round(selectedModel.cost * 0.10);
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
        if (!this.email) {
            alert('Please enter a valid email address.');
            return;
        }

        // Merge phone and dynamic calculations into payload for backend PDF generation
        const payload = {
            ...this.estimationData,
            phone: this.phone || 'N/A',
            finalCost: this.discountApplied ? this.finalCost : this.estimationData.cost
        };

        try {
            await sendEmailWithPdf({
                recipientEmail: this.email,
                estimation: JSON.stringify(payload)
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
            alert(`Discount cannot exceed ₹${this.approxDiscount.toLocaleString('en-IN')}`);
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
        doc.text(`System Cost: ₹${this.estimationData.cost.toLocaleString('en-IN')}`, 20, 48);
        doc.text(`Approx Discount: ₹${this.approxDiscount.toLocaleString('en-IN')}`, 20, 56);
        if (this.discountApplied) {
            doc.text(`Final Cost After Discount: ₹${this.finalCost.toLocaleString('en-IN')}`, 20, 64);
        }
        doc.text(`Phone: ${this.phone || 'N/A'}`, 20, 72);

        doc.save(`EstimationSlip_${this.estimationData.name}.pdf`);
    }

    get formattedCost() {
        return this.estimationData.cost ? this.estimationData.cost.toLocaleString('en-IN') : '';
    }
    get formattedApproxDiscount() {
        return this.approxDiscount ? this.approxDiscount.toLocaleString('en-IN') : '';
    }
    get formattedFinalCost() {
        return this.discountApplied ? this.finalCost.toLocaleString('en-IN') : '';
    }
    get formattedSubsidy() {
        return this.estimationData.subsidy ? this.estimationData.subsidy.toLocaleString('en-IN') : '';
    }
    get formattedMonthlySavings() {
        return this.estimationData.monthlySavings ? this.estimationData.monthlySavings.toLocaleString('en-IN') : '';
    }
    get formattedAnnualSavings() {
        return this.estimationData.annualSavings ? this.estimationData.annualSavings.toLocaleString('en-IN') : '';
    }
    get formattedSavings25Yr() {
        return this.estimationData.savings25Yr ? this.estimationData.savings25Yr.toLocaleString('en-IN') : '';
    }
}