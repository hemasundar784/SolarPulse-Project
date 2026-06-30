public with sharing class InstallationAgentActions {
    @InvocableMethod(
        label='Get Installation Status'
        description='Returns installation status for Agentforce agent responses'
        category='Installation'
    )
    public static List<Result> getInstallationStatus(List<Request> requests) {
        List<Result> results = new List<Result>();
        try {
            for (Request r : requests) {
                List<Installation__c> found = [
                    SELECT Id,Name,Status__c,Total_Routes__c,Days_to_Deadline__c,Region__c
                    FROM Installation__c WHERE Account__r.Name = :r.accountName
                    ORDER BY CreatedDate DESC LIMIT 1];
                Result res = new Result();
                if (!found.isEmpty()) {
                    Installation__c inst = found[0];
                    res.installationName = inst.Name;
                    res.status           = inst.Status__c;
                    res.totalRoutes      = (Integer)inst.Total_Routes__c;
                    res.daysToDeadline   = (Integer)inst.Days_to_Deadline__c;
                    res.region           = inst.Region__c;
                    res.message = 'Your installation ' + inst.Name + ' is currently ' + inst.Status__c + '. '
                        + (inst.Days_to_Deadline__c > 0
                            ? 'Expected completion in ' + (Integer)inst.Days_to_Deadline__c + ' days.'
                            : 'The deadline has passed — please contact your regional manager.');
                } else {
                    res.message = 'No active installation found for: ' + r.accountName;
                }
                results.add(res);
            }
        } catch (Exception ex) {
            ErrorHandler.log('InstallationAgentActions','getInstallationStatus',ex);
            Result err = new Result();
            err.message = 'I encountered an error. Let me connect you with a support agent.';
            results.add(err);
        }
        return results;
    }
    public class Request {
        @InvocableVariable(label='Account Name' required=true) public String accountName;
    }
    public class Result {
        @InvocableVariable public String installationName;
        @InvocableVariable public String status;
        @InvocableVariable public Integer totalRoutes;
        @InvocableVariable public Integer daysToDeadline;
        @InvocableVariable public String region;
        @InvocableVariable public String message;
    }
}