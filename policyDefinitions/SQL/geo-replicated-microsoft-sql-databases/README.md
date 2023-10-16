# Description and purpose of the Azure policy
The policy will set the secondary geo-redundant database as compliant whilst the other database, which is the primary as non-compliant.
# Deploy the Azure Policy
## Deploy new Azure policy definition using PowerShell
```pwsh
Login-AzAccount -Tenant "<TenantId>"

$Policy = New-AzPolicyDefinition -Policy .\Policies\SQL\audit-sql-databases-geo-replication\azurepolicy.json -Name "73a07549-abe8-4678-af9b-faecaed39235"

# Creates a policy assignment on default scope & DoNotEnforce as Enforcement mode.
New-AzPolicyAssignment -Name "SQL-databases-geo-replication" -PolicyDefinition $Policy -EnforcementMode 'DoNotEnforce'
```
## Deploy new Azure policy definition using Az cli
```pwsh
az policy definition create --name "73a07549-abe8-4678-af9b-faecaed39235" --display-name "Geo replicated Microsoft SQL databases" --rules ".\Policies\SQL\audit-sql-databases-geo-replication\azurepolicy.rules.json" --params ".\Policies\SQL\audit-sql-databases-geo-replication\azurepolicy.parameters.json"

az policy assignment create --name "SQL-databases-geo-replication" --policy "73a07549-abe8-4678-af9b-faecaed39235" --enforcement-mode 'DoNotEnforce'
```

## Deploy using portal.
[Create Policy Definition Blade](https://portal.azure.com/#view/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)