# Phase 5: Validation Rules

Phase 5 adds business rules without Apex.

Validation rules are declarative Salesforce logic. They run when a user or automation tries to save a record. If the rule formula evaluates to `TRUE`, Salesforce blocks the save and shows the configured error message.

## Why We Use Validation Rules First

Before writing Apex, a Salesforce developer should ask:

Can this rule be handled with configuration?

If yes, a validation rule is often better because it is easier to maintain, visible to admins, and does not require Apex test coverage.

## Rules Added

### Closed Cases Require Resolution Notes

Object: `Case`

Rule:

- If `Status` is `Closed`
- Then `Resolution_Notes__c` must not be blank

Business reason:

- Support teams need an audit trail showing how a healthcare support request was resolved.

### Escalated Cases Require Reason

Object: `Case`

Rule:

- If `Escalated__c` is checked
- Then `Escalation_Reason__c` must not be blank

Business reason:

- Escalation should be explainable for operations and reporting.

### PHI Cases Require HIPAA Category

Object: `Case`

Rule:

- If `Contains_PHI__c` is checked
- Then `Compliance_Category__c` must be `HIPAA`

Business reason:

- Cases involving protected health information need explicit compliance classification.

### Integration Errors Require External ID

Object: `Case`

Rule:

- If `Integration_Status__c` is `Error`
- Then `External_System_Id__c` must not be blank

Business reason:

- Integration errors are hard to troubleshoot if the external source record cannot be identified.

### Feedback Rating Must Be 1 Through 5

Object: `Case_Feedback__c`

Rule:

- If `Rating__c` is filled in
- Then it must be between `1` and `5`

Business reason:

- Reporting and dashboards depend on clean rating data.

## Salesforce Concepts

### Formula Evaluates To True

A validation rule blocks a save when its formula returns `TRUE`.

That means the formula describes the invalid condition, not the desired condition.

### Error Display Field

The `errorDisplayField` tells Salesforce which field should show the error. This helps users understand where to fix the record.

### Declarative Before Programmatic

This phase is job-aligned because Salesforce roles often expect developers to know when to use Flow, validation rules, page layouts, and security configuration before writing custom Apex.

## Deployment Command

```powershell
sf project deploy start --source-dir force-app\main\default\objects\Case\validationRules --source-dir force-app\main\default\objects\Case_Feedback__c\validationRules --target-org SupportFlowDev
```

## Checkpoint Result

Deployment succeeded for all five validation rules:

- `Closed_Cases_Require_Resolution_Notes`
- `Escalated_Cases_Require_Reason`
- `PHI_Cases_Require_HIPAA_Category`
- `Integration_Errors_Require_External_Id`
- `Rating_Must_Be_One_To_Five`

Verification query confirmed all five rules are active in the org.

One small platform note: a Tooling API query that joined from `ValidationRule` to `EntityDefinition.QualifiedApiName` returned a Salesforce internal error, but a simpler query against `ValidationRule` worked. This is a reminder that Salesforce APIs sometimes have edge cases, and smaller verification queries are often more reliable.
