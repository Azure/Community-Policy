This policy will configure (Modify-effect) if storage accounts does not have blob soft delete enabled. Minimum value is 1 day, maximum is 365 days.
If the blob soft delete has been enabled and is disabled, this policy will automatically enable the setting again.

Blob soft delete protects an individual blob, snapshot, or version from accidental deletes or overwrites by maintaining the deleted data in the system for a specified period of time. During the retention period, you can restore a soft-deleted object to its state at the time it was deleted. After the retention period has expired, the object is permanently deleted. https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview
