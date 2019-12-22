# Deploy Hybrid Use SQL PaaS

This Policy will enable HUB for any SQL PaaS with the tier of General Purpose, Hyperscale, or Business Critical.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fdeploy-hybrid-use-sql-PaaS%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-hybrid-use-sql-paas" -DisplayName "Deploy Hybrid Use SQL PaaS" -description "This Policy will enable HUB for any SQL PaaS with the tier of General Purpose, Hyperscale, or Business Critical." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-hybrid-use-sql-paas/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-hybrid-use-sql-paas/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-hybrid-use-sql-paas' --display-name 'Deploy Hybrid Use SQL PaaS' --description 'This Policy will enable HUB for any SQL PaaS with the tier of General Purpose, Hyperscale, or Business Critical.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-hybrid-use-sql-paas/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-hybrid-use-sql-paas/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-hybrid-use-sql-paas" 

````
