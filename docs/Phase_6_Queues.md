# Phase 6: Queues

Phase 6 introduces shared record ownership.

In Salesforce, a record can be owned by a user or by a queue. A queue is useful when a team shares responsibility for a type of work.

## Queues Added

### Tier 1 Support

API file:

- `Tier_1_Support.queue-meta.xml`

Supported object:

- `Case`

Business purpose:

- General healthcare support requests that can be handled by the first support team.

### Escalation Support

API file:

- `Escalation_Support.queue-meta.xml`

Supported object:

- `Case`

Business purpose:

- Higher-priority or escalated cases that need a specialist or manager queue.

### Integration Monitoring

API file:

- `Integration_Monitoring.queue-meta.xml`

Supported object:

- `Integration_Log__c`

Business purpose:

- Integration failures or retry work that needs technical follow-up.

## Salesforce Concepts

### Record Ownership

Every Case has an owner. That owner can be a user or a queue.

Queues let multiple people work from a shared list of records instead of assigning every record to one person immediately.

### Supported Object

A queue must declare which object types it can own.

For example:

- `Tier 1 Support` can own `Case` records.
- `Integration Monitoring` can own `Integration_Log__c` records.

### Why This Comes Before Automation

Automation needs a destination.

Before we build a Flow or Apex trigger that routes records, we need queues for the automation to route records into.

## Platform Value

Queues support shared ownership, operational visibility, and Service Cloud-style work distribution. They control who can work on records and how support teams share workloads.

## Deployment Command

```powershell
sf project deploy start --source-dir force-app\main\default\queues --target-org CareOpsDev
```

## Checkpoint Result

Deployment succeeded for:

- `Tier_1_Support`
- `Escalation_Support`
- `Integration_Monitoring`

Verification confirmed:

- `Tier_1_Support` supports `Case`
- `Escalation_Support` supports `Case`
- `Integration_Monitoring` supports `Integration_Log__c`

## Verification Commands

```powershell
sf data query --query "SELECT Id, DeveloperName, Name, Type FROM Group WHERE Type = 'Queue' AND DeveloperName IN ('Tier_1_Support','Escalation_Support','Integration_Monitoring') ORDER BY DeveloperName" --target-org CareOpsDev
```

```powershell
sf data query --query "SELECT Queue.DeveloperName, SobjectType FROM QueueSobject WHERE Queue.DeveloperName IN ('Tier_1_Support','Escalation_Support','Integration_Monitoring') ORDER BY Queue.DeveloperName, SobjectType" --target-org CareOpsDev
```

## Platform Note

Salesforce stores queues as `Group` records with `Type = 'Queue'`.

The supported object mappings are stored in `QueueSobject`.
