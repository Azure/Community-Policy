# Community Policy repo - Contribution guide

This repository contains custom policies contributed by the community.

**Note:** To make sure your Azure Policy sample is added to this repository, please follow these guidelines. Any Azure Policy contribution PR will be **rejected** and not be merged.

## Files, folders and naming conventions

Policy definitions must be in a two-level folder hierarchy inside `policyDefinitions` folder. Every Azure Policy and its associated files must be contained in its own **folder**, into the folder representing the relevant Resource Provider (Compute for VM based policies, Storage for storage based policies etc.)

- Level 1 subfolder are named after the `metadata.category` (corresomds loosly to Azure Resource Provider); e.g. `Compute`, `Storage`, `Key Vault` etc. For a list of valid categories see [`Format-PolicyDefinition.ps1``](Scripts/Format-PolicyDefinition.ps1).
- Level 2 should be named after the policy display name where whitespace and special characters are repaced with dashes and all upercase letters converted to lowercase ones; e.g. `deny-vm-storage-account` or `allowed-network-locations`.
- **Protip** - Try to keep the name of your display name (template folder) short so that it fits inside the Github folder name column width.
- Github uses ASCII for ordering files and folder. For consistent ordering **create all files and level 2 folders in lowercase**.
- **Major Change:** Do not include a **README.md**; instead put a description that explains how the Azure Policy works in the Policy definition.
- An Azure Policy needs to include the following files:
  - **azurepolicy.json** - The JSON that describes the policy, including parameters and the rules.
  - **azurepolicy.rules.json** - The JSON that describes the policy rules only.
  - **azurepolicy.parameters.json** - The JSON that describes the parameters only, for the policy.
- Important: **Do not nest folders beyond two levels.**

## Pull requests

Pull requests **must:**

- Contain a single Policy in a folder by itself with 3 files: `azurepolicy.json`, `azurepolicy.rules.json`, and `azurepolicy.parameters.json`.
- Requests for changes must be answered within 10 days. If no response is received, the PR will be closed.

We created validation and re-formatting scripts located in the Scripts folder:

- [Out-FormattedPolicyDefinition.ps1](Scripts/Out-FormattedPolicyDefinition.ps1).

It is a set PowerShell script that:

- Takes in a single complete Policy definition file. It ignores the `.rules` and `.parameters` files.
- Checks required elements
- Repairs definitions (e.g., name must be a GUID, version, effect parameter name, allowed values, etc.)
- Splits the complete Json file into the required three files

You must run this before any PR. In a future release this will be automatically executed for each Pull Request; [see Issue 282](https://github.com/Azure/Community-Policy/issues/282).

We also have scripts to only validate the file: [Confirm-PolicyDefinitionIsValid.ps1](Scripts/Confirm-PolicyDefinitionIsValid.ps1)


## Required elements

Every Policy and Policy Set (Initiative) Definition **must** include:

- Top level (not under properties)
  - `name` **must** be a GUID, enables updates to a Policy without declaring it a new Policy or Policy Set.
  - `type` **must** be `"Microsoft.Authorization/policyDefinitions"`
- Nested `properties` structure with only the `name` outside.
  - `displayName` for the Policy is required
  - `description` is required
  - `metadata` is required
  - `mode` is required
  - `displayName` for `parameters` is required
  - `version` - in `metadata`; use semantic versioning.
  - `category` - in `metadata`, must be one of the categories in the built-in Policies and Policy Sets, indicating the Azure Service.

Do not include system generated properties:

- `properties.policyType`
- `properties.metadata` fields:
  - `createdOn`
  - `createdBy`
  - `updatedOn`
  - `updatedBy`

### Parameter definitions

- Parameter name **must** be camelCase; e.g.: `effect`, `eventHubName`, ...
- Provide `allowedValues` when it is a known set of legal values.
- Provide a `defaultValue` whenever possible.
- Provide a `displayName` for each parameter.

### Parameterized `effect`

The effect **must** be parameterized.

- In Policy definitions always use the name `effect`, displayName `Effect`, and type `String`. Do not use any other names.
- In Policy Set (Initiative) definition pass all `effect` parameters on as Policy Set parameters. You must create unique names. Try to follow a standard pattern which indicates the Policy within the Policy Set is used, such as, `effect-policyName_or_policyDisplayName`. We are not requiring a specific pattern as long as there is consistency.
- `allowedValues` and `defaultValue` are required.
- Effect parameter values must be PascalCase (**never** use camelCase)

Effects come in groupings expressed as `allowedValues` arrays in JSON. **Do not use any other combinations**.

| `"allowedValues"`                                                        | `"defaultValue"`                                |
| :----------------------------------------------------------------------- | :---------------------------------------------- |
| `"Append", "Deny", "Audit", "Disabled"`                                  | `Append`                                        |
| `"Modify", "Deny", "Audit", "Disabled"`                                  | `Modify`                                        |
| `"Deny", "Audit", "Disabled"`                                            | `Audit`                                         |
| `"Audit", "Disabled"` <br/> Use only when Deny is not possible           | `Audit`                                         |
| `"DeployIfNotExists", "AuditIfNotExists", "Disabled"`                    | `AuditIfNotExists` or <br/> `DeployIfNotExists` |
| `"AuditIfNotExists", "Disabled"`                                         | `AuditIfNotExists`                              |
| `"DenyAction", "Disabled"`                                               | `DenyAction`                                    |
| `"Manual", "Disabled"`                                                   | `Manual`                                        |

Example:
  
```json
{
  "parameters": {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "DeployIfNotExists, AuditIfNotExists or Disabled the execution of the Policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "AuditIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    }
  }
}
```

### Require `roleDefinitionIds` for `Modify` and `DeployIfNotExists`

Effects `Modify` and `DeployIfNotExists` require a list of `roleDefinitionIds` under details. See:

- <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects#deployifnotexists-properties>
- <https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects#modify-properties>

## README.md (deprecated)

README.md file should not be included. This previous requirement has been deprecated. Instead, include a description in the Policy definition what the Azure Policy will do.

## Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Helpful resources

- [AzAdvertizer](https://www.azadvertizer.net/index.html)
- [Enterprise Azure Policy As Code](https://aka.ms/epac)
- [Git tutorial](https://guides.github.com/activities/hello-world/)
