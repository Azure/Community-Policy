# Apply Diagnostic Settings for AKS to a Regional Event Hub

This policy automatically deploys diagnostic settings for AKS supporting a regional Event Hub as a sink point. The policy parameters allow for setting specific log settings for each of the AKS sources instead of just all logs. The policy includes parameter defaults that enable all of the logs and metrics.  You can set individual log sources to false to disable them from logging to the eventhub.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FMonitoring%2Fdeploy-diagnostic-setting-for-aks-event-hub%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-diagnostic-setting-for-aks-event-hub" -DisplayName "Apply Diagnostic Settings for AKS to a Regional Event Hub" -description "This policy automatically deploys diagnostic settings for AKS to point to a regional Event Hub." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-aks-event-hub/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-aks-event-hub/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -eventHubRuleId <eventHubRuleId> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-diagnostic-setting-for-aks-event-hub' --display-name 'Apply Diagnostic Settings for AKS to a regional Event Hub' --description 'This policy automatically deploys diagnostic settings to AKS supporting a regional Event Hub.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-aks-event-hub/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-aks-event-hub/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --params "{'eventHubRuleId': { 'value': '<eventHubRuleId>' } }" --policy "deploy-diagnostic-setting-for-aks-event-hub"

````
