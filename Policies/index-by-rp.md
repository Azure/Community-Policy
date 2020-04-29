# Azure Policy community definitions

This page is an index of [Azure Policy](https://docs.microsoft.com/azure/governance/policy) community policy definitions.

Use the link in the **Name** column to view the source. The definitions are grouped by the
**Resource Provider** from the **type** or **field** in the **policyRule** portion of the
definition. Use <kbd>Ctrl</kbd>-<kbd>F</kbd> to use your browser's search feature.

## aks engine

|Name |Description |Effect(s) |
|---|---|---|
|[Do not allow container privilege escalation in Kubernetes cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/container-no-privilege-escalation/azurepolicy.json) |This policy does not allow containers to use privilege escalation in a Kubernetes cluster. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |
|[Ensure only allowed app armor profiles are used in Kubernetes Cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/enforce-apparmor-profile/azurepolicy.json) |This policy ensures containers define an App Armor profile and only use allowed App Armor profiles. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |
|[Ensure only allowed capabilities are used in Kubernetes Cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/container-allowed-capabilities/azurepolicy.json) |This policy ensures specified security capabilities are defined and removed inside a Kubernetes cluster. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |

## microsoft.authorization

|Name |Description |Effect(s) |
|---|---|---|
|[Allowed Principal Ids](https://github.com/Azure/Community-Policy/blob/master/Policies/Authorization/allowed-principal-ids/azurepolicy.json) |This policy defines a white list of Principal IDs that can be used in IAM |Deny, Disabled |
|[Allowed Role Definitions](https://github.com/Azure/Community-Policy/blob/master/Policies/Authorization/allowed-role-definitions/azurepolicy.json) |This policy defines a white list of role definitions that can be used in IAM |Deny, Disabled |
|[Allowed Role Definitions For Specific Principal IDs](https://github.com/Azure/Community-Policy/blob/master/Policies/Authorization/allowed-role-definitions-for-specific-principal-ids/azurepolicy.json) |This policy defines a white list of role definitions that can be assigned to specific Principal IDs in IAM. This is useful in the example where you don't want an SPN having it's rights elevated. |Deny, Disabled |
|[Disallowed Role Definitions](https://github.com/Azure/Community-Policy/blob/master/Policies/Authorization/disallowed-role-definitions/azurepolicy.json) |This policy defines a black list of role deifnitions that can not be used in IAM |Deny, Disabled |

## microsoft.compute

|Name |Description |Effect(s) |
|---|---|---|
|[Audit SSH Auth on Existing Resources](https://github.com/Azure/Community-Policy/blob/master/Policies/Compute/audit-existing-linux-vm-ssh-with-password/azurepolicy.json) |This policy audits whether any Linux VMs use password-only authentication for SSH on existing resources. |audit |

## microsoft.containerregistry

|Name |Description |Effect(s) |
|---|---|---|
|[Enforce Admin User is disabled on all Container Registry instances](https://github.com/Azure/Community-Policy/blob/master/Policies/ContainerRegistry/container-registry-admin-user-filter/azurepolicy.json) |This policy ensures Admin User is disabled on all Container Registry instances |deny |

## microsoft.containerservice

|Name |Description |Effect(s) |
|---|---|---|
|[Append AKS API IP Restrictions](https://github.com/Azure/Community-Policy/blob/master/Policies/KubernetesService/append-aks-api-ip-restrictions/azurepolicy.json) |This policy will restrict access to the AKS API server as documented here: [https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges](https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges) |append |
|[Do not allow container privilege escalation in Kubernetes cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/container-no-privilege-escalation/azurepolicy.json) |This policy does not allow containers to use privilege escalation in a Kubernetes cluster. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |
|[Ensure only allowed app armor profiles are used in Kubernetes Cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/enforce-apparmor-profile/azurepolicy.json) |This policy ensures containers define an App Armor profile and only use allowed App Armor profiles. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |
|[Ensure only allowed capabilities are used in Kubernetes Cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/container-allowed-capabilities/azurepolicy.json) |This policy ensures specified security capabilities are defined and removed inside a Kubernetes cluster. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |

## microsoft.dbformysql

|Name |Description |Effect(s) |
|---|---|---|
|[Enforce SSL on all DB for MySQL instances](https://github.com/Azure/Community-Policy/blob/master/Policies/DBforMySQL/db-for-mysql-ssl-enforce-filter/azurepolicy.json) |This policy ensures SSL is enforced on all DB for MySQL instances |deny |

## microsoft.dbforpostgresql

|Name |Description |Effect(s) |
|---|---|---|
|[Allowed PostgreSQL SKUs](https://github.com/Azure/Community-Policy/blob/master/Policies/PostgreSQL/allowed-skus/azurepolicy.json) |PostgreSQL DB creation will fail if a SKU other than what's defined in this Policy is selected. |deny |

## microsoft.documentdb

|Name |Description |Effect(s) |
|---|---|---|
|[Audit IP Range Filter for CosmosDB accounts](https://github.com/Azure/Community-Policy/blob/master/Policies/CosmosDB/audit-cosmosdb-ip-range-filter/azurepolicy.json) |This policy audits that the IP Range Filter attribute is configured for CosmosDB accounts |audit |

## microsoft.eventhub

|Name |Description |Effect(s) |
|---|---|---|
|[Event Hub firewall should only allow certain IPs](https://github.com/Azure/Community-Policy/blob/master/Policies/EventHub/allowed-event-hub-firewall-ip/azurepolicy.json) |This policy allows only restricted IPs for Event hub firewall |deny |

## microsoft.insights

|Name |Description |Effect(s) |
|---|---|---|
|[Apply Diagnostic Settings for Azure SQL to a regional Event Hub](https://github.com/Azure/Community-Policy/blob/master/Policies/Monitoring/apply-diagnostic-setting-azsql-eventhub/azurepolicy.json) |This policy automatically deploys diagnostic settings for Azure SQL to a regional event hub. |deployIfNotExists |

## microsoft.keyvault

|Name |Description |Effect(s) |
|---|---|---|
|[Audit if Key Vault has no virtual network rules](https://github.com/Azure/Community-Policy/blob/master/Policies/KeyVault/audit-keyvault-vnet-rules/azurepolicy.json) |Audits Key Vault vaults if they do not have virtual network service endpoints set up. More information on virtual network service endpoints in Key Vault is available here: [https://docs.microsoft.com/en-us/azure/key-vault/key-vault-overview-vnet-service-endpoints](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-overview-vnet-service-endpoints) |audit |

## microsoft.kubernetes

|Name |Description |Effect(s) |
|---|---|---|
|[Do not allow container privilege escalation in Kubernetes cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/container-no-privilege-escalation/azurepolicy.json) |This policy does not allow containers to use privilege escalation in a Kubernetes cluster. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |
|[Ensure only allowed app armor profiles are used in Kubernetes Cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/enforce-apparmor-profile/azurepolicy.json) |This policy ensures containers define an App Armor profile and only use allowed App Armor profiles. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |
|[Ensure only allowed capabilities are used in Kubernetes Cluster](https://github.com/Azure/Community-Policy/blob/master/Policies/Kubernetes/container-allowed-capabilities/azurepolicy.json) |This policy ensures specified security capabilities are defined and removed inside a Kubernetes cluster. For instructions on using this policy, please visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |enforceOPAConstraint, disabled |

## microsoft.network

|Name |Description |Effect(s) |
|---|---|---|
|[Audit unattached static Public IPs](https://github.com/Azure/Community-Policy/blob/master/Policies/Network/audit-unattached-static-public-ips/azurepolicy.json) |Static Public IPs incur cost even when not in use. This Policy will help you detect the existence of unattached static Public IPs in the effort to help drive down cost. |deny |
|[Vnet peering disallowed outside subscription](https://github.com/Azure/Community-Policy/blob/master/Policies/Network/peering-outside-disallowed/azurepolicy.json) |No network peering can be associated to networks outside the current subscription. |deny |
|[VNet Peering is only allowed to approved VNets.](https://github.com/Azure/Community-Policy/blob/master/Policies/Network/deny-peering-to-non-approved-vnets/azurepolicy.json) |If you try to peer to a VNet that's not on the list of approved VNets then the action will be denied. |Deny, Disabled |

## microsoft.sql

|Name |Description |Effect(s) |
|---|---|---|
|[Apply Diagnostic Settings for Azure SQL to a regional Event Hub](https://github.com/Azure/Community-Policy/blob/master/Policies/Monitoring/apply-diagnostic-setting-azsql-eventhub/azurepolicy.json) |This policy automatically deploys diagnostic settings for Azure SQL to a regional event hub. |deployIfNotExists |

## microsoft.storage

|Name |Description |Effect(s) |
|---|---|---|
|[Deny cool access tiering for storage accounts](https://github.com/Azure/Community-Policy/blob/master/Policies/Storage/storage-account-access-tier/azurepolicy.json) |Ensures there's no usage of cool access tiering for storage. |deny |
|[Deploy 'Geo-redundant' replication on Storage Account](https://github.com/Azure/Community-Policy/blob/master/Policies/Storage/deploy-geo-redundant-replication/azurepolicy.json) |This policy set geo-redundancy on storage accounts. |DeployIfNotExists |

## microsoft.web

|Name |Description |Effect(s) |
|---|---|---|
|[Allowed App Services Plan SKUs](https://github.com/Azure/Community-Policy/blob/master/Policies/App%20Service/allowed-appservicesplan-skus/azurepolicy.json) |This policy enables you to specify a set of App Services Plan SKUs that your organization can deploy. |Deny |

## Next steps

- See the built-ins on the [Azure Policy GitHub repo](https://github.com/Azure/azure-policy).
- Review the [Azure Policy definition structure](https://docs.microsoft.com/azure/governance/policy/concepts/definition-structure).
- Review [Understanding policy effects](https://docs.microsoft.com/azure/governance/policy/concepts/effects).
