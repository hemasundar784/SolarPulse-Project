// Model details database
const systemModels = {
  basic: {
    name: "SolarPulse Basic 3kW System",
    capacity: "3 kW",
    panels: 8,
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
    capacity: "5 kW",
    panels: 13,
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
    capacity: "7 kW",
    panels: 18,
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
    capacity: "10 kW",
    panels: 26,
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
    capacity: "15 kW",
    panels: 39,
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

function calculate() {
  const area = parseFloat(document.getElementById('area').value);
  const modelKey = document.getElementById('model').value;
  const phone = document.getElementById('phone').value.trim() || "N/A";

  if (!area || area <= 0) {
    alert("Please enter a valid area in sq. feet.");
    return;
  }

  const selectedModel = systemModels[modelKey];

  // Display details on page
  document.getElementById('systemModel').innerText = `Selected Model: ${selectedModel.name}`;
  document.getElementById('capacity').innerText = `Capacity: ${selectedModel.capacity}`;
  document.getElementById('panels').innerText = `Panel Count: ${selectedModel.panels} Panels`;
  document.getElementById('cost').innerText = `System Cost: ₹${selectedModel.cost.toLocaleString('en-IN')} (incl. 5% GST)`;
  document.getElementById('subsidy').innerText = `Govt. Subsidy Eligible: ₹${selectedModel.subsidy.toLocaleString('en-IN')}`;
  document.getElementById('electricity').innerText = `Generation: ${selectedModel.kwhMonth} kWh/mo (${selectedModel.kwhYear} kWh/yr)`;
  document.getElementById('monthly').innerText = `Est. Monthly Savings: ₹${selectedModel.monthlySavings.toLocaleString('en-IN')}`;
  document.getElementById('yearly').innerText = `Est. Annual Savings: ₹${selectedModel.annualSavings.toLocaleString('en-IN')}`;
  document.getElementById('longTerm').innerText = `25-Year Savings: ₹${selectedModel.savings25Yr.toLocaleString('en-IN')}`;
  document.getElementById('payback').innerText = `Payback Period: ${selectedModel.payback}`;
  document.getElementById('roi').innerText = `ROI (25 Years): ${selectedModel.roi}`;

  // Toggle UI visibility
  document.getElementById('estimatorForm').classList.add('hidden');
  document.getElementById('results').classList.remove('hidden');

  // Cache data globally for PDF generation
  window.estimationData = {
    ...selectedModel,
    area,
    phone
  };
}

function goBack() {
  // Hide results and show form again
  document.getElementById('results').classList.add('hidden');
  document.getElementById('estimatorForm').classList.remove('hidden');
}
//main button to go back to the main website
function Back() {
  window.location.href = "C:\\Users\\hemanth\\OneDrive\\Desktop\\Salesforce\\SolarPulse Project\\SolarPulse\\force-app\\main\\default\\websites\\ledwebsite.html"; // Replace with your target website URL
}

function downloadPDF() {
  const data = window.estimationData;
  if (!data) {
    alert("Please calculate first.");
    return;
  }

  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();

  const img = new Image();
  img.src = "logo.png"; // Must be located in the same directory

  const generatePDFContent = () => {
    doc.setFontSize(16);
    doc.text("Solar Quotation Estimation Slip", 70, 20);

    doc.setFontSize(11);
    doc.text(`Lead Phone No: ${data.phone}`, 20, 40);
    doc.text(`Installation Area: ${data.area} sq. ft.`, 20, 48);
    doc.text(`System Package: ${data.name}`, 20, 56);
    doc.text(`System Capacity: ${data.capacity} (${data.panels} Panels)`, 20, 64);
    doc.text(`Total Cost (incl. GST): ₹${data.cost.toLocaleString('en-IN')}`, 20, 72);
    doc.text(`Eligible Govt. Subsidy: ₹${data.subsidy.toLocaleString('en-IN')}`, 20, 80);
    doc.text(`Est. Generation: ${data.kwhMonth} kWh/month (${data.kwhYear} kWh/year)`, 20, 88);
    doc.text(`Monthly Savings: ₹${data.monthlySavings.toLocaleString('en-IN')}`, 20, 96);
    doc.text(`Annual Savings: ₹${data.annualSavings.toLocaleString('en-IN')}`, 20, 104);
    doc.text(`25-Year Cumulative Savings: ₹${data.savings25Yr.toLocaleString('en-IN')}`, 20, 112);
    doc.text(`Payback Period: ${data.payback}`, 20, 120);
    doc.text(`25-Year ROI: ${data.roi}`, 20, 128);

    doc.save(`EstimationSlip_${data.capacity}.pdf`);
  };

  img.onload = function () {
    doc.addImage(img, "PNG", 20, 10, 40, 20);
    generatePDFContent();
  };

  // Fallback if image fails to load/is missing
  img.onerror = function () {
    generatePDFContent();
  };
}