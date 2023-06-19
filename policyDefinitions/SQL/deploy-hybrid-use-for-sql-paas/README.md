# Deploy Hybrid Use For SQL PaaS

This Policy will enable HUB for Azure SQL with the tier of General Purpose, Hyperscale, or Business Critical. This does not work for Elastic Pools or for SQL MI.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fdeploy-hybrid-use-sql-PaaS%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-hybrid-use-sql-paas" -DisplayName "Deploy Hybrid Use For SQL PaaS" -description "This Policy will enable HUB for Azure SQL with the tier of General Purpose, Hyperscale, or Business Critical. This does not work for Elastic Pools or for SQL MI." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-paas/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-paas/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-hybrid-use-sql-paas' --display-name 'Deploy Hybrid Use For SQL PaaS' --description 'This Policy will enable HUB for Azure SQL with the tier of General Purpose, Hyperscale, or Business Critical. This does not work for Elastic Pools or for SQL MI.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-paas/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-paas/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-hybrid-use-sql-paas" 

````
