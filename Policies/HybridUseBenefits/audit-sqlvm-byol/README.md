# Audit SQL Server VM BYOL Compliance

This policy audits whether an existing SQL Server VM (Standard or Enterprise Edition) is enabled for SQL Server BYOL (Bring-Your-Own-License) via Azure Hybrid Benefit, or is licensed for Disaster Recovery. This policy evaluates Web, Express and Developer Editions of SQL Server as compliant by default since the aforementioned Editions are exempt from Azure Hybrid Benefit and Disaster Recovery licensing. Auditing for BYOL compliance is useful for cost optimization as non-compliant SQL Server VMs incur Azure Billing charges for SQL Server licenses in addition to the cost of running the VM. If you already have eligible SQL Server licenses which can be applied or transferred to Azure VM deployments, you should enable Azure Hybrid Benefit or Disaster Recovery licensing per the the following requirements...

- [Change the license model for a SQL Server virtual machine in Azure](https://docs.microsoft.com/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-ahb)

You should also verify your eligibility for Windows Server BYOL via Azure Hybrid Benefit and whether you have enabled that option, as it is a separate configuration...

- [Azure Hybrid Benefit for Windows Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing)
- Azure Community Policy Samples: [Audit VM BYOL Compliance](https://github.com/Azure/Community-Policy/tree/master/Policies/Compute/audit-vm-byol)

Once deployed, you can see the non-compliant VMs under the [Policy Compliance blade](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyMenuBlade/Compliance) in the Azure Portal.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FHybridUseBenefits%2Faudit-sqlvm-byol%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FHybridUseBenefits%2Faudit-sqlvm-byol%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'audit-sqlvm-byol' -DisplayName 'Audit SQL Server VM BYOL Compliance' -description 'This policy audits whether an existing SQL Server VM is enabled for SQL Server BYOL.' -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/HybridUseBenefits/audit-sqlvm-byol/azurepolicy.rules.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'audit-sqlvm-byol' -DisplayName 'Audit SQL Server VM BYOL Compliance' -Scope $scope.ResourceId -PolicyDefinition $definition
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
az policy definition create --name audit-sqlvm-byol --display-name "Audit SQL Server VM BYOL Compliance" --description "This policy audits whether an existing SQL Server VM is enabled for SQL Server BYOL." --rules https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/HybridUseBenefits/audit-sqlvm-byol/azurepolicy.rules.json --mode All

# Create the Policy Assignment
# Set the scope to a resource group; may also be a subscription or management group
az policy assignment create --name 'audit-sqlvm-byol' --display-name "Audit SQL Server VM BYOL Compliance" --scope /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName> --policy /subscriptions/<subscriptionId>/providers/Microsoft.Authorization/policyDefinitions/audit-sqlvm-byol
```
