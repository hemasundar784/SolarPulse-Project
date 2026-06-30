/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class TestDataFactory {
    public static Account createAccount(String name) {
        Account a = new Account(Name=name); insert a; return a;
    }
    public static Installation__c createInstallation(Id accountId, String status) {
        Installation__c i = new Installation__c(
            Account__c=accountId, Status__c=status, Region__c='North',
            Scheduled_Date__c=Date.today(), Deadline_Date__c=Date.today().addDays(30),
            Panel_Count__c=50, Contract_Value__c=75000);
        insert i; return i;
    }
    public static Field_Route__c createRoute(Id installId, String status) {
        Field_Route__c r = new Field_Route__c(
            Installation__c=installId, Route_Status__c=status,
            Route_Date__c=DateTime.now().addDays(1));
        insert r;  
        return r;
    }
}