# Address space must be pre-allocated to region
Following the release of the ability to update the address space of a peered VNET (and resync), it becomes prudent when at "enterprise scale" (and utilising a hub-spoke topology) to restrict the ranges which spokes may utilise. Failing to do so has the potential for this to be used as an attack vector (both intentionally and unintentionally) to null-route traffic intended for on-premise (i.e. over ExpressRoute).

This policy provides a mechanism for preventing a VNET's address space from existing outside of ranges configured for a region, leveraging the name of the subscription to define the environment (e.g. PROD, DEV). This is ideal in situations where an enterprise has implemented sane IPAM, and in instances where the contents of a subscription is entirely under the control of the development team.

## Potential Alternative Scenarios
- We as an organisation don't utilise the subscription name to identify the environment
    - This policy could be edited on line 68 of `azurepolicy.json` to make use of tagging on the resource group, subscription or resource. **However**, this is more likely to be worked around dependent on your RBAC implementation.
- We only want this to apply to VNETs directly peered with our hubs
    - Pass in an array of subscriptionIds of where hub VNETs exist as part of the "hubSubscriptions" parameter.
- We're utilising vWAN... What are our 'hubSubscriptions'?
    - Review any audit trails, or a configuration of one of your spokes; each hub should/may be in its own subscription, which will be shown in the peering configuration/audit logs.

# Deployment Options
The below sectionals provide examples of how this can be deployed - please note, when utilising the "Deploy to Azure" button, some properties are ignored by the portal (e.g. non-compliance message). This will need to be manually filled. 

## Deploy via Portal
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Faddress-space-must-be-pre-allocated-for-region%2Fazurepolicy.json)

## Deploy via PowerShell
```PowerShell
$definition = New-AzPolicyDefinition -Name "Address space must be pre-allocated for region" -DisplayName "VNETs should abide by regional IPAM allocations" -description "This policy ensures that the address space allocated to a VNET has been pre-allocated for use within Azure, preventing peerings being utilised as an attack vector for null-routing traffic on the platform." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/address-space-must-be-pre-allocated-for-region/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/address-space-must-be-pre-allocated-for-region/azurepolicy.parameters.json' -Mode Indexed
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
```
## Deploy via Az CLI
````cli

az policy definition create --name 'Address space must be pre-allocated for region' --display-name 'VNETs should abide by regional IPAM allocations' --description 'This policy ensures that the address space allocated to a VNET has been pre-allocated for use within Azure, preventing peerings being utilised as an attack vector for null-routing traffic on the platform.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/address-space-must-be-pre-allocated-for-region/azurepolicy.parameters.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/address-space-must-be-pre-allocated-for-region/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "Address space must be pre-allocated for region" 

````