public with sharing class InstallationTriggerHandler {
    public void onBeforeInsert(List<Installation__c> newList) { validateDeadlines(newList); }
    public void onBeforeUpdate(List<Installation__c> n, Map<Id,Installation__c> o) 
{ validateDeadlines(n); }
    public void onAfterInsert(List<Installation__c> newList) { /* reserved */ }

    public void onAfterUpdate(List<Installation__c> newList, Map<Id,Installation__c> oldMap) {
        List<Id> ids = new List<Id>();
        for (Installation__c inst : newList) {
            if (inst.Status__c == 'In Progress' && oldMap.get(inst.Id).Status__c != 'In Progress')
                ids.add(inst.Id);
        }
        if (!ids.isEmpty()) System.enqueueJob(new LogisticsQueueable(ids));
    }
    private void validateDeadlines(List<Installation__c> records) {
        for (Installation__c inst : records) {
            if (inst.Deadline_Date__c != null && inst.Scheduled_Date__c != null
                && inst.Deadline_Date__c < inst.Scheduled_Date__c) {
                inst.addError('Deadline Date must be on or after Scheduled Date.');
                }
            }
    }   
}