# Only Allows Private Endpoints to Be Deployed Into A Specific Subnet

This policy enforces the deployment of Azure Private Endpoints to be deployed into a VNET with a subnet that has a specific prefix in the name (i.e pls, pe). It also supports exemptions by allowing specific [Group IDs](https://docs.microsoft.com/en-us/cli/azure/network/private-endpoint?view=azure-cli-latest#az_network_private_endpoint_create-required-parameters) to be excluded from this Policy.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-private-endpoint-if-not-in-specific-subnet%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-private-endpoint-if-not-in-specific-subnet%2Fazurepolicy.json)

Sample parameter ```subnetNamingConvention```, which can be used during policy assignment:
```json
{
    "subnetName": "pe,pls",
    "exemptedGroupIds":["table"]
}
```

> The ```subnetName``` defines the suffix that you want to allow Private Endpoint resources to be deployed into. This is useful where you want to isolate Private Endpoints in seperate Virtual Network Spokes, using **Pattern 1** from the Azure Documentation: [Use Azure Firewall to inspect traffic destined to a private endpoint](https://docs.microsoft.com/en-us/azure/private-link/inspect-traffic-with-azure-firewall)

> The ```exemptedGroupIds``` defines an array of Private Endpoint Group IDs that you want to exclude from this policy. This may be used for scenarios where certain PaaS Services deployments (i.e. AKS) automatically attempt the creation of a Private Endpoint for the API Server, and this can only live within the subnet where the AKS cluster is deployed into.


## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "deny-pe-if-not-in-subnet" `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-private-endpoint-if-not-in-specific-subnet/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-private-endpoint-if-not-in-specific-subnet/azurepolicy.parameters.json' `
    -Mode All

$definition

$policyParameterObject = @{
    "subnetName" = "pe"
    "exemptedGroupIds"=@("table")
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
    --name 'only-allow-private-endpoints-in-subnet-with-specific-suffix' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-private-endpoint-if-not-in-specific-subnet/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-private-endpoint-if-not-in-specific-subnet/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'deny-private-endpoint-if-not-in-specific-subnet' --location <location> --params '{ "subnetName":{"value":"pls"},"exemptedGroupIds": { "value": ["table"]}}'
```