public with sharing class EmailController {
    @AuraEnabled
    public static void sendEmailWithPdf(String recipientEmail, String estimation) {
        // Parse estimation JSON safely
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(estimation);

        String phoneVal = data.containsKey('phone') && data.get('phone') != null ? String.valueOf(data.get('phone')) : 'N/A';
        String nameVal = data.containsKey('name') ? String.valueOf(data.get('name')) : 'Solar System';
        String capacityVal = data.containsKey('capacity') ? String.valueOf(data.get('capacity')) : 'N/A';
        String costVal = data.containsKey('cost') ? String.valueOf(data.get('cost')) : '0';
        String roiVal = data.containsKey('roi') ? String.valueOf(data.get('roi')) : 'N/A';

        // Build PDF content
        String pdfContent = 'Solar Quotation Estimation Slip\n\n'
            + 'Company: SolarPulse\n'
            + 'Phone: ' + phoneVal + '\n'
            + 'System: ' + nameVal + '\n'
            + 'Capacity: ' + capacityVal + '\n'
            + 'Cost: ₹' + costVal + '\n'
            + 'ROI: ' + roiVal;

        // Convert to PDF blob
        Blob pdfBlob = Blob.valueOf(pdfContent);

        // Create email attachment & message
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('EstimationSlip.pdf');
        attachment.setBody(pdfBlob);
        attachment.setContentType('application/pdf');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { recipientEmail });
        mail.setSubject('Your Solar Estimation Slip');
        mail.setPlainTextBody(
            'Dear Customer,\n\nPlease find attached your solar estimation slip.\n\nRegards,\nSolarPulse Team'
        );
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}