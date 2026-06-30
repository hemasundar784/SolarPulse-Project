public class InstallationMaintenanceBatch implements Database.Batchable<SObject>, 
Database.Stateful {
    private Integer processed = 0, failed = 0;
    private static final Date CUTOFF = Date.today().addDays(-180);
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id,Status__c FROM Installation__c WHERE Status__c != \'Completed\' AND Status__c != \'Cancelled\' AND Scheduled_Date__c < :CUTOFF');
    }
    public void execute(Database.BatchableContext bc, List<Installation__c> scope) {
        try {
            for (Installation__c i : scope) i.Status__c = 'Cancelled';
            update scope; processed += scope.size();
        } catch (Exception ex) {
            ErrorHandler.log('InstallationMaintenanceBatch','execute',ex);
            failed += scope.size();
        }
    }
    public void finish(Database.BatchableContext bc) {
        Log__c log = new Log__c(
            Source__c='InstallationMaintenanceBatch',
            Level__c=failed>0?'ERROR':'INFO',
            Message__c='Processed '+processed+' records, failed '+failed+' records'
        );
        insert log;
    }
}
