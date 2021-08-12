# Injects a Route into existing Route Table

adds a single route into an existing Route Table. If assigned at subscription Level, routes will be injected into all Route Tables present under that subscription. Use assignment at Resource Group level to granular control which Route tables get the additional route. 

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-inject-Routes-into-existing-Route-Table%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-inject-Routes-into-existing-Route-Table%2Fazurepolicy.json)

Sample parameter ```routeTableSettings```, which can be used during policy assignment:
```json
{
    "addressPrefix": {
        "type": "string",
        "metadata": {
            "description": "The destination IP address range in CIDR notation that this Policy checks for within the UDR. Example: 0.0.0.0/0 to check for the presence of a default route.",
            "displayName": "Address Prefix"
        }
    },
    "nextHopType": {
        "type": "string",
        "metadata": {
            "description": "The next hope type that the policy checks for within the inspected route. The value can be Virtual Network, Virtual Network Gateway, Internet, Virtual Appliance, or None.",
            "displayName": "Next Hop Type"
        },
        "allowedValues": [
            "VnetLocal",
            "VirtualNetworkGateway",
            "Internet",
            "VirtualAppliance",
            "None"
        ]
    },
    "nextHopIpAddress": {
        "type": "string",
        "metadata": {
            "description": "The IP address packets should be forwarded to.",
            "displayName": "Next Hop IP Address"
        }
    },
    "effect": {
        "type": "String",
        "metadata": {
            "displayName": "Effect",
            "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
            "Modify",
            "Disabled"
        ],
        "defaultValue": "Modify"
    }
}
```



