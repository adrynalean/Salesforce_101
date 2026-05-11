public with sharing class CaseTriggerHandler {
    public static void beforeSave(List<Case> newCases, Map<Id, Case> oldCaseById, Boolean isInsert) {
        CaseRoutingService.routeCases(newCases, oldCaseById, isInsert);
    }
}
