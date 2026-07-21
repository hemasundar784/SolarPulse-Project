public with sharing class EmailController {
    @AuraEnabled
    public static void sendEmailWithPdf(String recipientEmail, String estimation) {
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(estimation);

        String pdfContent = 'Solar Quotation Estimation Slip\n\n'
            + 'Company: SolarPulse\n'
            + 'Phone: ' + (String) data.get('phone') + '\n'
            + 'System: ' + (String) data.get('name') + '\n'
            + 'Cost: ₹' + String.valueOf(data.get('cost')) + '\n';

        Blob pdfBlob = Blob.valueOf(pdfContent);

        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('EstimationSlip.pdf');
        attachment.setBody(pdfBlob);
        attachment.setContentType('application/pdf');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { recipientEmail });
        mail.setSubject('Your Solar Estimation Slip');
        mail.setPlainTextBody('Dear Customer,\n\nPlease find attached your solar estimation slip.\n\nRegards,\nSolarPulse Team');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
