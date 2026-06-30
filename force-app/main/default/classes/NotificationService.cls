public with sharing class NotificationService {
    public static void sendEmail(String toAddress, String subject, String htmlBody) {
        if (String.isBlank(toAddress)) return;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ toAddress });
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        mail.setSaveAsActivity(false);
        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
        } catch (Exception ex) {
            ErrorHandler.log('NotificationService', 'sendEmail', ex);
        }
    }
    public static void sendBatchReport(String recipientEmail, Integer processed, Integer failed) {
        String html = '<h2>SolarPulse Nightly Report</h2>'
            + '<table border="1"><tr><th>Metric</th><th>Value</th></tr>'
            + '<tr><td>Processed</td><td>' + processed + '</td></tr>'
            + '<tr><td>Errors</td><td>' + failed + '</td></tr>'
            + '<tr><td>Timestamp</td><td>' + System.now() + '</td></tr></table>';
        sendEmail(recipientEmail, 'SolarPulse Batch Complete — ' + Date.today(), html);
    }
}