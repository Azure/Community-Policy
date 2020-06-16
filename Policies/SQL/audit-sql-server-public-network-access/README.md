# Audit SQL server level Public Network Access settings

Customers use public network access property to control public vs private connectivity to Azure SQL Database. This policy audits that public network access property is set to 'Disabled' so that no public connectivity is allowed.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Faudit-sql-server-public-network-access%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-sql-server-public-network-access" -DisplayName "Audit SQL server level Public Network Access setting" -description "Audits the existence of Public Network Access at the server level" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-public-network-access/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-public-network-access/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````



## Try with CLI

````cli

az policy definition create --name 'audit-sql-server-public-network-access' --display-name 'Audit SQL server level Public Network Access setting' --description 'Audits the existence of Public Network Access at the server level' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-public-network-access/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-public-network-access/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-sql-server-public-network-access"

````
