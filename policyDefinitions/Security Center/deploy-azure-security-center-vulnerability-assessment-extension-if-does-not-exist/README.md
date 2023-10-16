# Deploy Azure Security Center Vulnerability Assessment extension if does not exist

This policy automatically deploys Azure Security Center built-in vulnerability assessment Agent (Qualys) to **Custom** Virtual Machines built from Shared Gallery Image.


## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%Policies%Security%2Fdeploy-vulnerablity-assesment-agent-for-custom-vm%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-asc-vulnerability-agent"  -DisplayName "Deploy Azure Security Center Vulnerability Assessment extension if does not exist" -description "This policy deploy vulnerability assessment agent AzureSecurityCenter to Virtual Machine deployed from Shared Gallery Image." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Security/deploy-vulnerablity-assesment-agent-for-custom-vm/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Security/deploy-vulnerablity-assesment-agent-for-custom-vm/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -galleryRGName <galleryRGName> -galleryName <galleryName> -imageDefinitionName <imageDefinitionName> -imageVersion <imageVersion> -deplomentApiVersion <deplomentApiVersion> -Location <location>  -PolicyDefinition $definition -AssignIdentity
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-asc-vulnerability-agent' --display-name 'Deploy Azure Security Center Vulnerability Assessment extension if does not exist' --description 'This policy deploy vulnerability assessment agent AzureSecurityCenter to Virtual Machine deployed from Shared Gallery Image.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Security/deploy-vulnerablity-assesment-agent-for-custom-vm/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Security/deploy-vulnerablity-assesment-agent-for-custom-vm/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'galleryRGName': { 'value': '<galleryRGName>' }, 'galleryName': { 'value': '<galleryName>' },'imageDefinitionName': { 'value': '<imageDefinitionName>' },'imageVersion': { 'value': '<imageVersion>' },'deplomentApiVersion': { 'value': '<deplomentApiVersion>' } }" --location <location> --policy "deploy-asc-vulnerability-agent" --assign-identity

````
