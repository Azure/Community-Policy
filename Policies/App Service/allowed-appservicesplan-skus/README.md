# Allowed App Services Plans SKU

This policy defines a white list of SKU that can be used when creating an App Services Plan.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FApp%20Services%2Fallowed-appservicesplan-skus%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "allowed-appservicesplan-skus" -DisplayName "Allowed Role Definitions" -description "This policy defines a white list of role definitions that can be used in IAM" -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/allowed-role-definitions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/allowed-role-definitions/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'allowed-role-definitions' --display-name 'Allowed Role Definitions' --description 'This policy defines a white list of role deffnitions that can be used in IAM' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/allowed-role-definitions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/App%20Services/allowed-role-definitions/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-role-definitions" 

````
