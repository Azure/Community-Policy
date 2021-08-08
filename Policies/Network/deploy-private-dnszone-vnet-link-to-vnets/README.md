# Create Private DNS Zone Virtual Network Link to Virtual Networks if not available

This policy creates a virtual network integration for an Azure Private DNS Zone to the specified vNets Resource IDs. Can also be set to enable auto registeration for resources deployed in these vNets to the Azure Private DNS Zone.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeploy-private-dnszone-vnet-link-to-vnets%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeploy-private-dnszone-vnet-link-to-vnets%2Fazurepolicy.json)

Sample parameter ```virtualNetworkResourceId```, which can be used during policy assignment:
```json
{
    "virtualNetworkResourceId": "[
        "/subscriptions/{subscription id}/resourceGroups/{resourceGroup name}/providers/Microsoft.Network/virtualNetworks/{virtual network 1 name}",
        "/subscriptions/{subscription id}/resourceGroups/{resourceGroup name}/providers/Microsoft.Network/virtualNetworks/{virtual network 2 name}"
    ]",
    "registrationEnabled":false
}
```

> The ```virtualNetworkResourceId``` defines Resource Ids of a vNet to link. The format must be: '/subscriptions/{subscription id}/resourceGroups/{resourceGroup name}/providers/Microsoft.Network/virtualNetworks/{virtual network name}. Can support multiple vNets

> The ```registrationEnabled``` Enables automatic DNS registration in the zone for the linked vNet. Default is ```false```.


## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "create-dnsZone-vnet-integration-to-vnets" `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deploy-private-dnszone-vnet-link-to-vnets/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deploy-private-dnszone-vnet-link-to-vnets/azurepolicy.parameters.json' `
    -Mode All

$definition

$policyParameterObject = @{
    "virtualNetworkResourceId" = @("/subscriptions/{subscription id}/resourceGroups/{resourceGroup name}/providers/Microsoft.Network/virtualNetworks/{virtual network 1 name}")
}

$assignment = New-AzPolicyAssignment `
    -Name <assignmentname> `
    -Scope <scope> `
    -PolicyDefinition $definition `
    -AssignIdentity `
    -Location <location> `
    -PolicyParameterObject $policyParameterObject

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'create-dnsZone-vnet-integration-to-vnets' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deploy-private-dnszone-vnet-link-to-vnets/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deploy-private-dnszone-vnet-link-to-vnets/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'deploy-private-dnszone-vnet-link-to-vnets' --location <location> --params '{ "virtualNetworkResourceId": { "value": ["/subscriptions/{subscription id}/resourceGroups/{resourceGroup name}/providers/Microsoft.Network/virtualNetworks/{virtual network 1 name}"]}}'
```