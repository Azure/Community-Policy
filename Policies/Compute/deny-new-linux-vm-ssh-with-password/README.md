# Deny creation of Linux VMs that use password for SSH authentication

This policy denies the creation of Linux VMs which use password instead of SSH key authentication for SSH. Use of SSH key is more secure than passwords. The policy checks if the VM Publisher and Offer are in a list of known Linux offers.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fdeny-new-linux-vm-ssh-with-password%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fdeny-new-linux-vm-ssh-with-password%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzureRMPolicyDefinition -Name 'deny-new-linux-vm-ssh-with-password' -DisplayName 'Deny creation of Linux VMs that use password for SSH authentication' -description 'This policy denies the creation of a Linux VM if a password is being used to authentication' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deny-new-linux-vm-ssh-with-password/azurepolicy.rules.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzureRMResourceGroup -Name 'YourResourceGroup'

# Create the Policy Assignment
$assignment = New-AzureRMPolicyAssignment -Name 'deny-new-linux-vm-ssh-with-password-assignment' -DisplayName 'Deny creation of Linux VMs that use password for SSH authentication Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
az policy definition create --name deny-new-linux-vm-ssh-with-password --display-name "Deny creation of Linux VMs that use password for SSH authentication" --description "This policy denies the creation of a Linux VM if a password is being used to authentication" --rules https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deny-new-linux-vm-ssh-with-password/azurepolicy.rules.json --mode All

# Create the Policy Assignment
# Set the scope to a resource group; may also be a subscription or management group
az policy assignment create --name 'deny-new-linux-vm-ssh-with-password-assignment' --display-name "Deny creation of Linux VMs that use password for SSH authentication Assignment" --scope /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName> --policy /subscriptions/<subscriptionId>/providers/Microsoft.Authorization/policyDefinitions/deny-new-linux-vm-ssh-with-password
```