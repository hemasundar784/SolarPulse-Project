public with sharing class LogisticsCalloutService {
    private static final String ENDPOINT = 'callout:ShipMatrix_NC/api/v2/routes/register';
    public static void registerWithLogistics(Installation__c inst) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(new Map<String, Object>{
            'installationId' => inst.Id, 'installationName' => inst.Name,
            'region' => inst.Region__c, 'panelCount' => inst.Panel_Count__c}));
        req.setTimeout(10000);
        try {
            HttpResponse res = new Http().send(req);
            if (res.getStatusCode() != 200 && res.getStatusCode() != 201)
                ErrorHandler.log('LogisticsCalloutService','register','HTTP'+res.getStatusCode());
        } catch (Exception ex) {
            ErrorHandler.log('LogisticsCalloutService','register',ex);
        }
    }
}