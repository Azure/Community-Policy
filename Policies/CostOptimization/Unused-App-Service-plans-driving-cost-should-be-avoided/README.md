# Unused App Service plans driving cost should be avoided
Optimize cost by detecting unused but chargeable resources. Leverage this Policy definition as a cost control to reveal orphaned App Service plans that are driving cost.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCostOptimization%2FUnused-App-Service-plans-driving-cost-should-be-avoided%2Fazurepolicy.json)

## Try with Powershell

````powershell
$definition = New-AzPolicyDefinition -Name "Audit-ServerFarms-UnusedResourcesCostOptimization" -DisplayName "Unused App Service plans driving cost should be avoided" -description "Optimize cost by detecting unused but chargeable resources. Leverage this Policy definition as a cost control to reveal orphaned App Service plans that are driving cost." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CostOptimization/Unused-App-Service-plans-driving-cost-should-be-avoided/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CostOptimization/Unused-App-Service-plans-driving-cost-should-be-avoided/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli
az policy definition create --name 'Audit-ServerFarms-UnusedResourcesCostOptimization' --display-name 'Unused App Service plans driving cost should be avoided' --description 'Optimize cost by detecting unused but chargeable resources. Leverage this Policy definition as a cost control to reveal orphaned App Service plans that are driving cost.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CostOptimization/Unused-App-Service-plans-driving-cost-should-be-avoided/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CostOptimization/Unused-App-Service-plans-driving-cost-should-be-avoided/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "Audit-ServerFarms-UnusedResourcesCostOptimization" 
````