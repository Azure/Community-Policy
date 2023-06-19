# Allowed App Services Plans SKU

This policy deploys Diagnostic Settings for App Service to a Log Analytics workspace.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FApp%20Services%2Fdeploy-app-service-diag-log-analytics%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-app-service-diag-log-analytics" -DisplayName "Deploy App Service Diagnostics Settings" -description "This policy deploys Diagnostic Settings for App Service to a Log Analytics workspace" -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/deploy-app-service-diag-log-analytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/deploy-app-service-diag-log-analytics/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'deploy-app-service-diag-log-analytics' --display-name 'Deploy App Service Diagnostics Settings' --description 'This policy deploys Diagnostic Settings for App Service to a Log Analytics workspace' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/deploy-app-service-diag-log-analytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/deploy-app-service-diag-log-analytics/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-app-service-diag-log-analytics" 

````
