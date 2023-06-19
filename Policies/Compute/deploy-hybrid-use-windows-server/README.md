# Deploy hybrid use for Windows Server

This Policy will enable HUB for Windows Server images published by Microsoft. For 3rd party images that support HUB the policy will need to be extended.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FHybridUseBenefits%2Fdeploy-hybrid-use-windows-server%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-hybrid-use-windows-server" -DisplayName "Deploy hybrid use for Windows Server" -description "This Policy will enable HUB for Windows Server images published by Microsoft. For 3rd party images that support HUB the policy will need to be extended." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/HybridUseBenefits/deploy-hybrid-use-windows-server/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/HybridUseBenefits/deploy-hybrid-use-windows-server/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-hybrid-use-windows-server' --display-name 'Deploy hybrid use for Windows Server' --description 'This Policy will enable HUB for Windows Server images published by Microsoft. For 3rd party images that support HUB the policy will need to be extended.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/HybridUseBenefits/deploy-hybrid-use-windows-server/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/HybridUseBenefits/deploy-hybrid-use-windows-server/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-hybrid-use-windows-server" 

````
