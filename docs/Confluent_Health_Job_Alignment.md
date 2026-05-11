# Confluent Health Salesforce Developer Alignment

## Job Posting Themes

The Confluent Health posting emphasizes a broad Salesforce platform role, not only Apex.

Key themes from the posting:

- Salesforce administration and optimization
- User setup, security controls, profiles, roles, permission sets, and data access
- Flow, Process Builder, and declarative automation
- Objects, fields, record types, page layouts, and Lightning apps
- Data integrity, governance, deduplication, cleansing, reporting, and analytics
- Integrations with enterprise systems, API monitoring, and proactive error handling
- User enablement, training, documentation, and adoption
- Apex, Visualforce, and Lightning Web Components
- Sales Cloud, Service Cloud, Marketing Cloud, Health Cloud, Data Cloud, and Omnichannel
- Compliance awareness: HIPAA, SOC 2, and GDPR

## Project Pivot

The project is now positioned as:

**SupportFlow HealthOps CRM**

This is a healthcare operations Salesforce application for managing patient and clinic support requests, service SLAs, data quality, integration monitoring, compliance flags, and operational reporting.

We are keeping the original `SupportFlow CRM` app because the metadata is already deployed and the name still works, but the business story now targets healthcare operations instead of generic customer support.

## How The Existing Project Already Matches

### Salesforce Administration

Already included:

- Lightning app metadata
- Custom tabs
- Admin profile app visibility
- Object permissions
- Field-level security

Future additions:

- Dedicated permission sets for support agents and support managers
- Role/data-access model notes
- User adoption documentation

### Custom Objects, Fields, And Lightning Apps

Already included:

- `Support_Plan__c`
- `Product__c`
- `Case_Feedback__c`
- `Integration_Log__c`
- Custom fields on `Account`
- Custom fields on `Case`
- `SupportFlow CRM` Lightning app

### Service Cloud Alignment

Already included:

- Standard `Case` object
- Case request types
- SLA due date
- Escalation flag and reason
- Case feedback
- Tasks for future follow-up automation

Future additions:

- Case routing logic
- Escalation automation
- Support queues
- Reports and dashboards

### Health Cloud / Healthcare Operations Alignment

Added healthcare-oriented fields:

- `Case.Request_Type__c`
- `Case.Clinic_Location__c`
- `Case.Contains_PHI__c`
- `Case.Compliance_Category__c`

These fields let us discuss patient support, clinic operations, PHI awareness, and compliance-sensitive handling without pretending to fully implement Salesforce Health Cloud.

### Data Governance

Added:

- `Account.External_System_Id__c`
- `Account.Data_Quality_Status__c`
- `Case.External_System_Id__c`

Future additions:

- Duplicate detection/reporting
- Validation rules
- Data quality dashboard
- Cleansing workflow notes

### Integrations

Added:

- `Case.Integration_Status__c`
- `Integration_Log__c`
- Integration log status, status code, retry count, message, related case, external system, and last attempt time

Future Apex additions:

- Integration service class
- Mock HTTP callout
- Error logging
- Retry scheduling
- Tests using `HttpCalloutMock`

### Flow And Declarative Automation

Future additions:

- Flow to create follow-up tasks for high-priority cases
- Flow to flag cases containing PHI
- Flow to notify managers of integration errors

### Apex

Future additions:

- Trigger handler pattern
- Case priority service
- SLA calculation service
- Integration logging service
- Scheduled retry/escalation job
- Test data factory
- Meaningful Apex tests

### LWC

Future addition:

- Lightweight Case Health Panel component showing SLA status, integration status, PHI/compliance flag, and related integration log count.

This would directly support the posting's Lightning Web Components requirement.

## Updated Resume Direction

Potential resume bullet after completion:

Built a healthcare operations Salesforce application using custom objects, Service Cloud cases, Flow-ready data modeling, Apex trigger architecture, integration logging, profile and field-level security, validation rules, and reporting to manage patient support requests, SLA escalation, compliance flags, and enterprise system sync errors.

## Updated Interview Story

In an interview, explain the project like this:

> I built SupportFlow HealthOps CRM to model a healthcare support workflow in Salesforce. It uses standard objects like Account, Contact, Case, Task, and custom objects for support plans, products/service lines, case feedback, and integration logs. I designed the schema with field-level security, app visibility, and admin permissions, then planned Apex and Flow automation for routing, SLA escalation, integration error handling, and reporting.

## What We Are Not Claiming

This project does not claim full production-grade Health Cloud, Marketing Cloud, Data Cloud, or Omnichannel implementation.

Instead, it demonstrates the Salesforce platform foundations that map to those areas:

- Healthcare-sensitive case handling
- Compliance-aware fields
- Service Cloud case workflows
- Data governance fields
- Integration logging architecture
- Security and permissions
- Reporting and automation readiness

