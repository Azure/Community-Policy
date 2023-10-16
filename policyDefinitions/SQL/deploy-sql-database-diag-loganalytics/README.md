# Deploy Diagnostic Settings for Azure SQL MI Database to Log Analytics

Deploys the diagnostic settings for Azure SQL Database to stream to a regional Log Analytics Workspace on any Azure SQL MI Database which is missing this diagnostic settings is created or updated.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-policy%2Fmaster%2FPolicies%2FSQL%2Fdeploy-sql-database-diag-loganalytics%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-sql-database-diag-loganalytics" -DisplayName "Deploy Diagnostic Settings for Azure SQL Database to Log Analytics" -description "Deploys the diagnostic settings for Azure SQL Database to stream to a regional Log Analytics Workspace on any Azure SQL Database which is missing this diagnostic settings is created or updated." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/SQL/deploy-sql-database-diag-loganalytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/SQL/deploy-sql-database-diag-loganalytics/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-sql-database-diag-loganalytics' --display-name 'Deploy Diagnostic Settings for Azure SQL Database to Log Analytics' --description 'Deploys the diagnostic settings for Azure SQL Database to stream to a regional Log Analytics Workspace on any Azure SQL Database which is missing this diagnostic settings is created or updated.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/SQL/deploy-sql-database-diag-loganalytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/SQL/deploy-sql-database-diag-loganalytics/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-geo-redundant-storage-account" 

````