# Event Hub namespaces should have the specified minimum TLS version

This policy will restrict Event Hub namespaces not using the TLS version defined in parameters.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FEventHub%2Faudit-minimum-tls-version%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name 'allowed-event-hub-firewall' -DisplayName 'Allow IP for event hub firewall' -description 'List of IPs allowed for event hub firewall' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/audit-minimum-tls-version/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/audit-minimum-tls-version/azurepolicy.parameters.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'rg-eventhub'

# Set the Policy Parameter (JSON format)
$policyparam = '{ "allowedIps": { "value": [ "10.12.3.7", "22.8.1.5" ] } }'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'allowed-event-hub-firewall-assignment' -DisplayName 'Allow IPs for event hub firewall Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam

````

## Try with CLI

````cli

# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'audit-minimum-tls-version' --display-name 'Allow IP for event hub firewall' --description 'List of IPs allowed for event hub firewall' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/audit-minimum-tls-version/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/audit-minimum-tls-version/azurepolicy.parameters.json' --mode All)

# Set the scope to a resource group; may also be a subscription 
scope=$(az group show --name 'rg-eventhub')

# Set the Policy Parameter (JSON format)
policyparam='{ "minimumTlsVersion": { "value": "1.2"} }'

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'audit-minimum-tls-version' --display-name 'Allow IP for event hub firewall Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r` --params "$policyparam")

````
