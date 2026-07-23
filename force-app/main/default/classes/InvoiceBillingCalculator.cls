public without sharing class InvoiceBillingCalculator {

    @AuraEnabled(cacheable=true)
    public static Billing__c InvoiceBillingRecord(Id id) {
        if (id == null) return null;
        try {
            return [
                SELECT Id, Name, Installation__c, Total_Cost__c, Initial_Paid__c,
                       Total_Amount_Paid__c, Remaining_Balance__c, Billing_Address__c,
                       Phone_Number__c, Payment_Status__c, Account__c, Insurance__c,
                       Insurance_Amount__c
                FROM Billing__c
                WHERE Id = :id
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Billing__c> searchBillingRecords(String searchTerm) {
        String key = '%' + searchTerm + '%';
        return [
            SELECT Id, Name
            FROM Billing__c
            WHERE Name LIKE :key
            LIMIT 5
        ];
    }

    @AuraEnabled
    public static void saveInsuranceAmount(Id id, Decimal insuranceAmount) {
        update new Billing__c(
            Id = id,
            Insurance_Amount__c = insuranceAmount
        );
    }
}
