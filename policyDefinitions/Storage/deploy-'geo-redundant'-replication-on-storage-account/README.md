# Deploy geo-redundant storage accounts

This policy deploy a geo-redundant storage accounts.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-policy%2Fmaster%2FPolicies%2FStorage%2Fdeploy-geo-redundant-replication%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-geo-redundant-storage-accounts" -DisplayName "Deploy geo-redundant storage account" -description "This policy deploy a geo-redundant storage accounts" -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-geo-redundant-replication/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-geo-redundant-replication/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-geo-redundant-storage-accounts' --display-name 'Deploy geo-redundant storage account' --description 'This policy deploy a geo-redundant storage accounts' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-geo-redundant-replication/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-geo-redundant-replication/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-geo-redundant-storage-account" 

````