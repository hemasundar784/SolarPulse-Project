public class LogisticsQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> installationIds;
    public LogisticsQueueable(List<Id> ids) { this.installationIds = ids; }
    public void execute(QueueableContext ctx) {
        try {
            for (Installation__c inst : [SELECT Id,Name,Region__c,Panel_Count__c
                FROM Installation__c WHERE Id IN :installationIds]) {
                LogisticsCalloutService.registerWithLogistics(inst);
            }
        } catch (Exception ex) {
            ErrorHandler.log('LogisticsQueueable','execute',ex);
        }
    }
}