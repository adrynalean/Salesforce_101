# Phase 4: Record Experience

Phase 4 makes the data model usable for a real support team.

In Salesforce, creating fields is only half the job. Users also need those fields to appear in useful places on record pages. The first Phase 4 checkpoint updates the standard Account and Case page layouts.

## What We Changed

### Account Layout

Added a `SupportFlow HealthOps` section with:

- `Support_Plan__c`
- `Customer_Status__c`
- `Data_Quality_Status__c`
- `External_System_Id__c`

Why this matters:

- Support teams can immediately see which customer support plan applies.
- Admins can track whether account data is clean or needs review.
- Integration work has a stable external identifier for matching records with outside systems.

### Case Layout

Added a `Healthcare Operations` section with:

- `Request_Type__c`
- `Clinic_Location__c`
- `Affected_Product__c`
- `SLA_Due_Date__c`

Added a `Compliance and Integration` section with:

- `Contains_PHI__c`
- `Compliance_Category__c`
- `Escalated__c`
- `Escalation_Reason__c`
- `Integration_Status__c`
- `External_System_Id__c`
- `Resolution_Notes__c`

Why this matters:

- Case workers can see healthcare request context without hunting through Setup or hidden fields.
- Compliance-sensitive work is visible and reportable.
- Integration fields prepare the org for future Apex and API sync logic.

## Salesforce Concepts

### Page Layout

A page layout controls which fields, buttons, related lists, and sections appear on a record page.

The field exists in the database once we deploy the custom field metadata. The field becomes useful to humans when it is placed on a layout.

### Section

A section groups fields into a business-friendly area, such as `Healthcare Operations`.

Good sections make the app easier to use because users can scan the page by workflow instead of reading every field one by one.

### Why This Is Job-Aligned

The Confluent Health posting mentions:

- Customizing and maintaining page layouts
- Optimizing Salesforce environments
- Supporting healthcare operations
- Maintaining data quality and compliance visibility
- Working with integrations and enterprise systems

This phase turns the schema from Phase 3.5 into an actual user experience.

## Deployment Command

```powershell
sf project deploy start --source-dir force-app\main\default\layouts --target-org SupportFlowDev
```

## Checkpoint Result

The first Phase 4 layout deployment succeeded for:

- `Account-Account Layout`
- `Case-Case Layout`

Next Phase 4 candidates:

- Custom object layouts for `Support_Plan__c`, `Product__c`, `Case_Feedback__c`, and `Integration_Log__c`
- Related lists on Case for feedback and integration logs
- A Lightning record page later, once the core metadata is stable
