public with sharing class CaseIntegrationSyncService {
    private static final String EXTERNAL_SYSTEM = 'HealthOps Integration Hub';

    public static void syncCases(Set<Id> caseIds) {
        if (caseIds == null || caseIds.isEmpty()) {
            return;
        }

        List<IntegrationLogService.LogRequest> logRequests = new List<IntegrationLogService.LogRequest>();

        for (Case caseRecord : [
            SELECT Id, CaseNumber, Subject, Priority, Request_Type__c, External_System_Id__c
            FROM Case
            WHERE Id IN :caseIds
        ]) {
            logRequests.add(buildLogRequest(caseRecord));
        }

        IntegrationLogService.logCaseResults(logRequests);
    }

    private static IntegrationLogService.LogRequest buildLogRequest(Case caseRecord) {
        SimulatedSyncResult result = simulateExternalSync(caseRecord);

        return new IntegrationLogService.LogRequest(
            caseRecord.Id,
            EXTERNAL_SYSTEM,
            buildExternalReference(caseRecord),
            result.status,
            result.statusCode,
            result.message,
            result.retryCount
        );
    }

    private static SimulatedSyncResult simulateExternalSync(Case caseRecord) {
        String subject = String.isBlank(caseRecord.Subject)
            ? ''
            : caseRecord.Subject.toLowerCase();

        if (subject.contains('fail')) {
            return new SimulatedSyncResult(
                'Error',
                500,
                'The simulated external system rejected this case payload.',
                1
            );
        }

        if (caseRecord.Priority == 'High') {
            return new SimulatedSyncResult(
                'Retry Scheduled',
                429,
                'The simulated external system is rate limited. Retry scheduled.',
                1
            );
        }

        return new SimulatedSyncResult(
            'Success',
            200,
            'Case synced successfully to the simulated external system.',
            0
        );
    }

    private static String buildExternalReference(Case caseRecord) {
        if (!String.isBlank(caseRecord.External_System_Id__c)) {
            return caseRecord.External_System_Id__c;
        }

        return 'HUB-' + String.valueOf(caseRecord.Id).substring(0, 15);
    }

    private class SimulatedSyncResult {
        private String status;
        private Integer statusCode;
        private String message;
        private Integer retryCount;

        private SimulatedSyncResult(String status, Integer statusCode, String message, Integer retryCount) {
            this.status = status;
            this.statusCode = statusCode;
            this.message = message;
            this.retryCount = retryCount;
        }
    }
}
