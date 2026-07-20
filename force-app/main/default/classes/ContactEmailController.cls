public with sharing class ContactEmailController {
    
    @AuraEnabled
    public static void sendContactsEmail(String email, String subject, String body, Integer recordLimit, String stateFilter, String cityFilter, String streetFilter) {
        // Build dynamic query with filters
        String baseQuery = 'SELECT Id, FirstName, LastName, MailingStreet, MailingCity, MailingState, Phone, Email FROM Contact WHERE Id != null';
        
        if (String.isNotBlank(stateFilter)) {
            baseQuery += ' AND MailingState = :stateFilter';
        }
        if (String.isNotBlank(cityFilter)) {
            baseQuery += ' AND MailingCity = :cityFilter';
        }
        if (String.isNotBlank(streetFilter)) {
            baseQuery += ' AND MailingStreet LIKE \'%' + String.escapeSingleQuotes(streetFilter) + '%\'';
        }
        
        baseQuery += ' LIMIT :recordLimit';
        
        List<Contact> contacts = Database.query(baseQuery);

        // Build CSV
        String csvContent = 'Id,FirstName,LastName,MailingStreet,MailingCity,MailingState,Phone,Email\n';
        for (Contact c : contacts) {
            csvContent += '"' + c.Id + '","' + c.FirstName + '","' + c.LastName + '","' 
                        + c.MailingStreet + '","' + c.MailingCity + '","' + c.MailingState + '","' 
                        + c.Phone + '","' + c.Email + '"\n';
        }
        Blob csvBlob = Blob.valueOf(csvContent);

        // Attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Contacts.csv');
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
    public static String getContactsCSV(Integer recordLimit, String stateFilter, String cityFilter, String streetFilter) {
        String baseQuery = 'SELECT Id, FirstName, LastName, MailingStreet, MailingCity, MailingState, Phone, Email FROM Contact WHERE Id != null';
        
        if (String.isNotBlank(stateFilter)) {
            baseQuery += ' AND MailingState = :stateFilter';
        }
        if (String.isNotBlank(cityFilter)) {
            baseQuery += ' AND MailingCity = :cityFilter';
        }
        if (String.isNotBlank(streetFilter)) {
            baseQuery += ' AND MailingStreet LIKE \'%' + String.escapeSingleQuotes(streetFilter) + '%\'';
        }
        
        baseQuery += ' LIMIT :recordLimit';
        
        List<Contact> contacts = Database.query(baseQuery);

        String csvContent = 'Id,FirstName,LastName,MailingStreet,MailingCity,MailingState,Phone,Email\n';
        for (Contact c : contacts) {
            csvContent += '"' + c.FirstName + '","' + c.LastName + '","' 
                        + c.MailingStreet + '","' + c.MailingCity + '","' + c.MailingState + '","' 
                        + c.Phone + '","' + c.Email + '"\n';
        }
        return csvContent;
    }
}
