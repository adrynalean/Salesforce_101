# Salesforce_101

Salesforce learning project for building SupportFlow HealthOps CRM, a portfolio-ready healthcare operations application using Salesforce configuration, security, automation, integrations, reporting, and Apex.

## Project Status

- Phase 1: Complete - Salesforce DX project scaffolded, Salesforce CLI installed, and Developer Edition org authorized as `SupportFlowDev`.
- Phase 2: Complete - Created and deployed the `SupportFlow CRM` Lightning app with initial standard navigation.
- Phase 3: Complete - Created custom objects, fields, lookup relationships, tabs, app navigation updates, and admin permissions.
- Phase 3.5: Complete - Pivoted the data model toward Confluent Health requirements with healthcare operations, compliance, data governance, and integration monitoring fields.
- Phase 4: Complete - Account, Case, and custom object layouts now expose the healthcare operations, compliance, data quality, integration, and relationship navigation fields.

## Phase 2 App Navigation

The initial `SupportFlow CRM` app includes standard Salesforce tabs that already exist in the org:

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

Phase 4 begins by placing the new healthcare operations, compliance, data quality, and integration fields onto Account and Case layouts.

See [Phase 4: Record Experience](docs/Phase_4_Record_Experience.md).

## Job Alignment

This project is now aligned toward the Confluent Health Salesforce Developer posting.

See [Confluent Health Job Alignment](docs/Confluent_Health_Job_Alignment.md).
