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
public static List<Installation__c> getInstallations(Id accountId) {
    if (accountId == null) return new List<Installation__c>();
    return [
        SELECT Id, Name, Account__c, Status__c, Assigned_Manager__c, Contract_Value__c,
               Deadline_Date__c, Panel_Count__c, Region__c, Scheduled_Date__c,
               Days_to_Deadline__c, Total_Routes__c, Solar_Panel_Model__c
        FROM Installation__c
        WHERE Account__c = :accountId
        ORDER BY Deadline_Date__c ASC
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