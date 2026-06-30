trigger InstallationTrigger on Installation__c (before insert, before update, after insert, 
after update) {
    try {
        InstallationTriggerHandler handler = new InstallationTriggerHandler();
        if (Trigger.isBefore) {
            if (Trigger.isInsert) handler.onBeforeInsert(Trigger.new);
            if (Trigger.isUpdate) handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        } else {
            if (Trigger.isInsert) handler.onAfterInsert(Trigger.new);
            if (Trigger.isUpdate) handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    } catch (Exception ex) {
        ErrorHandler.log('InstallationTrigger', 'execute', ex);
    }
}