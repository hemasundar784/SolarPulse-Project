@RestResource(urlMapping='/fieldtelemetry/v1/*')
global with sharing class FieldTelemetryService {
    @HttpPost
    global static void upsertTelemetry() {
        RestRequest  req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            TelemetryPayload p = (TelemetryPayload)JSON.deserialize(req.requestBody.toString(), 
TelemetryPayload.class);
            upsert new Field_Route__c(
                Id = p.routeId,
                GPS_Coordinates__Latitude__s  = p.latitude,
                GPS_Coordinates__Longitude__s = p.longitude,
                Route_Status__c               = p.status
            );
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"success":true}');
        } catch (JSONException je) {
            ErrorHandler.log('FieldTelemetryService','upsertTelemetry-JSON',je);
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('{"error":"Invalid JSON"}');
        } catch (Exception ex) {
            ErrorHandler.log('FieldTelemetryService','upsertTelemetry',ex);
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"Server Error"}');
        }
    }
    global class TelemetryPayload {
        global String routeId; global Decimal latitude;
        global Decimal longitude; global String status;
    }
}