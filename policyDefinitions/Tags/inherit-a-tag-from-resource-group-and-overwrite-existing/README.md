# Inherit Tag From RG Overwrite Existing

This policy inherits the specified tag from the resource group to the resource overwriting the existing tag value.

If the tag value on the resource group matches those specified in the array parameter 'tagValuesToIgnore'. then no tag inheritance occurs.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FTags%2Finherit-tag-from-rg-overwite-existing%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "inherit-tag-from-rg-overwite-existing" -DisplayName "Inherit A Tag From Resource Group And Overwrite Existing" -description "This policy inherits the specified tag from the resource group to the resource overwriting the existing tag value." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Tags/inherit-tag-from-rg-overwite-existing/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Tags/inherit-tag-from-rg-overwite-existing/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'inherit-tag-from-rg-overwite-existing' --display-name 'Inherit A Tag From Resource Group And Overwrite Existing' --description 'This policy inherits the specified tag from the resource group to the resource overwriting the existing tag value.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Tags/inherit-tag-from-rg-overwite-existing/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Tags/inherit-tag-from-rg-overwite-existing/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "inherit-tag-from-rg-overwite-existing" 

````
