```pwsh
Login-AzAccount -Tenant "<TenantId>"

$Policy = New-AzPolicyDefinition -Policy ".\Policies\Compute\vm-extension-vmaccess\azurepolicy.json" -Name "97d4dc8b-b0bd-42da-aa83-bbf98c0c7ef7"

# Creates a policy assignment on default scope & DoNotEnforce as Enforcement mode.
New-AzPolicyAssignment -Name "vmaccess-extension-linux" -PolicyDefinition $Policy -EnforcementMode 'DoNotEnforce'
```
# Deploy new Azure policy definition using Az cli
```pwsh

az policy definition create --name "97d4dc8b-b0bd-42da-aa83-bbf98c0c7ef7" --display-name "VMAccess virtual machine extension for Linux" --rules ".\Policies\Compute\vm-extension-vmaccess\azurepolicy.rules.json" --params ".\Policies\Compute\vm-extension-vmaccess\azurepolicy.parameters.json"

az policy assignment create --name "vmaccess-extension-linux" --policy "97d4dc8b-b0bd-42da-aa83-bbf98c0c7ef7" --enforcement-mode 'DoNotEnforce'
```

# Deploy using portal.
[Create Policy Definition Blade](https://portal.azure.com/#view/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)