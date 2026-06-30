@isTest
public class MockLogisticsCallout implements HttpCalloutMock {
    private Integer statusCode; private String body;
    public MockLogisticsCallout() { this.statusCode=200; this.body='{"success":true}'; }
    public MockLogisticsCallout(Integer code, String b) { this.statusCode=code; this.body=b; }
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode); res.setBody(body); return res;
    }
}