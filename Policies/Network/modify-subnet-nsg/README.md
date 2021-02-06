# Adds the default network security group to subnets in case there is none

Adds the default network security group to subnets in case there is none. Nothing happens when another network security group is already associated with the subnet.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-subnet-nsg%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fmodify-subnet-nsg%2Fazurepolicy.json)

Sample parameter ```networkSecurityGroupSettings```, which can be used during policy assignment:
```json
{
    "northeurope": {
        "resourceGroupName": "ne-network",
        "networkSecurityGroupName": "ne-default-nsg"
    },
    "westeurope": {
        "resourceGroupName": "we-network",
        "networkSecurityGroupName": "we-default-nsg"
    },
    "disabled": {
        "resourceGroupName": "",
        "networkSecurityGroupName": ""
    }
}
```

> Obviously, the location (e.g. ```northeurope```) is unknown during policy assignment and cannot be retrieved by ```parameters('networkSecurityGroupSettings')[field('location')]``` in the policy definition. Hence, adding a ```disabled``` value to the parameter object is required to pass the validation during policy assignment.

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "modify-subnet-nsg" `
    -DisplayName "Adds the default network security group to subnets in case there is none" `
    -Description "Adds the default network security group to subnets in case there is none. Nothing happens when another network security group is already associated with the subnet." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-nsg/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-nsg/azurepolicy.parameters.json' `
    -Mode All

$definition

$policyParameterObject = @{
    "networkSecurityGroupSettings" = @{
        "northeurope" = @{
            "resourceGroupName"="ne-network";
            "networkSecurityGroupName"="ne-default-nsg"
        }; 
        "westeurope" = @{
            "resourceGroupName"="we-network";
            "networkSecurityGroupName"="we-default-nsg"
        }; 
        "disabled" = @{
            "resourceGroupName"="";
            "networkSecurityGroupName"=""
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
    --name 'modify-subnet-nsg' \
    --display-name 'Adds the default network security group to subnets in case there is none' \
    --description 'Adds the default network security group to subnets in case there is none. Nothing happens when another network security group is already associated with the subnet.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-nsg/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/modify-subnet-nsg/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'modify-subnet-nsg' --assign-identity --location <location> --params \
"{ \
    'networkSecurityGroupSettings': { \
        'value': { \
            'northeurope': { \
                'resourceGroupName': 'ne-network', \
                'networkSecurityGroupName': 'ne-default-nsg' \
            }, \
            'westeurope': { \
                'resourceGroupName': 'we-network', \
                'networkSecurityGroupName': 'we-default-nsg' \
            }, \
            'disabled': { \
                'resourceGroupName': '', \
                'networkSecurityGroupName': '' \
            } \
        } \
    } \
}"
```

## Notes
Network security groups are location-specific resources, so depending on the location or Azure region of the VNet you need a different network security group (e.g. North Europe, West Europe). For example, you cannot add a network security group located in North Europe to a VNet's subnet located in West Europe. While this policy definition could be simplified and assigned once per location, reducing the amount of policy assignments improves manageability (e.g. reviewing audit results). Passing network security group settings as a parameter object enables the usage of location-specific settings within the policy definition, e.g. ```[parameters('networkSecurityGroupSettings')[field('location')].networkSecurityGroupName]``` with ```field('location')``` being the location where the VNet's subnet is located (e.g. North Europe, West Europe). Long story short, instead of doing _n_ policy assignments with _n_ being the amount of locations, you just need one single policy assignment. Pretty neat isn't it.
