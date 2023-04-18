# Deploy new Azure policy definition using PowerShell
```pwsh
Login-AzAccount -Tenant "<TenantId>"

$Policy = New-AzPolicyDefinition -Policy ".\Policies\Network\deny-nsgs-with-security-rules-inbound-source-any\azurepolicy.json" -Name "efa5ffc1-e9b5-4311-a4cb-e8d695cb19ae"

# Creates a policy assignment on default scope & DoNotEnforce as Enforcement mode.
New-AzPolicyAssignment -Name "NSG-security-rule-allow-inbound-any" -PolicyDefinition $Policy -EnforcementMode 'DoNotEnforce'
```
# Deploy new Azure policy definition using Az cli
```pwsh
az policy definition create --name "efa5ffc1-e9b5-4311-a4cb-e8d695cb19ae" --display-name "Network Security Groups - Allow inbound rules with any as source" --rules ".\Policies\Network\deny-nsgs-with-security-rules-inbound-source-any\azurepolicy.rules.json" --params ".\Policies\Network\deny-nsgs-with-security-rules-inbound-source-any\azurepolicy.parameters.json"

az policy assignment create --name "NSG-security-rule-allow-inbound-any" --policy "efa5ffc1-e9b5-4311-a4cb-e8d695cb19ae" --enforcement-mode 'DoNotEnforce'
```

# Deploy using portal.
[Create Policy Definition Blade](https://portal.azure.com/#view/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)