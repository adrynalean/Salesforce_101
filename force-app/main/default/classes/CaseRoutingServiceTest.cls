@IsTest
private class CaseRoutingServiceTest {
    @IsTest
    static void routesNormalCasesToTierOneQueue() {
        Case newCase = new Case(
            Subject = 'Patient portal question',
            Status = 'New',
            Origin = 'Phone',
            Priority = 'Medium',
            Request_Type__c = 'Patient Support'
        );

        Test.startTest();
        insert newCase;
        Test.stopTest();

        Case savedCase = [
            SELECT OwnerId
            FROM Case
            WHERE Id = :newCase.Id
        ];

        System.assertEquals(
            getQueueId('Tier_1_Support'),
            savedCase.OwnerId,
            'Normal support cases should start in the Tier 1 Support queue.'
        );
    }

    @IsTest
    static void routesHighPriorityCasesToEscalationQueue() {
        Case newCase = new Case(
            Subject = 'Clinic outage',
            Status = 'New',
            Origin = 'Phone',
            Priority = 'High',
            Request_Type__c = 'Provider Support'
        );

        Test.startTest();
        insert newCase;
        Test.stopTest();

        Case savedCase = [
            SELECT OwnerId
            FROM Case
            WHERE Id = :newCase.Id
        ];

        System.assertEquals(
            getQueueId('Escalation_Support'),
            savedCase.OwnerId,
            'High-priority cases should route to the Escalation Support queue.'
        );
    }

    @IsTest
    static void routesHipaaPhiCasesToEscalationQueue() {
        Case newCase = new Case(
            Subject = 'Patient record access issue',
            Status = 'New',
            Origin = 'Phone',
            Priority = 'Medium',
            Request_Type__c = 'Patient Support',
            Contains_PHI__c = true,
            Compliance_Category__c = 'HIPAA'
        );

        Test.startTest();
        insert newCase;
        Test.stopTest();

        Case savedCase = [
            SELECT OwnerId
            FROM Case
            WHERE Id = :newCase.Id
        ];

        System.assertEquals(
            getQueueId('Escalation_Support'),
            savedCase.OwnerId,
            'Cases containing PHI with HIPAA classification should route to escalation.'
        );
    }

    @IsTest
    static void reroutesCaseWhenPriorityBecomesHigh() {
        Case newCase = new Case(
            Subject = 'Insurance authorization delay',
            Status = 'New',
            Origin = 'Phone',
            Priority = 'Medium',
            Request_Type__c = 'Insurance Authorization'
        );
        insert newCase;

        newCase.Priority = 'High';

        Test.startTest();
        update newCase;
        Test.stopTest();

        Case savedCase = [
            SELECT OwnerId
            FROM Case
            WHERE Id = :newCase.Id
        ];

        System.assertEquals(
            getQueueId('Escalation_Support'),
            savedCase.OwnerId,
            'Cases should reroute when routing fields change.'
        );
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
