function calculate() {
  const area = parseFloat(document.getElementById('area').value);
  const model = document.getElementById('model').value;
  // const phone = document.getElementById('phone').value;

  if (!area) {
    alert("Please enter the area.");
    return;
  }

  // Panel size assumption
  const panelSize = 40; // sq. ft per panel
  let costPerPanel, kWhPerPanel;

  if (model === "standard") {
    costPerPanel = 10000;
    kWhPerPanel = 40;
  } else if (model === "premium") {
    costPerPanel = 15000;
    kWhPerPanel = 55;
  } else {
    costPerPanel = 20000;
    kWhPerPanel = 70;
  }

  const panels = Math.floor(area / panelSize);
  const totalCost = panels * costPerPanel;
  const electricity = panels * kWhPerPanel;
  const tariff = 8; // ₹ per kWh
  const monthlySavings = electricity * tariff;
  const yearlySavings = monthlySavings * 12;

  document.getElementById('panels').innerText = `Estimated Panels: ${panels}`;
  document.getElementById('cost').innerText = `Total Cost: ₹${totalCost}`;
  document.getElementById('electricity').innerText = `Electricity Generated: ${electricity} kWh/month`;
  document.getElementById('monthly').innerText = `Monthly Savings: ₹${monthlySavings}`;
  document.getElementById('yearly').innerText = `Yearly Savings: ₹${yearlySavings}`;

  document.getElementById('results').classList.remove('hidden');

  // Save values for PDF
  window.estimationData = { panels, totalCost, electricity, monthlySavings, yearlySavings, phone };
}

function downloadPDF() {
  const data = window.estimationData;
  if (!data) {
    alert("Please calculate first.");
    return;
  }

  // Use jsPDF
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();

   // Add logo (replace with your logo path or Base64 string)
  const img = new Image();
  img.src = "logo.png"; // place logo.png in same folder as your HTML

  img.onload = function() {
    doc.addImage(img, "PNG", 20, 10, 40, 20); // x, y, width, height

    doc.setFontSize(16);
    doc.text("Solar Quotation Estimation Slip", 70, 20); // title next to logo;

  doc.setFontSize(12);
  doc.text(`Lead Phone No: ${data.phone}`, 20, 40);
  doc.text(`Estimated Panels: ${data.panels}`, 20, 50);
  doc.text(`Total Cost: ₹${data.totalCost}`, 20, 60);
  doc.text(`Electricity Generated: ${data.electricity} kWh/month`, 20, 70);
  doc.text(`Monthly Savings: ₹${data.monthlySavings}`, 20, 80);
  doc.text(`Yearly Savings: ₹${data.yearlySavings}`, 20, 90);

  doc.save("EstimationSlip.pdf");
}
}
