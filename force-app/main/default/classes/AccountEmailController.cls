public with sharing class AccountEmailController {
    
    @AuraEnabled
    public static void sendAccountsEmail(String email, String subject, String body, Integer recordLimit) {
        // Query Accounts with adjustable limit
        List<Account> accounts = [
            SELECT Id, Name, BillingCity, BillingState, Phone, Industry 
            FROM Account 
            LIMIT :recordLimit
        ];

        // Build CSV
        String csvContent = 'Id,Name,BillingCity,BillingState,Phone,Industry\n';
        for (Account acc : accounts) {
            csvContent += '"' + acc.Id + '","' + acc.Name + '","' + acc.BillingCity + '","' 
                        + acc.BillingState + '","' + acc.Phone + '","' + acc.Industry + '"\n';
        }
        Blob csvBlob = Blob.valueOf(csvContent);

        // Attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Accounts.csv');
        attachment.setBody(csvBlob);
        attachment.setContentType('application/vnd.ms-excel');

        // Build email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { email });
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    @AuraEnabled
    public static String getAccountsCSV(Integer recordLimit) {
        List<Account> accounts = [
            SELECT Id, Name, BillingCity, BillingState, Phone, Industry 
            FROM Account 
            LIMIT :recordLimit
        ];

        String csvContent = 'Id,Name,BillingCity,BillingState,Phone,Industry\n';
        for (Account acc : accounts) {
            csvContent += '"' + acc.Name + '","' + acc.BillingCity + '","' 
                        + acc.BillingState + '","' + acc.Phone + '","' + acc.Industry + '"\n';
        }
        return csvContent;
    }
}
