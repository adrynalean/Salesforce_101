public with sharing class IntegrationLogService {
    private static final String INTEGRATION_MONITORING_QUEUE = 'Integration_Monitoring';

    public class LogRequest {
        public Id relatedCaseId;
        public String externalSystem;
        public String externalReference;
        public String status;
        public Integer statusCode;
        public String message;
        public Integer retryCount;

        public LogRequest(
            Id relatedCaseId,
            String externalSystem,
            String externalReference,
            String status,
            Integer statusCode,
            String message,
            Integer retryCount
        ) {
            this.relatedCaseId = relatedCaseId;
            this.externalSystem = externalSystem;
            this.externalReference = externalReference;
            this.status = status;
            this.statusCode = statusCode;
            this.message = message;
            this.retryCount = retryCount;
        }
    }

    public static List<Integration_Log__c> logCaseResults(List<LogRequest> requests) {
        if (requests == null || requests.isEmpty()) {
            return new List<Integration_Log__c>();
        }

        Id monitoringQueueId = getIntegrationMonitoringQueueId();
        List<Integration_Log__c> logsToInsert = new List<Integration_Log__c>();
        Map<Id, Case> caseUpdatesById = new Map<Id, Case>();

        for (LogRequest request : requests) {
            if (request == null) {
                continue;
            }

            Integration_Log__c logRecord = buildLogRecord(request, monitoringQueueId);
            logsToInsert.add(logRecord);

            if (request.relatedCaseId != null) {
                caseUpdatesById.put(request.relatedCaseId, buildCaseUpdate(request));
            }
        }

        if (!logsToInsert.isEmpty()) {
            insert logsToInsert;
        }

        if (!caseUpdatesById.isEmpty()) {
            update caseUpdatesById.values();
        }

        return logsToInsert;
    }

    private static Integration_Log__c buildLogRecord(LogRequest request, Id monitoringQueueId) {
        Integration_Log__c logRecord = new Integration_Log__c(
            Related_Case__c = request.relatedCaseId,
            External_System__c = request.externalSystem,
            Status__c = request.status,
            Status_Code__c = request.statusCode == null
                ? null
                : Decimal.valueOf(String.valueOf(request.statusCode)),
            Message__c = request.message,
            Retry_Count__c = request.retryCount == null
                ? 0
                : Decimal.valueOf(String.valueOf(request.retryCount)),
            Last_Attempted_At__c = System.now()
        );

        if (monitoringQueueId != null) {
            logRecord.OwnerId = monitoringQueueId;
        }

        return logRecord;
    }

    private static Case buildCaseUpdate(LogRequest request) {
        Case caseUpdate = new Case(
            Id = request.relatedCaseId,
            Integration_Status__c = toCaseIntegrationStatus(request.status)
        );

        if (!String.isBlank(request.externalReference)) {
            caseUpdate.External_System_Id__c = request.externalReference;
        }

        return caseUpdate;
    }

    private static String toCaseIntegrationStatus(String logStatus) {
        if (logStatus == 'Success') {
            return 'Synced';
        }

        if (logStatus == 'Error') {
            return 'Error';
        }

        return 'Pending';
    }

    private static Id getIntegrationMonitoringQueueId() {
        List<Group> queues = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = :INTEGRATION_MONITORING_QUEUE
            LIMIT 1
        ];

        return queues.isEmpty() ? null : queues[0].Id;
    }
}
