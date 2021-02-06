# Deny route with address prefix 0.0.0.0/0 not pointing to the virtual appliance

Deny route with address prefix 0.0.0.0/0 not pointing to the virtual appliance. Both creating routes as a [standalone resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/routetables/routes) or [nested within their parent resource route table](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/routetables) are considered.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-route-nexthopvirtualappliance%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-route-nexthopvirtualappliance%2Fazurepolicy.json)

Sample parameter ```routeTableSettings```, which can be used during policy assignment:
```json
{
    "northeurope": {
        "virtualApplianceIpAddress": "10.0.0.23"
    },
    "westeurope": {
        "virtualApplianceIpAddress": "10.1.0.23"
    },
    "disabled": {
        "virtualApplianceIpAddress": ""
    }
}
```

> Obviously, the location (e.g. ```northeurope```) is unknown during policy assignment and cannot be retrieved by ```parameters('routeTableSettings')[field('location')]``` in the policy definition. Hence, adding a ```disabled``` value to the parameter object is required to pass the validation during policy assignment.

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "deny-route-nexthopvirtualappliance" `
    -DisplayName "Deny route with address prefix 0.0.0.0/0 not pointing to the virtual appliance" `
    -Description "Deny route with address prefix 0.0.0.0/0 not pointing to the virtual appliance. Both creating routes as a standalone resource or nested within their parent resource route table are considered." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopvirtualappliance/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopvirtualappliance/azurepolicy.parameters.json' `
    -Mode All

$definition

$policyParameterObject = @{
    "routeTableSettings" = @{
        "northeurope" = @{
            "virtualApplianceIpAddress"="10.0.0.23"
        }; 
        "westeurope" = @{
            "virtualApplianceIpAddress"="10.1.0.23"
        }; 
        "disabled" = @{
            "virtualApplianceIpAddress"=""
        }
    }
}

$assignment = New-AzPolicyAssignment `
    -Name <assignmentname> `
    -Scope <scope> `
    -PolicyDefinition $definition `
    -PolicyParameterObject $policyParameterObject

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'deny-route-nexthopvirtualappliance' \
    --display-name 'Deny route with address prefix 0.0.0.0/0 not pointing to the virtual appliance' \
    --description 'Deny route with address prefix 0.0.0.0/0 not pointing to the virtual appliance. Both creating routes as a standalone resource or nested within their parent resource route table are considered.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopvirtualappliance/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopvirtualappliance/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'deny-route-nexthopvirtualappliance' --params \
"{ \
    'routeTableSettings': { \
        'value': { \
            'northeurope': { \
                'virtualApplianceIpAddress': '10.0.0.23' \
            }, \
            'westeurope': { \
                'virtualApplianceIpAddress': '10.1.0.23' \
            }, \
            'disabled': { \
                'virtualApplianceIpAddress': '' \
            } \
        } \
    } \
}"
```

## Notes
Route tables are location-specific resources, so depending on the location or Azure region of the VNet you need a different route table (e.g. North Europe, West Europe). For example, you cannot add a route table located in North Europe to a VNet's subnet located in West Europe. Additionally, virtual appliances are often deployed to different locations as well (e.g. North Europe, West Europe). For example, default routes (```0.0.0.0/0```) of route tables located in North Europe, should point to the virtual appliance in North Europe with IP address ```10.0.0.23```. For West Europe, they should point to ```10.1.0.23```. While this policy definition could be simplified and assigned once per location, reducing the amount of policy assignments improves manageability (e.g. reviewing audit results). Passing route table settings as a parameter object enables the usage of location-specific settings within the policy definition, e.g. ```[parameters('routeTableSettings')[field('location')].virtualApplianceIpAddress]``` with ```field('location')``` being the location where the VNet's subnet is located (e.g. North Europe, West Europe). Long story short, instead of doing _n_ policy assignments with _n_ being the amount of locations, you just need one single policy assignment. Pretty neat isn't it.