# Deny NICs joining an ASG if in a different Resource Group

This policy prevents users from trying to join a Virtual Machine's Network Interface to an Application Security Group (ASG) that exists in another Resource Group. The reason is that some ASGs are used in Network Security Group (NSG) rules, which could potentially allow VMs to have access to endpoints they shouldn't have access to. 

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-nics-joining-asg-outside-of-same-resource-group%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-nics-joining-asg-outside-of-same-resource-group%2Fazurepolicy.json)

Sample parameter ```effect```, which can be used during policy assignment:
```json
{
    "effect": "Deny"
}
```

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "deny-nic-asg-join-if-not-same-rg" `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-nics-joining-asg-outside-of-same-resource-group/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-nics-joining-asg-outside-of-same-resource-group/azurepolicy.parameters.json' `
    -Mode All

$definition

$policyParameterObject = @{
    "effect" = "Deny"
}

$assignment = New-AzPolicyAssignment `
    -Name 'policyAss' `
    -Scope '/subscriptions/20d6fbfe-b049-471c-95af-1369d14d0d45' `
    -PolicyDefinition $definition `
    -AssignIdentity `
    -Location 'australiaeast' `
    -PolicyParameterObject $policyParameterObject

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'deny-nics-joining-asg-outside-of-same-resource-group' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-nics-joining-asg-outside-of-same-resource-group/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-nics-joining-asg-outside-of-same-resource-group/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'deny-nics-joining-asg-outside-of-same-resource-group' --location <location> --params '{"effect":{"value":"Deny"}}'
```