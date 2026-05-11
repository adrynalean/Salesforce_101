# Phase 9: Queueable Apex Integration Sync

Phase 9 deepens the Apex side of the project.

The goal is to simulate an asynchronous integration sync for Cases. In real Salesforce orgs, integration work often runs outside the original user transaction so the user does not have to wait for external systems.

## What We Built

### Queueable Job

File:

- `CaseIntegrationSyncJob.cls`

The queueable job implements:

```apex
Queueable
Database.AllowsCallouts
```

`Queueable` lets Salesforce run the work asynchronously.

`Database.AllowsCallouts` marks the job as callout-ready. This phase simulates the external system, but the class is shaped so a real HTTP callout could be added later.

The job itself is intentionally small:

```text
Queueable job -> Sync service -> Integration log service
```

### Sync Service

File:

- `CaseIntegrationSyncService.cls`

The sync service:

- Queries Cases by Id.
- Simulates an external healthcare integration response.
- Builds integration log requests.
- Calls `IntegrationLogService`.

The simulated response rules are:

| Case Condition | Simulated Result |
| --- | --- |
| Subject contains `fail` | `Error`, status code `500` |
| Priority is `High` | `Retry Scheduled`, status code `429` |
| Everything else | `Success`, status code `200` |

### Tests

File:

- `CaseIntegrationSyncJobTest.cls`

The tests verify:

- A standard Case syncs successfully.
- A high-priority Case schedules a retry.
- A rejected payload records an error.
- Bulk Case Ids create one integration log per Case.

## Salesforce Concepts

### Queueable Apex

Queueable Apex is used for work that should happen asynchronously.

Common examples:

- External system syncs
- Long-running calculations
- Chained processing
- Retry jobs
- Work that needs callouts

### Why Not Do This Directly In A Trigger?

Triggers run inside the same transaction as the user save.

If a trigger does too much work, it can:

- Slow down the user.
- Hit governor limits.
- Fail the entire save because an external system is down.

Queueable Apex lets the org save the Case first and process integration work separately.

### `Test.startTest()` And `Test.stopTest()`

Async Apex behaves differently in tests.

In a test method:

```apex
Test.startTest();
CaseIntegrationSyncJob.enqueue(caseIds);
Test.stopTest();
```

Salesforce runs the queued job during `Test.stopTest()`.

That is why the tests can query the Case and `Integration_Log__c` afterward and assert the results.

### Service Reuse

This phase reuses `IntegrationLogService` from Phase 8.

That matters because the queueable job should not duplicate logging behavior. It should call the existing service that already knows how to:

- Create `Integration_Log__c`
- Update Case integration status
- Assign logs to the monitoring queue
- Respect the validation rule requiring external IDs for errored Cases

## Platform Concepts Demonstrated

This phase demonstrates:

- Queueable Apex
- Async transaction design
- Callout-ready architecture
- Service-layer separation
- Bulk-safe processing
- Unit testing async Apex
- Integration monitoring and retry concepts

## Deployment Command

```powershell
sf project deploy start --source-dir force-app\main\default\classes --target-org CareOpsDev --test-level RunSpecifiedTests --tests CaseIntegrationSyncJobTest
```

## Checkpoint Result

Deployment succeeded in the `CareOpsDev` org.

- Deploy ID: `0AfdL00000aLZpFSAW`
- Test class: `CaseIntegrationSyncJobTest`
- Passing tests: 4
- Failing tests: 0
- Follow-up combined Apex test run ID: `707dL000018FD0K`

This means Salesforce accepted the queueable Apex integration sync and proved the async behavior with unit tests.
