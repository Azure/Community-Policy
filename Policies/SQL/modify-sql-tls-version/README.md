# Modify SQL Server TLS Version

This policy leverages the modify operation to change existing Azure SQL DB Server TLS versions. For example, the policy can modify SQL Servers with TLS Version 1.0 to use TLS Version 1.2 

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fmodify-sql-tls-version%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "modify-Azure-SQLDB-tls-version" -DisplayName "Modify existing Azure SQL DB TLS setting" -description "This policy leverages the modify operation to change existing Azure SQL DB Server TLS versions" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/modify-sql-tls-version/azurepolicy.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'modify-Azure-SQLDB-tls-version' --display-name 'Modify existing Azure SQL DB TLS setting' --description 'This policy leverages the modify operation to change existing Azure SQL DB Server TLS versions' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/modify-sql-tls-version/azurepolicy.rules.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "Modify existing Azure SQL DB TLS setting" 

````