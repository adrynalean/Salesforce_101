public with sharing class CaseIntegrationSyncJob implements Queueable, Database.AllowsCallouts {
    private Set<Id> caseIds;

    public CaseIntegrationSyncJob(Set<Id> caseIds) {
        this.caseIds = caseIds == null
            ? new Set<Id>()
            : new Set<Id>(caseIds);
    }

    public void execute(QueueableContext context) {
        CaseIntegrationSyncService.syncCases(caseIds);
    }

    public static Id enqueue(Set<Id> caseIds) {
        return System.enqueueJob(new CaseIntegrationSyncJob(caseIds));
    }
}
