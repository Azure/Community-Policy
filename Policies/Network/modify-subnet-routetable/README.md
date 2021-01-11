# Adds the default route table to subnets

Adds the default route table to subnets. Other route tables are replaced with the default route table.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-subnet-routetable%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-subnet-routetable%2Fazurepolicy.json)

Sample parameter ```routeTableSettings```, which can be used during policy assignment:
```json
{
    "northeurope": {
        "resourceGroupName": "ne-network",
        "routeTableName": "ne-default-routetable"
    },
    "westeurope": {
        "resourceGroupName": "we-network",
        "routeTableName": "we-default-routetable"
    },
    "disabled": {
        "resourceGroupName": "",
        "routeTableName": ""
    }
}
```

> Obviously, the location (e.g. ```northeurope```) is unknown during policy assignment and cannot be retrieved by ```[parameters('routeTableSettings')[field('location')]``` in the policy definition. Hence, adding a ```disabled``` value to the parameter object is required to pass the validation during policy assignment.

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "modify-subnet-routetable" `
    -DisplayName "Adds the default route table to subnets" `
    -Description "Adds the default route table to subnets. Other route tables are replaced with the default route table." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-routetable/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-routetable/azurepolicy.parameters.json' `
    -Mode All

$definition

$policyParameterObject = @{
    "routeTableSettings" = @{
        "northeurope" = @{
            "resourceGroupName"="ne-network";
            "routeTableName"="ne-default-routetable"
        }; 
        "westeurope" = @{
            "resourceGroupName"="we-network";
            "routeTableName"="we-default-routetable"
        }; 
        "disabled" = @{
            "resourceGroupName"="";
            "routeTableName"=""
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
    --name 'modify-subnet-routetable' \
    --display-name 'Adds the default route table to subnets' \
    --description 'Adds the default route table to subnets. Other route tables are replaced with the default route table.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-routetable/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-routetable/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'modify-subnet-routetable' --assign-identity --location <location> --params \
"{ \
    'routeTableSettings': { \
        'value': { \
            'northeurope': { \
                'resourceGroupName': 'ne-network', \
                'routeTableName': 'ne-default-routetable' \
            }, \
            'westeurope': { \
                'resourceGroupName': 'we-network', \
                'routeTableName': 'we-default-routetable' \
            }, \
            'disabled': { \
                'resourceGroupName': '', \
                'routeTableName': '' \
            } \
        } \
    } \
}"
```

## Notes
Route tables are location-specific resources, so depending on the location or Azure region of the VNet you need a different route table (e.g. North Europe, West Europe). For example, you cannot add a route table located in North Europe to a VNet's subnet located in West Europe. While this policy definition could be simplified and assigned once per location, reducing the amount of policy assignments improves manageability (e.g. reviewing audit results). Passing route table settings as a parameter object enables the usage of location-specific settings within the policy definition, e.g. ```parameters('routeTableSettings')[field('location')].routeTableName``` with ```field('location')``` being the location where the VNet's subnet is located (e.g. North Europe, West Europe). Long story short, instead of doing _n_ policy assignments with _n_ being the amount of locations, you just need one single policy assignment. Pretty neat isn't it.
