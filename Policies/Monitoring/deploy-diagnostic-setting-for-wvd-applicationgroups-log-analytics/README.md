# Deploy Diagnostic Settings for WVD Application Groups to a Log Analytics Workspace

This policy deploys diagnostic settings for WVD Application Groups supporting Log Analytics as a sink point.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcommunity-policy%2Fmaster%2Fpolicies%2FMonitoring%2Fdeploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics%2Fazurepolicy.json)

## Try with PowerShell

````powershell

$Scope = (Get-AzContext).Subscription.Id
$PolicyDefinition = New-AzPolicyDefinition -Name "deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics" -DisplayName "Deploy Diagnostic Settings for WVD Application Groups to Log Analytics workspace" -description "Deploys the diagnostic settings for WVD Application Groups to stream to a regional Log Analytics workspace when any WVD Application Group which is missing these diagnostic settings is created or updated." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics/azurepolicy.parameters.json' -Mode All
New-AzPolicyAssignment -Name "deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics" -DisplayName "Deploy Diagnostic Settings for WVD Application Groups to Log Analytics workspace" -Scope <scope> -PolicyDefinition $PolicyDefinition -effect <DeployIfNotExists|Disabled> -profileName <profileName> -logAnalytics <WorkspaceResourceId> -logsEnabled <True|False>

````

## Try with CLI

````cli

az policy definition create --name 'deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics' --display-name 'Deploy Diagnostic Settings for WVD Application Groups to Log Analytics workspace' --description 'Deploys the diagnostic settings for WVD Application Groups to stream to a regional Log Analytics workspace when any WVD Application Group which is missing these diagnostic settings is created or updated.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Monitoring/deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics/azurepolicy.parameters.json' --mode All

az policy assignment create --name 'deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics' --display-name 'Deploy Diagnostic Settings for WVD Application Groups to Log Analytics workspace' --scope <scope> --params "{ 'effect': { 'value': '<DeployIfNotExists|Disabled>' },'profileName': { 'value': '<profileName>' }, 'logAnalytics': { 'value': '<WorkspaceResourceId>'}, 'logsEnabled': { 'value': '<True|False>' } }" --policy "deploy-diagnostic-setting-for-wvd-applicationgroups-log-analytics"

````
