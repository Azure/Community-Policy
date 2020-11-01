# Audit Resource Type For Lock

This policy audits the specified resource type for any lock such as 'CanNotDelete' or 'ReadOnly'.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FAuthorization%2Faudit-resourcetype-for-lock%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-resourcetype-for-lock" -DisplayName "Audit Specified Resource Type For Any Lock" -description "This policy audits the specified resource type for any lock such as 'CanNotDelete' or 'ReadOnly'." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Authorization/audit-resourcetype-for-lock/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Authorization/audit-resourcetype-for-lock/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-resourcetype-for-lock' --display-name 'Audit Specified Resource Type For Any Lock' --description 'This policy audits the specified resource type for any lock such as 'CanNotDelete' or 'ReadOnly'.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Authorization/audit-resourcetype-for-lock/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Authorization/audit-resourcetype-for-lock/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-resourcetype-for-lock" 

````
