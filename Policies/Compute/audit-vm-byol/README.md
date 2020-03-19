# Audit VM BYOL Compliance

This policy audits whether an existing VM is enabled for OS (Operating System) BYOL (Bring-Your-Own-License) or is based on a Linux GPL distro from Canonical, Debian or Rogue Wave (formerly OpenLogic). Linux distros not under GPL may use BYOS (Bring-Your-Own-Subscription) instead of BYOL terminology. Auditing for BYOL compliance is useful for cost optimization as non-compliant VMs incur Azure Billing charges for OS licenses in addition to the cost of running the base VM. If you already have eligible OS licenses which can be applied or transferred to Azure VM deployments, you should enable BYOL per the OS vendor's requirements...

- Microsoft Windows Sever: [Azure Hybrid Benfit for Windows Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing)

- Red Hat Enterprise Linux: [Enabling RHEL BYOS Gold Images in Azure](https://docs.microsoft.com/azure/virtual-machines/workloads/redhat/byos)

- SUSE Enterprise Linux: [SLES BYOS Images in Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/suse.sles-byos)

Once deployed, you can see the non-compliant VMs under the [Policy Compliance blade](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyMenuBlade/Compliance) in the Azure Portal.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FCompute%2Faudit-vm-byol%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FCompute%2Faudit-vm-byol%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'audit-vm-byol' -DisplayName 'Audit VM BYOL Compliance' -description 'This policy audits whether an existing VM is enabled for OS BYOL or is based on a Linux GPL distro from Canonical, Debian or Rogue Wave (formerly OpenLogic).' -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Compute/audit-vm-byol/azurepolicy.rules.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'audit-vm-byol' -DisplayName 'Audit VM BYOL Compliance' -Scope $scope.ResourceId -PolicyDefinition $definition
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
az policy definition create --name audit-vm-byol --display-name "Audit VM BYOL Compliance" --description "This policy audits whether an existing VM is enabled for BYOL or is based on a Linux GPL distro from Canonical, Debian or Rogue Wave (formerly OpenLogic)." --rules https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Compute/audit-vm-byol/azurepolicy.rules.json --mode All

# Create the Policy Assignment
# Set the scope to a resource group; may also be a subscription or management group
az policy assignment create --name 'audit-vm-byol' --display-name "Audit VM BYOL Compliance" --scope /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName> --policy /subscriptions/<subscriptionId>/providers/Microsoft.Authorization/policyDefinitions/audit-vm-byol
```