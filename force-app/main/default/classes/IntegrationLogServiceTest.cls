@IsTest
private class IntegrationLogServiceTest {
    @IsTest
    static void successResultCreatesLogAndMarksCaseSynced() {
        Case testCase = insertCase('Patient portal sync');

        Test.startTest();
        List<Integration_Log__c> logs = IntegrationLogService.logCaseResults(new List<IntegrationLogService.LogRequest>{
            new IntegrationLogService.LogRequest(
                testCase.Id,
                'EHR',
                'EHR-1001',
                'Success',
                200,
                'Patient support case synced successfully.',
                0
            )
        });
        Test.stopTest();

        Case savedCase = getCase(testCase.Id);
        Integration_Log__c savedLog = getLog(logs[0].Id);

        System.assertEquals('Synced', savedCase.Integration_Status__c);
        System.assertEquals('EHR-1001', savedCase.External_System_Id__c);
        System.assertEquals('Success', savedLog.Status__c);
        System.assertEquals(Decimal.valueOf(200), savedLog.Status_Code__c);
        System.assertEquals(getQueueId('Integration_Monitoring'), savedLog.OwnerId);
    }

    @IsTest
    static void errorResultCreatesLogAndMarksCaseErrored() {
        Case testCase = insertCase('Authorization integration failure');

        Test.startTest();
        List<Integration_Log__c> logs = IntegrationLogService.logCaseResults(new List<IntegrationLogService.LogRequest>{
            new IntegrationLogService.LogRequest(
                testCase.Id,
                'Billing Platform',
                'BILL-9001',
                'Error',
                500,
                'Billing platform rejected the authorization payload.',
                1
            )
        });
        Test.stopTest();

        Case savedCase = getCase(testCase.Id);
        Integration_Log__c savedLog = getLog(logs[0].Id);

        System.assertEquals('Error', savedCase.Integration_Status__c);
        System.assertEquals('BILL-9001', savedCase.External_System_Id__c);
        System.assertEquals('Error', savedLog.Status__c);
        System.assertEquals(Decimal.valueOf(1), savedLog.Retry_Count__c);
    }

    @IsTest
    static void retryScheduledKeepsCasePending() {
        Case testCase = insertCase('Eligibility retry');

        Test.startTest();
        List<Integration_Log__c> logs = IntegrationLogService.logCaseResults(new List<IntegrationLogService.LogRequest>{
            new IntegrationLogService.LogRequest(
                testCase.Id,
                'Eligibility API',
                'ELIG-2202',
                'Retry Scheduled',
                429,
                'Rate limit reached. Retry scheduled.',
                2
            )
        });
        Test.stopTest();

        Case savedCase = getCase(testCase.Id);
        Integration_Log__c savedLog = getLog(logs[0].Id);

        System.assertEquals('Pending', savedCase.Integration_Status__c);
        System.assertEquals('Retry Scheduled', savedLog.Status__c);
        System.assertEquals(Decimal.valueOf(2), savedLog.Retry_Count__c);
    }

    @IsTest
    static void bulkRequestsCreateMultipleLogs() {
        List<Case> cases = new List<Case>{
            newCase('Clinic system sync'),
            newCase('Provider directory sync')
        };
        insert cases;

        Test.startTest();
        List<Integration_Log__c> logs = IntegrationLogService.logCaseResults(new List<IntegrationLogService.LogRequest>{
            new IntegrationLogService.LogRequest(
                cases[0].Id,
                'EHR',
                'EHR-2001',
                'Success',
                200,
                'First case synced.',
                0
            ),
            new IntegrationLogService.LogRequest(
                cases[1].Id,
                'Provider Directory',
                'PD-2002',
                'Warning',
                202,
                'Provider directory accepted the case with warnings.',
                0
            )
        });
        Test.stopTest();

        System.assertEquals(2, logs.size(), 'Bulk service calls should create one log per request.');

        Set<Id> caseIds = new Map<Id, Case>(cases).keySet();
        Map<Id, Case> savedCases = new Map<Id, Case>([
            SELECT Integration_Status__c
            FROM Case
            WHERE Id IN :caseIds
        ]);

        System.assertEquals('Synced', savedCases.get(cases[0].Id).Integration_Status__c);
        System.assertEquals('Pending', savedCases.get(cases[1].Id).Integration_Status__c);
    }

    private static Case insertCase(String subject) {
        Case testCase = newCase(subject);
        insert testCase;
        return testCase;
    }

    private static Case newCase(String subject) {
        return new Case(
            Subject = subject,
            Status = 'New',
            Origin = 'Phone',
            Priority = 'Medium',
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

    private static Integration_Log__c getLog(Id logId) {
        return [
            SELECT OwnerId, Status__c, Status_Code__c, Retry_Count__c
            FROM Integration_Log__c
            WHERE Id = :logId
        ];
    }

    private static Id getQueueId(String developerName) {
        return [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = :developerName
            LIMIT 1
        ].Id;
    }
}
