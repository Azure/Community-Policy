# Audit SQL server level Auditing settings

Customers enable private endpoint connections to enable private connectivity to Azure SQL Database. This policy audits that private endpoint connections are in use.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Faudit-sql-server-private-endpoint%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-sql-server-private-endpoint" -DisplayName "Audit SQL server level Private Endpoint Connections settings" -description "Audits the existence of Private Endpoint Connections at the server level" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-private-endpoint/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-private-endpoint/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````



## Try with CLI

````cli

az policy definition create --name 'audit-sql-server-private-endpoint' --display-name 'Audit SQL server level Private Endpoint Connections settings' --description 'Audits the existence of Private Endpoint Connections at the server level' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-private-endpoint/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-private-endpoint/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-sql-server-private-endpoint"

````
