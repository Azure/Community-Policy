# Activate Azure Benefits for Windows Arc Machines

> **Looking for SQL Server instead?** To configure the **license type for Arc-enabled SQL Server** (Paid / PAYG / LicenseOnly), use the companion sample: **[Configure Arc-enabled SQL Server license type](https://github.com/microsoft/sql-server-samples/tree/master/samples/manage/azure-arc-enabled-sql-server/compliance/arc-sql-license-type-compliance)**. This policy is for **Windows Server** machines only.

This policy activates Azure benefits for **Windows Server** machines managed by Azure Arc (`Microsoft.HybridCompute/machines`):

- **Windows Server 2025** with a **pay-as-you-go (PGS)** license → enables the pay-as-you-go product profile (ticks *Pay-as-you-go*).
- **2025 without PGS**, or **any pre-2025** Windows Server → enables **Software Assurance** (ticks *Software Assurance*).
- Only **licensed Windows Server** resources are evaluated; unlicensed servers are ignored.

> **Compliance note:** enabling Software Assurance is an attestation that the machine is covered by active Software Assurance. Only assign this where that is true for your estate.

## What's in this folder

| File | Purpose |
|---|---|
| `azurepolicy.json` | The **complete** definition, ARM-wrapped (`name`, `type`, `properties`). Use with `az` / PowerShell / pipelines. |
| `azurepolicy.rules.json` | Just the `policyRule` block. |
| `azurepolicy.parameters.json` | Just the `parameters` block. |
| `azurepolicy.portal.json` | **Portal paste** version — the `properties` contents only, ready for the portal's *Policy rule* box. |

## Choose your deployment path

### Option A — Command line / pipeline

Use the split files as-is.

**Azure CLI:**

```bash
az policy definition create \
  --name "activate-azure-benefits-windows-arc" \
  --display-name "Activate Azure Benefits for Windows Arc Machines" \
  --rules azurepolicy.rules.json \
  --params azurepolicy.parameters.json \
  --mode Indexed
```

**PowerShell:**

```powershell
New-AzPolicyDefinition `
  -Name "activate-azure-benefits-windows-arc" `
  -DisplayName "Activate Azure Benefits for Windows Arc Machines" `
  -Policy "azurepolicy.rules.json" `
  -Parameter "azurepolicy.parameters.json" `
  -Mode Indexed
```

Then assign and (because the effect is `DeployIfNotExists`) create a remediation task.

### Option B — Azure Portal (copy & paste)

The portal's **Policy definition → Policy rule** box expects **only the contents of `properties`**. Pasting the ARM-wrapped `azurepolicy.json` fails with:
*"Could not find member 'name' on object of type 'PolicyDefinitionProperties'."*

Steps:

1. **Policy → Definitions → + Policy definition.**
2. Set **Definition location**, **Name**, and **Category** = `Compute`.
3. Open [`azurepolicy.portal.json`](./azurepolicy.portal.json) in this folder, copy its entire contents, clear the **Policy rule** box and paste it in.
4. **Save**, then **Assign**. Because the effect is `DeployIfNotExists`, the assignment needs a **system-assigned managed identity + location** (the portal grants the Contributor role used for remediation). Create a **remediation task** for existing machines.

## Why three files, then?

The split (`rules` + `parameters`) exists for automation that consumes them separately. For the **portal**, you only ever paste the single `azurepolicy.portal.json` file.
