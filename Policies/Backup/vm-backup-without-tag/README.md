# Azure VM Backup - Without Tag

This custom Azure Policy will enroll all VMs WITHOUT the specified "tagName : [tagValue]" into a specified backupPolicy.  
Additional parameters that are required for this policy include:
* the name of the backupVaultResourceGroup
* the name of the backupVault (Recovery Services Vault)
* the name of the backupVaultPolicy

This policy will enroll any existing VMs into the backup policy (through a remediation task) as well as any newly created VMs.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcommunity-policy%2Fmaster%2Fpolicies%2FBackup%2vm-backup-without-tag%2Fazurepolicy.json)

## Try with PowerShell

```powershell

$Scope = (Get-AzContext).Subscription.Id
$Properties = @{
    Name = 'backup-vm-without-given-tag-to-existing-recovery-services-vault'
    DisplayName = 'Enable Backup on VMs without a given tag to an existing recovery services vault'
    Description = 'Enable backup on VMs by backing them up to an existing central recovery services vault. You can optionally exclude virtual machines containing a specified tag to control the scope of assignment.'
    Policy = 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Backup/vm-backup-without-tag/azurepolicy.rules.json'
    Parameter = 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Backup/vm-backup-without-tag/azurepolicy.parameters.json'
    Mode = 'All'
}

$PolicyDefinition = New-AzPolicyDefinition @Properties

New-AzPolicyAssignment -Name $Properties.Name ` 
    -DisplayName $Properties.DisplayName ` 
    -Scope <scope> `
    -PolicyDefinition $PolicyDefinition ` 
    -effect <deployIfNotExists|Disabled> `
    -backupVaultResourceGroup <resourceGroupName> `
    -backupVault <rsvName> `
    -backupPolicy <rsvPolicyName>

```

## Try with CLI

```cli

az policy definition create --name 'backup-vm-without-given-tag-to-existing-recovery-services-vault' --display-name 'Enable Backup on virtual machines without a given tag to an existing recovery services vault' --description 'Enable backup for virtual machines by backing them up to an existing central recovery services vault. You can optionally exclude virtual machines containing a specified tag to control the scope of assignment.' --rules 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Backup/vm-backup-without-tag/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/Community-Policy/master/Policies/Backup/vm-backup-without-tag/azurepolicy.parameters.json' --mode All

az policy assignment create --name 'backup-vm-without-given-tag-to-existing-recovery-services-vault' --display-name 'Enable Backup on virtual machines without a given tag to an existing recovery services vault' --scope <scope> --params "{ 'effect': { 'value': '<deployIfNotExists|Disabled>' }, 'backupVaultResourceGroup': { 'value': '<resourceGroupName>' },'backupVault': { 'value': '<rsvName>' },'backupPolicy': { 'value': '<rsvPolicyName>' } }" --policy "backup-vm-without-given-tag-to-existing-recovery-services-vault"

```