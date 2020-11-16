# How to use this policy
This policy sample is a delployIfNotExists one, checking all VMs in your scope and looking for a devtestlabs/schedule resource ([Auto-shutdown option for VMs in Azure portal](https://azure.microsoft.com/en-us/blog/announcing-auto-shutdown-for-vms-using-azure-resource-manager)). The name of the DTL schedule is strict, and enforced by the API. If no schedule is found, it will enable one at the time of your choice, without email notification enabled. The schedule is created in the same region and resource group than the VM.

You can customize the policy by enabling notification emails, for instance.

This is how you import the definition to your account

>New-AzPolicyDefinition -Name 'ShutdownVM' -DisplayName 'Automatically Shutdown VMs at a given time' -Policy .\azurepolicy.rules.json -Parameter .\azurepolicy.parameters.json

Once imported, remember to assign it to your desired scope (resource group or subscriprion)

**WARNING** be careful! This policy will REALLY SHUTDOWN YOUR VMs, so be careful with the scope when you assign it