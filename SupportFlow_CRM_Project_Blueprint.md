# SupportFlow HealthOps CRM Project Blueprint

## 1. Project Summary

SupportFlow HealthOps CRM is a Salesforce learning project that models a healthcare operations support workflow.

The app uses standard Salesforce objects, custom objects, validation rules, queues, Apex triggers, Apex services, Queueable Apex, and Apex tests to manage support cases, compliance context, integration status, and operational follow-up.

The goal is to build a realistic Salesforce application that can be understood from the platform foundation up through Apex automation.

## 2. Core Domain

The app centers on healthcare support operations:

- Accounts represent customer organizations or clinics.
- Contacts represent people connected to those organizations.
- Cases represent support requests.
- Support Plans define response and escalation expectations.
- Products represent services or systems affected by support requests.
- Case Feedback records customer feedback after resolution.
- Integration Logs record external system sync results.

## 3. Architecture Layers

```text
Salesforce DX Project
  Metadata configuration
    Objects and fields
    Tabs and app navigation
    Page layouts
    Validation rules
    Queues
    Profile permissions
  Apex logic
    Case trigger
    Trigger handler
    Case routing service
    Integration logging service
    Queueable integration sync job
    Integration sync service
    Apex tests
```

## 4. Data Model

### Standard Objects

- `Account`
- `Contact`
- `Case`
- `Task`

### Custom Objects

- `Support_Plan__c`
- `Product__c`
- `Case_Feedback__c`
- `Integration_Log__c`

### Important Custom Fields

Account:

- `Support_Plan__c`
- `Customer_Status__c`
- `Data_Quality_Status__c`
- `External_System_Id__c`

Case:

- `Affected_Product__c`
- `Request_Type__c`
- `Clinic_Location__c`
- `Contains_PHI__c`
- `Compliance_Category__c`
- `External_System_Id__c`
- `Integration_Status__c`
- `SLA_Due_Date__c`
- `Escalated__c`
- `Escalation_Reason__c`
- `Resolution_Notes__c`

Integration Log:

- `Related_Case__c`
- `External_System__c`
- `Status__c`
- `Status_Code__c`
- `Message__c`
- `Retry_Count__c`
- `Last_Attempted_At__c`

## 5. User Experience

The `SupportFlow CRM` Lightning app includes navigation for:

- Home
- Accounts
- Contacts
- Cases
- Tasks
- Dashboards
- Reports
- Support Plans
- Products
- Case Feedback
- Integration Logs

Page layouts expose the fields that matter for healthcare operations, compliance review, integration monitoring, and support follow-up.

## 6. Business Rules

Validation rules protect data quality:

- Closed Cases require resolution notes.
- Escalated Cases require an escalation reason.
- Cases containing PHI must use the HIPAA compliance category.
- Integration error Cases require an external system ID.
- Case feedback ratings must be between 1 and 5.

## 7. Shared Ownership

Queues support shared work management:

- `Tier_1_Support` owns standard support Cases.
- `Escalation_Support` owns high-priority or escalated Cases.
- `Integration_Monitoring` owns integration log follow-up work.

## 8. Apex Automation

### Case Routing

`CaseTrigger.trigger` runs before Case insert and update.

The trigger delegates to:

```text
CaseTriggerHandler -> CaseRoutingService
```

`CaseRoutingService` routes Cases to support queues based on priority, escalation, and compliance context.

### Integration Logging

`IntegrationLogService` creates `Integration_Log__c` records and updates related Case integration status.

The service accepts structured `LogRequest` objects so callers can log one or many integration results in a bulk-safe way.

### Queueable Integration Sync

`CaseIntegrationSyncJob` runs integration sync work asynchronously.

The job delegates to:

```text
CaseIntegrationSyncJob -> CaseIntegrationSyncService -> IntegrationLogService
```

The current sync service simulates external system results:

- Standard Case sync: success
- High-priority Case sync: retry scheduled
- Subject containing `fail`: error

## 9. Testing Strategy

Apex tests verify the automation:

- `CaseRoutingServiceTest`
- `IntegrationLogServiceTest`
- `CaseIntegrationSyncJobTest`

The tests cover:

- Trigger-driven Case routing
- Service-layer integration logging
- Async Queueable Apex execution
- Bulk processing
- Validation-rule interaction

## 10. Learning Path

The project is designed to be studied in this order:

1. Salesforce DX project structure
2. Metadata XML for objects, fields, layouts, tabs, queues, and profiles
3. Standard objects versus custom objects
4. Validation rules and declarative business logic
5. Record ownership and queues
6. Apex trigger basics
7. Handler and service class patterns
8. SOQL and DML
9. Apex tests
10. Queueable Apex and async processing

## 11. Current Phase Status

- Phase 1: Salesforce DX setup and org authorization
- Phase 2: Lightning app navigation
- Phase 3: Data model and object configuration
- Phase 4: Record layouts
- Phase 5: Validation rules
- Phase 6: Queues
- Phase 7: Apex Case routing
- Phase 8: Apex integration logging service
- Phase 9: Queueable Apex integration sync

## 12. Future Enhancements

Possible next phases:

- Batch Apex to retry failed integration logs.
- Scheduled Apex to run nightly integration health checks.
- Apex REST endpoint for external case creation or updates.
- Lightning Web Component for an integration monitoring console.
- Reports and dashboards for Case volume, SLA risk, feedback, and integration failures.
