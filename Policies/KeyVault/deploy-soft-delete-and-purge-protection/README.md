# Enable soft-delete and purge protection on Key Vaults

This Policy will enable soft-delete and purge protection on all Key Vaults.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKeyVault%2Fdeploy-soft-delete-and-purge-protection%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-soft-delete-and-purge-protection" -DisplayName "Enable soft-delete and purge protection on Key Vaults" -description "This Policy will enable soft-delete and purge protection on all Key Vaults." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KeyVault/deploy-soft-delete-and-purge-protection/azurepolicy.rules.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'deploy-soft-delete-and-purge-protection' --display-name 'Enable soft-delete and purge protection on Key Vaults' --description 'This Policy will enable soft-delete and purge protection on all Key Vaults.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KeyVault/deploy-soft-delete-and-purge-protection/azurepolicy.rules.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy 'deploy-soft-delete-and-purge-protection' 

````
