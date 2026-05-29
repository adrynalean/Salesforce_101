# CareOps CRM

Salesforce learning project for building CareOps CRM, a healthcare operations application using Salesforce configuration, security, automation, integrations, reporting, and Apex.

## Project Status

- Phase 1: Complete - Salesforce DX project scaffolded, Salesforce CLI installed, and Developer Edition org authorized as `CareOpsDev`.
- Phase 2: Complete - Created and deployed the `CareOps CRM` Lightning app with initial standard navigation.
- Phase 3: Complete - Created custom objects, fields, lookup relationships, tabs, app navigation updates, and admin permissions.
- Phase 3.5: Complete - Extended the data model with healthcare operations, compliance, data governance, and integration monitoring fields.
- Phase 4: Complete - Account, Case, and custom object layouts now expose the healthcare operations, compliance, data quality, integration, and relationship navigation fields.
- Phase 5: Complete - Added validation rules to protect data quality and compliance-sensitive fields.
- Phase 6: Complete - Added support queues for shared Case and integration follow-up ownership.
- Phase 7: Complete - Added Apex Case routing automation with a trigger, handler, service class, and passing unit tests.
- Phase 8: Complete - Added an Apex integration logging service that creates monitoring records, updates Case integration status, and includes unit tests.
- Phase 9: Complete - Added Queueable Apex integration sync with async tests and reusable service-layer logic.

## Phase 2 App Navigation

The initial `CareOps CRM` app includes standard Salesforce tabs that already exist in the org:

- Home
- Accounts
- Contacts
- Cases
- Tasks
- Dashboards
- Reports

Custom tabs for Support Plans, Products, and Case Feedback were added after those custom objects were created in Phase 3.

## Phase 3 Data Model

Phase 3 added:

- `Support_Plan__c`
- `Product__c`
- `Case_Feedback__c`
- Custom fields on `Account`
- Custom fields on `Case`
- Custom tabs for the new objects
- Admin profile visibility and field permissions

See [Phase 3: Data Model Notes](docs/Phase_3_Data_Model.md).

## Phase 4 Record Experience

Phase 4 begins by placing this new healthcare operations, compliance, data quality, and integration fields onto Account and Case layouts.

See [Phase 4: Record Experience](docs/Phase_4_Record_Experience.md).

## Phase 5 Validation Rules

Phase 5 adds declarative business rules for case resolution, escalation, PHI classification, integration errors, and feedback ratings.

See [Phase 5: Validation Rules](docs/Phase_5_Validation_Rules.md).

## Phase 6 Queues

Phase 6 adds queues for shared work ownership across support and integration monitoring.

See [Phase 6: Queues](docs/Phase_6_Queues.md).

## Phase 7 Apex Case Routing

Phase 7 adds the first Apex trigger architecture for automatically routing Cases into support queues, including unit tests for the routing scenarios.

See [Phase 7: Apex Case Routing](docs/Phase_7_Apex_Case_Routing.md).

## Phase 8 Integration Logging Service

Phase 8 adds a reusable Apex service for recording external system sync results and updating related Cases.

See [Phase 8: Integration Logging Service](docs/Phase_8_Integration_Logging_Service.md).

## Phase 9 Queueable Apex Integration Sync

Phase 9 adds async Apex that simulates sending Cases to an external healthcare integration hub and records the results.

See [Phase 9: Queueable Apex Integration Sync](docs/Phase_9_Queueable_Apex_Integration_Sync.md).
