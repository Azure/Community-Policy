# Append AKS API IP Restrictions.

This policy will restrict access to the AKS API server as documented here: https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKubernetesService%2Fappend-aks-api-ip-restrictions%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "append-aks-api-ip-restrictions" -DisplayName "Append AKS API IP Restrictions" -description "This policy will restrict access to the AKS API server as documented here: https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KubernetesService/append-aks-api-ip-restrictions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KubernetesService/append-aks-api-ip-restrictions/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -listOfAllowedCollations <Allowed database Collations> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'append-aks-api-ip-restrictions' --display-name 'Append AKS API IP Restrictions' --description 'This policy will restrict access to the AKS API server as documented here: https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KubernetesService/append-aks-api-ip-restrictions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KubernetesService/append-aks-api-ip-restrictions/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'listOfAllowedIps': { 'value': ['xxx.xxx.xxx.xxx', 'xxx.xxx.xxx.xxx/24'] } }" --policy "append-aks-api-ip-restrictions" 

````
