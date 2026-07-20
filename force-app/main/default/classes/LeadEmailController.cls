public with sharing class LeadEmailController {
    
    @AuraEnabled
    public static void sendLeadsEmail(String email, String subject, String body) {
        List<Lead> leads = [SELECT Id, FirstName, LastName, Email, Company FROM Lead];

        // Build CSV
        String csvContent = 'Id,FirstName,LastName,Email,Company\n';
        for (Lead l : leads) {
            csvContent += '"' + l.Id + '","' + l.FirstName + '","' + l.LastName + '","' + l.Email + '","' + l.Company + '"\n';
        }
        Blob csvBlob = Blob.valueOf(csvContent);

        // Attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Leads.csv');
        attachment.setBody(csvBlob);
        attachment.setContentType('text/csv');

        // Build email (From will be current user or Org-Wide if you set it)
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { email });
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
         @AuraEnabled
        public static String getLeadsCSV() {
        try {
            List<Lead> leads = [SELECT Id, FirstName, LastName, Email, Company FROM Lead];
            String csvContent = 'Id,FirstName,LastName,Email,Company\n';
            for (Lead l : leads) {
                csvContent +=  '"' + l.FirstName + '","' + l.LastName + '","' + l.Email + '","' + l.Company + '"\n';
                }
            return csvContent;
            } catch (Exception e) {
                throw new AuraHandledException('Failed to generate CSV: ' + e.getMessage());
            }
}


}
