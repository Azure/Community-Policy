# Adds route with address prefix 0.0.0.0/0 pointing to the virtual appliance in case there is none.

Adds route with address prefix 0.0.0.0/0 pointing to the virtual appliance in case there is none. Best combined with policy [deny-route-nexthopvirtualappliance](https://github.com/Azure/Community-Policy/tree/master/Policies/Network/deny-route-nexthopvirtualappliance) to ensure the correct IP address of the virtual appliance.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-routetable-nexthopvirtualappliance%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-routetable-nexthopvirtualappliance%2Fazurepolicy.json)

Sample parameters, which can be used during policy assignment:
```json
{
    "routeTableSettings": {
        "value": {
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
    }
}
```

> Obviously, the location (e.g. ```northeurope```) is unknown during policy assignment and cannot be retrieved by ```[parameters('routeTableSettings')[field('location')].virtualApplianceIpAddress]``` in the policy definition. Hence, adding a ```disabled``` value to the parameter object is required to pass the validation during policy assignment.

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "modify-routetable-nexthopvirtualappliance" `
    -DisplayName "Adds route with address prefix 0.0.0.0/0 pointing to the virtual appliance in case there is none." `
    -Description "Adds route with address prefix 0.0.0.0/0 pointing to the virtual appliance in case there is none. Best combined with policy deny-route-nexthopvirtualappliance to ensure the correct IP address of the virtual appliance." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-routetable-nexthopvirtualappliance/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-routetable-nexthopvirtualappliance/azurepolicy.parameters.json' `
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
    -AssignIdentity `
    -Location <location> `
    -PolicyParameterObject $policyParameterObject

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'modify-routetable-nexthopvirtualappliance' \
    --display-name 'Adds route with address prefix 0.0.0.0/0 pointing to the virtual appliance in case there is none.' \
    --description 'Adds route with address prefix 0.0.0.0/0 pointing to the virtual appliance in case there is none. Best combined with policy deny-route-nexthopvirtualappliance to ensure the correct IP address of the virtual appliance.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-routetable-nexthopvirtualappliance/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-routetable-nexthopvirtualappliance/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'modify-routetable-nexthopvirtualappliance' --assign-identity --location <location> --params \
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
Route tables are location-specific resources, so depending on the location of the VNet you need a different route table (e.g. North Europe, West Europe). For example, you cannot assign a route table in North Europe to a VNet's subnet located in West Europe. Additionally, virtual appliances are often deployed to different locations as well (e.g. North Europe, West Europe). For example, default routes (```0.0.0.0/0```) of route tables located in North Europe, should point to the virtual appliance in North Europe with IP address ```10.0.0.23```. For West Europe, they should point to ```10.1.0.23```. While multiple policy assignments could do the trick, it is desirable to reduce the amount of policy assignments to improve manageability. Passing route table settings as a parameter object enables the usage of location-specific settings within the policy definition, e.g. ```parameters('routeTableSettings')[field('location')].virtualApplianceIpAddress``` with ```field('location')``` being the location where the route table is located (e.g. North Europe, West Europe). Long story short, instead of doing _n_ policy assignments with _n_ being the amount of locations or Azure region, you need just one single policy assignment. Pretty neat isn't it.