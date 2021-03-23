# Enforce Naming Convention

This policy can be adapted to allow an organization to enforce a naming convention over their resources. This policy will deny the creation of a resource when the first segment does not contain a value in ["vm", "vnet", "kv", "sql"], the second segment does not contain a value in ["dev", "test", "prod"], and the third segment in ["centralus", "eastus", "westus"] (segments split by a "-")
