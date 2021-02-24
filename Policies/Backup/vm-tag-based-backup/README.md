# Azure VM Tag Based Backup

This custom Azure Policy will enroll all VMs with a specified “tagName : tagValue” into a specified backupPolicy. Additional parameters that are required for this policy include the name of the backupVault (Recovery Services Vault) and backupVaultResourceGroup. This policy will enroll any existing VMs into the backup policy (through a remediation task) as well as any newly created VMs.
