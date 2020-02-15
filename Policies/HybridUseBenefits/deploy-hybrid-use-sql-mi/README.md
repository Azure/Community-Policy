# Deploy Hybrid Use for SQL MI

This Policy will enable HUB for SQL Managed Instance.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fdeploy-hybrid-use-sql-mi%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-hybrid-use-sql-mi" -DisplayName "Deploy Hybrid Use for SQL MI" -description "This Policy will enable HUB for SQL Managed Instance." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-mi/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-mi/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-hybrid-use-sql-mi' --display-name 'Deploy Hybrid Use for SQL MI' --description 'This Policy will enable HUB for SQL Managed Instance.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-mi/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/HybridUseBenefits/deploy-hybrid-use-sql-mi/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-hybrid-use-sql-mi" 

````
