// 1. DYNAMIC RESOURCE RESOLUTION (Prevents Lookup ID Hardcoding Failures)
List<Account> targetAccs = [SELECT Id FROM Account LIMIT 1];
Account testAcc;
if (targetAccs.isEmpty()) {
    testAcc = new Account(Name = 'SolarPulse Demo Customer Corp');
    insert testAcc;
} else {
    testAcc = targetAccs[0];
}

User activeUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

// 2. ERROR LOG GENERATION MATRIX (3 Records)
List<Log__c> logRecords = new List<Log__c>();
logRecords.add(new Log__c(Source__c = 'IntegrationService', Context__c = 'Inverter API Sync', Level__c = 'ERROR', Message__c = 'Timeout connecting to solar edge cloud management API server interface.', Timestamp__c = DateTime.now()));
logRecords.add(new Log__c(Source__c = 'InvoiceProcessorBatch', Context__c = 'Nightly Automation Run', Level__c = 'WARN', Message__c = 'CPU timeout warning threshold breached during high volume contract evaluation.', Timestamp__c = DateTime.now().addMinutes(-45)));
logRecords.add(new Log__c(Source__c = 'BeforeSaveInstallation', Context__c = 'Trigger Context Validation', Level__c = 'INFO', Message__c = 'System initialized panel array telemetry configurations cleanly.', Timestamp__c = DateTime.now().addHours(-3)));
insert logRecords;

// 3. INSTALLATION GENERATION MATRIX (3 Records)
List<Installation__c> instRecords = new List<Installation__c>();
instRecords.add(new Installation__c(
    Account__c = testAcc.Id,
    Assigned_Manager__c = activeUser.Id,
    Status__c = 'In Progress',
    Region__c = 'West',
    Scheduled_Date__c = Date.today(),
    Deadline_Date__c = Date.today().addDays(14),
    Panel_Count__c = 24,
    Contract_Value__c = 15450.00,
    Alert_Flag__c = false
));
instRecords.add(new Installation__c(
    Account__c = testAcc.Id,
    Assigned_Manager__c = activeUser.Id,
    Status__c = 'Pending',
    Region__c = 'North',
    Scheduled_Date__c = Date.today().addDays(6),
    Deadline_Date__c = Date.today().addDays(30),
    Panel_Count__c = 48,
    Contract_Value__c = 32000.00,
    Alert_Flag__c = false
));
instRecords.add(new Installation__c(
    Account__c = testAcc.Id,
    Assigned_Manager__c = activeUser.Id,
    Status__c = 'Completed',
    Region__c = 'South',
    Scheduled_Date__c = Date.today().addDays(-12),
    Deadline_Date__c = Date.today().addDays(-2),
    Panel_Count__c = 14,
    Contract_Value__c = 9200.00,
    Alert_Flag__c = false
));
insert instRecords;

// 4. FIELD ROUTE GENERATION MATRIX (3 Records mapped cleanly via parent keys)
List<Field_Route__c> routeRecords = new List<Field_Route__c>();
routeRecords.add(new Field_Route__c(
    Installation__c = instRecords[0].Id, // Pointing to West installation
    Technician__c = activeUser.Id,
    Route_Date__c = DateTime.now().addDays(1),
    Route_Status__c = 'Dispatched',
    GPS_Coordinates__Latitude__s = 37.7749,
    GPS_Coordinates__Longitude__s = -122.4194,
    Duration_Hours__c = 3.5,
    Completion_Notes__c = 'Initial structural site mounting analysis and framing confirmation window.'
));
routeRecords.add(new Field_Route__c(
    Installation__c = instRecords[1].Id, // Pointing to North installation
    Technician__c = activeUser.Id,
    Route_Date__c = DateTime.now().addDays(7),
    Route_Status__c = 'Open',
    GPS_Coordinates__Latitude__s = 34.0522,
    GPS_Coordinates__Longitude__s = -118.2437,
    Duration_Hours__c = null,
    Completion_Notes__c = null
));
routeRecords.add(new Field_Route__c(
    Installation__c = instRecords[2].Id, // Pointing to Completed South installation
    Technician__c = activeUser.Id,
    Route_Date__c = DateTime.now().addDays(-6),
    Route_Status__c = 'Completed',
    GPS_Coordinates__Latitude__s = 40.7128,
    GPS_Coordinates__Longitude__s = -74.0060,
    Duration_Hours__c = 4.25,
    Completion_Notes__c = 'Micro-inverter array completely synchronized to sub-panel. Grounding rod inspection approved.'
));
insert routeRecords;

System.debug('>>> SUCCESS: Demo ecosystem populated cleanly for all objects!');
