public with sharing class AccountService {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsWithLocation() {
        return [
            SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                   BillingLatitude, BillingLongitude
            FROM Account
            WHERE BillingCity != null
        ];
    }
}
