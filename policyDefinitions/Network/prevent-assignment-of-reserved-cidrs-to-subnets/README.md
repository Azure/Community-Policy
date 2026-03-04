# Prevent Assignment of Reserved CIDRs to Subnets
In enterprise environments with centralized IP Address Management (IPAM), it is critical to prevent subnets from being assigned address ranges that overlap with reserved or protected CIDR blocks. This policy ensures that subnets cannot use IP ranges that have been designated for specific purposes such as on-premises connectivity, shared services, or future expansion.

This policy leverages the `ipRangeContains` function to perform bidirectional overlap detection—checking whether the subnet's address range is contained within a restricted CIDR, or if the subnet's range contains a restricted CIDR. This comprehensive approach prevents both direct conflicts and supernet/subnet overlaps.

## How It Works
The policy evaluates two resource types:
- **Microsoft.Network/virtualNetworks** - Checks all subnets defined within a VNet resource
- **Microsoft.Network/virtualNetworks/subnets** - Checks standalone subnet resources

For each subnet, the policy examines both:
- `addressPrefix` - Single address prefix property
- `addressPrefixes` - Array of address prefixes (for dual-stack or multi-prefix scenarios)

## Parameters
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `restrictedCIDRs` | Array | Array of CIDR ranges that subnets cannot overlap with (e.g., `['10.0.0.0/8', '172.16.0.0/12']`) | Required |
| `effect` | String | The effect of the policy: `Audit`, `Deny`, or `Disabled` | `Deny` |

## Use Cases
- **Protecting on-premises address space** - Prevent Azure subnets from overlapping with corporate network ranges routed via ExpressRoute or VPN
- **Reserving ranges for shared services** - Ensure specific CIDR blocks remain available for hub networks, DNS, or other shared infrastructure
- **Compliance with IPAM policies** - Enforce organizational IP allocation standards across all subscriptions

# Deployment Options
The below sections provide examples of how this can be deployed - please note, when utilising the "Deploy to Azure" button, some properties are ignored by the portal (e.g. non-compliance message). This will need to be manually filled.

## Deploy via Portal
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FpolicyDefinitions%2FNetwork%2Fprevent-assignment-of-reserved-cidrs-to-subnets%2Fazurepolicy.json)

## Deploy via PowerShell
```PowerShell
$definition = New-AzPolicyDefinition -Name "prevent-assignment-of-reserved-cidrs-to-subnets" -DisplayName "Prevent assignment of reserved CIDRs to subnets" -Description "This policy prevents subnets from being assigned address ranges that overlap with specified reserved CIDR ranges." -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/Network/prevent-assignment-of-reserved-cidrs-to-subnets/azurepolicy.json' -Mode All
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition -PolicyParameterObject @{"restrictedCIDRs"=@("10.0.0.0/8","172.16.0.0/12")}
```

## Deploy via Az CLI
```cli
az policy definition create --name 'prevent-assignment-of-reserved-cidrs-to-subnets' --display-name 'Prevent assignment of reserved CIDRs to subnets' --description 'This policy prevents subnets from being assigned address ranges that overlap with specified reserved CIDR ranges.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/Network/prevent-assignment-of-reserved-cidrs-to-subnets/azurepolicy.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "prevent-assignment-of-reserved-cidrs-to-subnets" --params '{"restrictedCIDRs":{"value":["10.0.0.0/8","172.16.0.0/12"]}}'
```