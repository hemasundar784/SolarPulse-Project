public class InstallationBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new InstallationMaintenanceBatch(), 200);
    }
}