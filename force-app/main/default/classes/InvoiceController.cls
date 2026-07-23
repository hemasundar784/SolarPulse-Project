public with sharing class InvoiceController {

    @AuraEnabled(cacheable=true)
    public static List<Billing__c> getInvoices() {
        return [SELECT Id, Name, Installation__c, Total_Cost__c, Initial_Paid__c, Total_Amount_Paid__c, Remaining_Balance__c, Billing_Address__c, Phone_Number__c, Payment_Status__c, Account__c, Insurance__c, insurance_amount__c, Gov_subsidy__c FROM Billing__c  LIMIT 50];
    }

    @AuraEnabled
    public static Id generateInvoicePdf(String recordId, String htmlContent) {
        PageReference pdfPage = Page.InvoicePdfPage;
        pdfPage.getParameters().put('recordId', recordId);
        Blob pdfBlob = pdfPage.getContentAsPDF();

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Invoice_' + recordId;
        cv.PathOnClient = 'Invoice_' + recordId + '.pdf';
        cv.VersionData = pdfBlob;
        cv.IsMajorVersion = true;
        insert cv;

        return cv.Id;
    }

    @AuraEnabled
    public static void sendInvoiceEmail(Id accountId, Id contentVersionId, String recipientEmail) {
        ContentVersion cv = [SELECT Id, VersionData, Title FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { recipientEmail });
        mail.setSubject('Invoice - ' + cv.Title);
        mail.setPlainTextBody('Please find attached your invoice.');
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(cv.Title + '.pdf');
        attachment.setBody(cv.VersionData);
        attachment.setContentType('application/pdf');

        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
