# Community Policy Repo

<!-- 
Guidelines on README format: https://review.learn.microsoft.com/help/contribute/samples/concepts/readme-template

Guidance on onboarding samples to learn.microsoft.com/samples: https://review.learn.microsoft.com/help/contribute/samples/process/onboarding
-->

The purpose of this repo is for Azure Policy users and Microsoft internal teams to share and collaborate on custom policies. These policies are built either by customers or Microsoft Support engineers for customers. These are NOT Built-in policies hence are not check, tested or validated in any form by the Azure Policy Release Team. Please be wary of this and always TEST your policies before enforcing. Happy Coding! 

For Built-in policies repo, please visit here: [azure-policy](https://github.com/Azure/azure-policy)


## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

To get started contributing to the samples, please visit our [**contribution guide**](https://github.com/Azure/Community-Policy/blob/master/CONTRIBUTING.md). We also have a PowerShell script that will validate your Policy against the contribution guide and fix problems for you. You can find it [**here**](https://github.com/Azure/Community-Policy/blob/main/Scripts/Confirm-PolicyDefinitionIsValid.ps1).

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.


# Getting Support

The general Azure Policy support role that this repository has is not supported by standard Azure support channels. See below for information about getting support help for Azure Policy.

### General Questions

If you have questions you haven't been able to answer from the [**Azure Policy documentation**](https://docs.microsoft.com/azure/governance/policy), there are a few places that host discussions on Azure Policy:

 - [Microsoft Tech Community](https://techcommunity.microsoft.com/) [**Azure Governance conversation space**](https://techcommunity.microsoft.com/t5/Azure-Governance/bd-p/AzureGovernance)
 - Join the Monthly Call on Azure Governance (register [here](https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbRxn7UD7lweFDnmuLj72r6E1UN1dLNTBZUVMyNVpHUjJLRE5PVDVGNlkyOC4u))
 - Search or add to Azure Policy discussions on [**StackOverflow**](https://stackoverflow.com/questions/tagged/azure-policy+or+azure+policy)

If your questions are more in-depth or involve information that is not public, open a new [**Azure Customer Support ticket**](https://azure.microsoft.com/support/create-ticket/).

### Documentation Corrections

To report issues in the Azure Policy online documentation, look for a feedback area at the bottom of the page.

### New built-in Policy Proposals

If you have ideas for new built-in policies you want to suggest to Microsoft, you can submit them to [**Azure Governance Ideas**](https://feedback.azure.com/d365community/forum/675ae472-f324-ec11-b6e6-000d3a4f0da0). These suggestions are actively reviewed and prioritized for implementation.

### Other Support for Azure Policy

If you are encountering livesite issues or difficulties in implementing new policies that may be due to problems in Azure Policy itself, open a support ticket at [**Azure Customer Support**](https://azure.microsoft.com/support/create-ticket/). If you want to submit an idea for consideration, add an idea or upvote an existing idea at [**Azure Governance User Voice**](https://feedback.azure.com/forums/915958-azure-governance).


# Azure Policy Resources

## Articles

- [Azure Policy overview](https://learn.microsoft.com/azure/governance/policy/overview)
- [How to assign policies using the Azure portal](https://learn.microsoft.com/azure/governance/policy/assign-policy-portal)
- [How to assign policies using Azure PowerShell](https://learn.microsoft.com/azure/governance/policy/assign-policy-powershell)
- [How to assign policies using Azure CLI](https://learn.microsoft.com/azure/governance/policy/assign-policy-azurecli)
- [Export and manage Azure policies as code with GitHub](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/policy-as-code-github)
- [Definition structure](https://learn.microsoft.com/azure/governance/policy/concepts/definition-structure)
- [Understand Policy effects](https://learn.microsoft.com/azure/governance/policy/concepts/effects)
- [Programmatically create policies](https://learn.microsoft.com/azure/governance/policy/how-to/programmatically-create)
- [Get compliance data](https://learn.microsoft.com/azure/governance/policy/how-to/get-compliance-data)
- [Remediate non-compliant resources](https://learn.microsoft.com/azure/governance/policy/how-to/remediate-resources)

## References

- [Azure CLI](https://learn.microsoft.com/cli/azure/policy)
- Azure PowerShell
  - [Policy](https://learn.microsoft.com/powershell/module/az.resources/#policies)
- REST API
  - [Events](https://learn.microsoft.com/en-us/rest/api/policy/policy-events)
  - [States](https://learn.microsoft.com/en-us/rest/api/policy/policy-states)
  - [Assignments](https://learn.microsoft.com/rest/api/policy/policy-assignments)
  - [Policy Definitions](https://learn.microsoft.com/rest/api/policy/policy-definitions)
  - [Policy Set Definitions](https://learn.microsoft.com/rest/api/policy/policy-set-definitions)
  - [Policy Tracked Resources](https://learn.microsoft.com/rest/api/policy/policy-tracked-resources)
  - [Remediations](https://learn.microsoft.com/rest/api/policy/remediations)
