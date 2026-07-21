public with sharing class CustomerWorkspaceController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accountId) {
        if (accountId == null) return new List<Contact>();
        return [
            SELECT Id, Name, Email, Phone
            FROM Contact
            WHERE AccountId = :accountId
            ORDER BY Name
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Installation__c> getCandidates() {
        return [
            SELECT Id, Name, Solar_Panel_Model__c, Region__c, Account__c,Panel_Count__c,Deadline_Date__c,Days_to_Deadline__c
            FROM Installation__c
        ];
    }
}