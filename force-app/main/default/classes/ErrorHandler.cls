public with sharing class ErrorHandler {
    public static void log(String source, String context, Exception ex) {
        log(source, context, ex.getMessage() + '\n' + ex.getStackTraceString());
    }
    public static void log(String source, String context, String message) {
        try {
            insert new Log__c(
                Source__c    = source,
                Context__c   = context,
                Message__c   = message.abbreviate(32000),
                Level__c     = 'ERROR',
                Timestamp__c = System.now()
            );
        } catch (Exception innerError) {
            System.debug(LoggingLevel.ERROR, '[ErrorHandler] Log write failed: ' + 
innerError.getMessage());
        }
    }
}