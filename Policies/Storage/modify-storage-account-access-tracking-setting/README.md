# Enable access tracking on storage accounts

Ensure that access tracking is enabled on your storage accounts. This helps to track the last read access on your blobs that can be used to setup your data lifecycle management with last read access.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FCommunity-Policy%2Fmaster%2FPolicies%2FStorage%modify-storage-account-access-tracking-setting%2Fazurepolicy.json)

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition `
    -Name "modify-storage-account-access-tracking-setting" `
    -DisplayName "Enable Access Tracking for Storage Accounts" `
    -Description "This policy will enable access tracking on storage accounts. This can be used to track the read access of blobs in storage accounts." `
    -Policy 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/modify-storage-account-access-tracking-setting/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/modify-storage-account-access-tracking-setting/azurepolicy.parameters.json' -Mode All

$definition

$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition

$assignment
```

## Try with CLI

```sh
az policy definition create \
    --name 'modify-storage-account-access-tracking-setting' \
    --display-name 'Enable Access Tracking for Storage Accounts' \
    --description 'This policy will enable access tracking on storage accounts. This can be used to track the read access of blobs in storage accounts.' \
    --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/modify-storage-account-access-tracking-setting/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Storage/modify-storage-account-access-tracking-setting/azurepolicy.parameters.json' \
    --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "modify-storage-account-access-tracking-setting"
```
