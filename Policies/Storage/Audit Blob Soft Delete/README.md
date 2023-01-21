This policy will audit if storage accounts have blob soft delete enabled.
It can be used to deny changes as well.

Blob soft delete protects an individual blob, snapshot, or version from accidental deletes or overwrites by maintaining the deleted data in the system for a specified period of time. During the retention period, you can restore a soft-deleted object to its state at the time it was deleted. After the retention period has expired, the object is permanently deleted. https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-blob-overview