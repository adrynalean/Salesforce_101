public with sharing class CaseRoutingService {
    private static final String TIER_1_QUEUE = 'Tier_1_Support';
    private static final String ESCALATION_QUEUE = 'Escalation_Support';

    public static void routeCases(List<Case> casesToRoute, Map<Id, Case> oldCaseById, Boolean isInsert) {
        if (casesToRoute == null || casesToRoute.isEmpty()) {
            return;
        }

        Map<String, Id> queueIdByDeveloperName = getQueueIdsByDeveloperName(
            new Set<String>{ TIER_1_QUEUE, ESCALATION_QUEUE }
        );

        Id tier1QueueId = queueIdByDeveloperName.get(TIER_1_QUEUE);
        Id escalationQueueId = queueIdByDeveloperName.get(ESCALATION_QUEUE);

        if (tier1QueueId == null || escalationQueueId == null) {
            return;
        }

        for (Case caseRecord : casesToRoute) {
            if (!shouldRoute(caseRecord, oldCaseById, isInsert)) {
                continue;
            }

            caseRecord.OwnerId = requiresEscalationQueue(caseRecord)
                ? escalationQueueId
                : tier1QueueId;
        }
    }

    private static Boolean shouldRoute(Case caseRecord, Map<Id, Case> oldCaseById, Boolean isInsert) {
        if (isInsert) {
            return true;
        }

        Case oldCase = oldCaseById == null ? null : oldCaseById.get(caseRecord.Id);
        if (oldCase == null) {
            return false;
        }

        return caseRecord.Priority != oldCase.Priority
            || caseRecord.Escalated__c != oldCase.Escalated__c
            || caseRecord.Contains_PHI__c != oldCase.Contains_PHI__c
            || caseRecord.Compliance_Category__c != oldCase.Compliance_Category__c;
    }

    private static Boolean requiresEscalationQueue(Case caseRecord) {
        return caseRecord.Escalated__c == true
            || caseRecord.Priority == 'High'
            || (
                caseRecord.Contains_PHI__c == true
                && caseRecord.Compliance_Category__c == 'HIPAA'
            );
    }

    private static Map<String, Id> getQueueIdsByDeveloperName(Set<String> developerNames) {
        Map<String, Id> queueIdByDeveloperName = new Map<String, Id>();

        for (Group queueRecord : [
            SELECT Id, DeveloperName
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName IN :developerNames
        ]) {
            queueIdByDeveloperName.put(queueRecord.DeveloperName, queueRecord.Id);
        }

        return queueIdByDeveloperName;
    }
}
