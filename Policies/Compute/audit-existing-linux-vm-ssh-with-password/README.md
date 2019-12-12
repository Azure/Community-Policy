# Audit existing Linux VMs that use password for SSH authentication

This policy audits whether an existing Linux VM uses password instead of SSH key authentication for SSH. Once deployed, you can see the non-compliant VMs under the [Policy Compliance blade](https://ms.portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyMenuBlade/Compliance) in the Azure Portal. Note, this policy can only determine the configuration of the VM at deployment time. If changes are made to the sshd_config after the VM has been deployed, these updates will not be reflected in the ARM configuration for that VM and this policy will not be able to update its compliance for that VM.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Faudit-existing-linux-vm-ssh-with-password%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Faudit-existing-linux-vm-ssh-with-password%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'audit-existing-linux-vm-ssh-with-password' -DisplayName 'Audit existing Linux VMs that use password for SSH authentication' -description 'This policy audits if a password is being used to authentication to a Linux VM' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-existing-linux-vm-ssh-with-password/azurepolicy.rules.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'audit-existing-linux-vm-ssh-with-password-assignment' -DisplayName 'Audit existing Linux VMs that use password for SSH authentication Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
az policy definition create --name audit-existing-linux-vm-ssh-with-password --display-name "Audit existing Linux VMs that use password for SSH authentication" --description "This policy audits if a password is being used to authentication to a Linux VM" --rules https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-existing-linux-vm-ssh-with-password/azurepolicy.rules.json --mode All

# Create the Policy Assignment
# Set the scope to a resource group; may also be a subscription or management group
az policy assignment create --name 'audit-existing-linux-vm-ssh-with-password-assignment' --display-name "Audit existing Linux VMs that use password for SSH authentication Assignment" --scope /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName> --policy /subscriptions/<subscriptionId>/providers/Microsoft.Authorization/policyDefinitions/audit-existing-linux-vm-ssh-with-password
```