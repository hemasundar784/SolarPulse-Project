@isTest
public class InstallationTriggerTest {
    @testSetup static void setup() {
        TestDataFactory.createInstallation(TestDataFactory.createAccount('Test Corp').Id,'Pending');
    }
    @isTest static void testValidDeadline_NoError() {
        Installation__c inst = [SELECT Id FROM Installation__c LIMIT 1];
        Test.startTest();
        inst.Deadline_Date__c = Date.today().addDays(60); update inst;
        Test.stopTest();
        System.assertEquals(
            0,
            [SELECT COUNT() FROM Log__c WHERE Source__c='InstallationTrigger'],
            'No errors expected for valid update'
        );
    }
    @isTest static void testInvalidDeadline_ThrowsError() {
        Installation__c inst = [SELECT Id,Scheduled_Date__c FROM Installation__c LIMIT 1];
        inst.Deadline_Date__c = inst.Scheduled_Date__c.addDays(-1);
         try {
            update inst;
            System.assert(false, 'DmlException expected');
        } catch (DmlException ex) {
            System.assert(
                ex.getMessage().contains('Deadline Date'),
                'Error must reference field'
            );
        }
    }
    @isTest static void testStatusChange_EnqueuesQueueable() {
        Installation__c inst = [SELECT Id FROM Installation__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockLogisticsCallout());
        Test.startTest();
        inst.Status__c = 'In Progress'; update inst;
        Test.stopTest();
        Assert.areEqual(0,[SELECT COUNT() FROM Log__c WHERE Level__c='ERROR'],'No errors expected');
    }
}