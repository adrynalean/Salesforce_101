@IsTest
private class CaseIntegrationSyncJobTest {
    @IsTest
    static void queueableSyncsStandardCase() {
        Case testCase = insertCase('Portal access sync', 'Medium');

        Test.startTest();
        Id jobId = CaseIntegrationSyncJob.enqueue(new Set<Id>{ testCase.Id });
        Test.stopTest();

        Case savedCase = getCase(testCase.Id);
        Integration_Log__c savedLog = getLatestLog(testCase.Id);

        System.assertNotEquals(null, jobId, 'Enqueueing should return an async job id.');
        System.assertEquals('Synced', savedCase.Integration_Status__c);
        System.assertEquals('Success', savedLog.Status__c);
        System.assertEquals(Decimal.valueOf(200), savedLog.Status_Code__c);
    }

    @IsTest
    static void queueableSchedulesRetryForHighPriorityCase() {
        Case testCase = insertCase('Urgent provider sync', 'High');

        Test.startTest();
        CaseIntegrationSyncJob.enqueue(new Set<Id>{ testCase.Id });
        Test.stopTest();

        Case savedCase = getCase(testCase.Id);
        Integration_Log__c savedLog = getLatestLog(testCase.Id);

        System.assertEquals('Pending', savedCase.Integration_Status__c);
        System.assertEquals('Retry Scheduled', savedLog.Status__c);
        System.assertEquals(Decimal.valueOf(429), savedLog.Status_Code__c);
    }

    @IsTest
    static void queueableLogsErrorForRejectedPayload() {
        Case testCase = insertCase('Fail billing sync', 'Medium');

        Test.startTest();
        CaseIntegrationSyncJob.enqueue(new Set<Id>{ testCase.Id });
        Test.stopTest();

        Case savedCase = getCase(testCase.Id);
        Integration_Log__c savedLog = getLatestLog(testCase.Id);

        System.assertEquals('Error', savedCase.Integration_Status__c);
        System.assertEquals('Error', savedLog.Status__c);
        System.assertEquals(Decimal.valueOf(500), savedLog.Status_Code__c);
        System.assertNotEquals(
            null,
            savedCase.External_System_Id__c,
            'Errored integration Cases need an external reference because of the validation rule.'
        );
    }

    @IsTest
    static void queueableHandlesBulkCaseIds() {
        List<Case> cases = new List<Case>{
            newCase('Patient intake sync', 'Medium'),
            newCase('Fail eligibility sync', 'Medium'),
            newCase('Priority referral sync', 'High')
        };
        insert cases;

        Set<Id> caseIds = new Map<Id, Case>(cases).keySet();

        Test.startTest();
        CaseIntegrationSyncJob.enqueue(caseIds);
        Test.stopTest();

        List<Integration_Log__c> logs = [
            SELECT Id
            FROM Integration_Log__c
            WHERE Related_Case__c IN :caseIds
        ];

        Map<Id, Case> savedCases = new Map<Id, Case>([
            SELECT Integration_Status__c
            FROM Case
            WHERE Id IN :caseIds
        ]);

        System.assertEquals(3, logs.size(), 'Each Case should receive one integration log.');
        System.assertEquals('Synced', savedCases.get(cases[0].Id).Integration_Status__c);
        System.assertEquals('Error', savedCases.get(cases[1].Id).Integration_Status__c);
        System.assertEquals('Pending', savedCases.get(cases[2].Id).Integration_Status__c);
    }

    private static Case insertCase(String subject, String priority) {
        Case testCase = newCase(subject, priority);
        insert testCase;
        return testCase;
    }

    private static Case newCase(String subject, String priority) {
        return new Case(
            Subject = subject,
            Status = 'New',
            Origin = 'Phone',
            Priority = priority,
            Request_Type__c = 'Integration Error'
        );
    }

    private static Case getCase(Id caseId) {
        return [
            SELECT Integration_Status__c, External_System_Id__c
            FROM Case
            WHERE Id = :caseId
        ];
    }

    private static Integration_Log__c getLatestLog(Id caseId) {
        return [
            SELECT Status__c, Status_Code__c
            FROM Integration_Log__c
            WHERE Related_Case__c = :caseId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
    }
}
