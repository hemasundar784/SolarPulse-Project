@isTest
public class InstallationBatchTest {
    @testSetup static void setup() {
        Id accId = TestDataFactory.createAccount('Batch Corp').Id;
        for (Integer i=0;i<5;i++) {
            insert new Installation__c(
                Account__c=accId, Status__c='Pending', Region__c='South',
                Scheduled_Date__c=Date.today().addDays(-200),
                Deadline_Date__c=Date.today().addDays(-100),
                Panel_Count__c=10, Contract_Value__c=5000);
        }
    }
    @isTest static void testBatch_CancelsStaleRecords() {
        Test.startTest();
        Database.executeBatch(new InstallationMaintenanceBatch(),200);
        Test.stopTest();
        System.assertEquals(
            5,
            [SELECT COUNT() FROM Installation__c WHERE Status__c='Cancelled'],
            'All 5 stale installations must be cancelled'
        );
    }
}