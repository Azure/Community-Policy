# Enforce SQL Server Minimum TLS Version to 1.2

This policy requires the Minimum TLS Version for a SQL Server is set to 1.2 when the REST API used for the deployment is later than 2015-05-01-preview.
Otherwise the creation is denied.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fenforce-sql-minimum-tls-version%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "enforce-sql-minimum-tls-version" -DisplayName "Enforce 1.2 as Minimum TLS Version for SQL Server" -description "Will set the Minimum TLS Version for a SQL Server to 1.2 or deny creation (when older API versions are used for deployment)" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/enforce-sql-minimum-tls-version/azurepolicy.rules.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'enforce-sql-minimum-tls-version' --display-name 'Enforce 1.2 as Minimum TLS Version for SQL Server' --description 'Will set the Minimum TLS Version for a SQL Server to 1.2 or deny creation (when older API versions are used for deployment)' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/enforce-sql-minimum-tls-version/azurepolicy.rules.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-sql-database-collation" 

````