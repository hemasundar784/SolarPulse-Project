trigger LeadAfterInsert on Lead (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Lead newLead : Trigger.new) {
        if (newLead.Email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{newLead.Email});
            mail.setSubject('Your Lead has been created');
            
            // Build the body with Lead details
            String body = 'Hello ' + newLead.FirstName + ' ' + newLead.LastName + ',\n\n' +
                          'Thank you for registering with us. Your Lead has been successfully created.\n\n' +
                          'Here are your details:\n' +
                          'Name: ' + newLead.FirstName + ' ' + newLead.LastName + '\n' +
                          'Email: ' + newLead.Email + '\n' +
                          'Phone: ' + newLead.Phone + '\n' +
                          'Company: ' + newLead.Company + '\n\n' +
                          'Our team will contact you shortly.\n\n' +
                          'Best Regards,\nSolarPulse Energy Team';

            mail.setPlainTextBody(body);
            emails.add(mail);
        }
    }

    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}
