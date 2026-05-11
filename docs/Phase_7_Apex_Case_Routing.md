# Phase 7: Apex Case Routing

Phase 7 adds the first Apex automation.

The goal is to route Cases into the right queue automatically. This builds on the queues from Phase 6.

## What We Built

### Trigger

File:

- `CaseTrigger.trigger`

The trigger runs:

- `before insert`
- `before update`

The trigger does not contain business logic. It delegates to `CaseTriggerHandler`.

### Handler

File:

- `CaseTriggerHandler.cls`

The handler receives trigger context and calls the service class.

### Service

File:

- `CaseRoutingService.cls`

The service contains the business logic:

- Normal Cases route to `Tier_1_Support`.
- High-priority Cases route to `Escalation_Support`.
- HIPAA/PHI Cases route to `Escalation_Support`.
- Updated Cases reroute when routing fields change.

### Tests

File:

- `CaseRoutingServiceTest.cls`

The tests verify:

- Normal Case -> Tier 1 Support queue
- High-priority Case -> Escalation Support queue
- PHI/HIPAA Case -> Escalation Support queue
- Case update can reroute when priority changes

## Salesforce Concepts

### Apex Trigger

An Apex trigger runs automatically when records are inserted, updated, deleted, or undeleted.

This trigger uses `before insert` and `before update` because it changes the Case `OwnerId` before Salesforce saves the record.

### Trigger Handler

A trigger handler keeps the trigger small.

This is a common Salesforce pattern:

```text
Trigger -> Handler -> Service
```

### Bulk-Safe Apex

Salesforce can save many records in one transaction.

Bulk-safe code works with lists and maps instead of assuming only one record is being saved.

This phase queries the queues once, stores them in a map, and then loops through all Cases.

### SOQL

SOQL is Salesforce Object Query Language.

This phase uses SOQL to query queue `Group` records:

```apex
SELECT Id, DeveloperName
FROM Group
WHERE Type = 'Queue'
AND DeveloperName IN :developerNames
```

## Platform Concepts Demonstrated

This phase demonstrates:

- Apex triggers
- SOQL
- Bulk-safe service logic
- Unit tests
- Service Cloud-style Case routing
- Queue-based ownership

## Deployment Command

```powershell
sf project deploy start --source-dir force-app\main\default\classes --source-dir force-app\main\default\triggers --target-org SupportFlowDev --test-level RunSpecifiedTests --tests CaseRoutingServiceTest
```

## Checkpoint Result

Deployment succeeded in the `SupportFlowDev` org.

- Deploy ID: `0AfdL00000aJwl8SAC`
- Test class: `CaseRoutingServiceTest`
- Passing tests: 4
- Failing tests: 0
- Follow-up test run ID: `707dL000018Cp34`

This means Salesforce accepted the Apex metadata and the org proved the routing behavior through tests before the code was deployed.
