# Audit Role Assignments Principal Type

This policy audits for any Role Assignments for a specific Principal Type (e.g. User/Group/ServicePrincipal).

May be used to identify IAM role assignments to Resources/ResourceGroups which are out-of-compliance with Role Based Access Control (RBAC) governance standards. For example - You want to audit where Resources/ResourceGroups  have Users assigned directly to the access control list.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAuthorization%2Faudit-role-assignments-principaltype%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-role-assignments-principaltype" -DisplayName "Audit Role Assignments For Specific Principal Type" -description "This policy audits for any Role Assignments for a specific Principal Type (e.g. User/Group/ServicePrincipal)." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/audit-role-assignments-principaltype/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/audit-role-assignments-principaltype/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-role-assignments-principaltype' --display-name 'Audit Role Assignments For Specific Principal Type' --description 'This policy audits for any Role Assignments for a specific Principal Type (e.g. User/Group/ServicePrincipal).' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/audit-role-assignments-principaltype/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/audit-role-assignments-principaltype/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-role-assignments-principaltype" 

````
