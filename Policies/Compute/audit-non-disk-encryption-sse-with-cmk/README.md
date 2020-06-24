# Audit non disk encryption (SSE with CMK)

Audit VMs where not all disks are encrypted with Server Side Encryption with Customer Managed Key.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Faudit-non-disk-encryption-sse-with-cmk%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-non-disk-encryption-sse-with-cmk" -DisplayName "Audit non disk encryption (SSE with CMK)" -description "
Audit VMs where not all disks are encrypted with Server Side Encryption with Customer Managed Key" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-non-disk-encryption-sse-with-cmk/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-non-disk-encryption-sse-with-cmk/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-non-disk-encryption-sse-with-cmk' --display-name 'audit-non-disk-encryption-sse-with-cmk' --description 'Audit non disk encryption (SSE with CMK)' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-non-disk-encryption-sse-with-cmk/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-non-disk-encryption-sse-with-cmk/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-non-disk-encryption-sse-with-cmk" 

````