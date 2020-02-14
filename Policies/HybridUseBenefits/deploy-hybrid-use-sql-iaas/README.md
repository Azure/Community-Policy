# Deploy Hybrid Use SQL IaaS

This Policy will enable HUB for any SQL IaaS enrolled in the SQL Resource Provider with the SKU of Standard or Enterprise.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fdeploy-hybrid-use-sql-iaas%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-hybrid-use-sql-iaas" -DisplayName "Deploy Hybrid Use SQL IaaS" -description "This Policy will enable HUB for any SQL IaaS enrolled in the SQL Resource Provider with the SKU of Standard or Enterprise." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-iaas/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-iaas/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-hybrid-use-sql-iaas' --display-name 'Deploy Hybrid Use SQL IaaS' --description 'This Policy will enable HUB for any SQL IaaS enrolled in the SQL Resource Provider with the SKU of Standard or Enterprise.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-iaas/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-iaas/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-hybrid-use-sql-iaas" 

````
