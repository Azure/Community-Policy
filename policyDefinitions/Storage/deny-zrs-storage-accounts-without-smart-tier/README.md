# Deny ZRS storage accounts without Smart tier

This policy ensures that all Standard Zone-Redundant Storage (ZRS) accounts use the Smart access tier. The Smart tier automatically optimizes storage costs by intelligently moving data between access tiers based on access patterns. It targets storage accounts with `Standard_ZRS`, `Standard_GZRS`, and `Standard_RAGZRS` SKUs of kind `StorageV2` or `BlobStorage`.

The policy supports the following effects:

- **Deny** (default) – Prevents creation or update of ZRS storage accounts that do not use the Smart tier.
- **Audit** – Logs non-compliant ZRS storage accounts without making changes.
- **Disabled** – Turns off the policy evaluation entirely.

> **Note:** The policy only evaluates requests using API version `2025-08-01` or later, which supports the Smart access tier. Requests made with older API versions are not affected.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FpolicyDefinitions%2FStorage%2Fdeny-zrs-storage-accounts-without-smart-tier%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deny-zrs-storage-accounts-without-smart-tier" -DisplayName "Deny ZRS storage accounts without Smart tier" -description "This policy ensures that all Standard ZRS storage accounts use the Smart access tier." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/Storage/deny-zrs-storage-accounts-without-smart-tier/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/Storage/deny-zrs-storage-accounts-without-smart-tier/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deny-zrs-storage-accounts-without-smart-tier' --display-name 'Deny ZRS storage accounts without Smart tier' --description 'This policy ensures that all Standard ZRS storage accounts use the Smart access tier.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/Storage/deny-zrs-storage-accounts-without-smart-tier/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/Storage/deny-zrs-storage-accounts-without-smart-tier/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deny-zrs-storage-accounts-without-smart-tier" 

````
