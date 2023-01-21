This policy will configure (Modify-effect) if storage accounts does not have container soft delete enabled.
Minimum value is 1 day, maximum is 365 days.
If the container soft delete has been enabled and is disabled, this policy will automatically enable the setting again.

Container soft delete protects your data from being accidentally or erroneously modified or deleted. When container soft delete is enabled for a storage account, a container and its contents may be recovered after it has been deleted, within a retention period that you specify. For more details about container soft delete, see https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-container-overview.
