# Deploy a Data Lifecycle Management policy for Storage Accounts

Configure the deployment of one Data Lifecycle Management (DLM) policy for each storage account in the scope with a given lifecycle policy name.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FStorage%deploy-storage-account-lifecycle-management%2Fazurepolicy.json)

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "deploy-storage-account-lifecycle-management" `
    -DisplayName "Deploy a Data Lifecycle Management policy for Storage Accounts" `
    -Description "Configure the deployment of one Data Lifecycle Management (DLM) policy for each storage account in the scope with a given lifecycle policy name." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-storage-account-lifecycle-management/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-storage-account-lifecycle-management/azurepolicy.parameters.json' -Mode All

$definition

$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'deploy-storage-account-lifecycle-management' \
    --display-name 'Deploy a Data Lifecycle Management policy for Storage Accounts' \
    --description 'Configure the deployment of one Data Lifecycle Management (DLM) policy for each storage account in the scope with a given lifecycle policy name.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-storage-account-lifecycle-management/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/deploy-storage-account-lifecycle-management/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-storage-account-lifecycle-management"
```
