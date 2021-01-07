# Deny route with next hop type internet

Deny route with next hop type internet to ensure data loss prevention. Both creating routes as a [standalone resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/routetables/routes) or [nested within their parent resource route table](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/routetables) are considered.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FNetwork%2Fdeny-route-nexthopinternet%2Fazurepolicy.json)

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "deny-route-nexthopinternet" `
    -DisplayName "Deny route with next hop type internet" `
    -Description "Deny route with next hop type internet to ensure data loss prevention. Both creating routes as a standalone resource or nested within their parent resource route table are considered." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopinternet/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopinternet/azurepolicy.parameters.json' `
    -Mode All

$definition

$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'deny-route-nexthopinternet' \
    --display-name 'Deny route with next hop type internet' \
    --description 'Deny route with next hop type internet to ensure data loss prevention. Both creating routes as a standalone resource or nested within their parent resource route table are considered.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopinternet/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Network/deny-route-nexthopinternet/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deny-route-nexthopinternet"
```