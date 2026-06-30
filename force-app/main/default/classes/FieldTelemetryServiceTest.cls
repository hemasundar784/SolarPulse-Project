@isTest
public class FieldTelemetryServiceTest {
    @testSetup static void setup() {
        Id acc = TestDataFactory.createAccount('Tel Corp').Id;
        TestDataFactory.createRoute(TestDataFactory.createInstallation(acc,'In Progress').Id,'Open');
    }
    @isTest static void testValidPayload_Returns200() {
        Field_Route__c route = [SELECT Id FROM Field_Route__c LIMIT 1];
        RestRequest req = new RestRequest();
        req.httpMethod='POST';
        req.requestBody=Blob.valueOf('{"routeId":"'+route.Id+'","latitude":37.77,"longitude":-122.4,"status":"Dispatched"}');
        RestContext.request=req; RestContext.response=new RestResponse();
        Test.startTest(); FieldTelemetryService.upsertTelemetry(); Test.stopTest();
        Assert.areEqual(200,RestContext.response.statusCode,'Valid payload must return 200');
        Assert.areEqual('Dispatched',[SELECT Route_Status__c FROM Field_Route__c WHERE Id=:route.Id].Route_Status__c,'Status must update');
    }
    @isTest static void testInvalidJSON_Returns400() {
        RestRequest req=new RestRequest(); req.httpMethod='POST';
        req.requestBody=Blob.valueOf('NOT_JSON');
        RestContext.request=req; RestContext.response=new RestResponse();
        Test.startTest(); FieldTelemetryService.upsertTelemetry(); Test.stopTest();
        Assert.areEqual(400,RestContext.response.statusCode,'Invalid JSON must return 400');
    }
}