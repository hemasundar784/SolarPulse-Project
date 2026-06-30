public with sharing class InstallationController {

    @AuraEnabled(cacheable=true)
    public static List<Field_Route__c> getRoutesByInstallation(Id installationId) {
        return [
            SELECT Id, Name, Route_Status__c, Route_Date__c, Technician__r.Name
            FROM Field_Route__c
            WHERE Installation__c = :installationId
            ORDER BY Route_Date__c ASC
        ];
    }
    @AuraEnabled
    public static void updateRouteStatus(Id routeId, String newStatus) {
        try {
            update new Field_Route__c(Id = routeId, Route_Status__c = newStatus);
        } catch (Exception ex) {
            ErrorHandler.log('InstallationController', 'updateRouteStatus', ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}