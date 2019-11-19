# Community Policy Repo

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

The purpose of this repo is for Azure Policy users and Microsoft internal teams to share and colloborate on custom policies. These policies are built either by customers or Microsoft Support engineers for customers. These are NOT Built-in policies hence are not check, tested or validated in any form by the Azure Policy Release Team. Please be weary of this and always TEST your policies before enforcing. Happy Coding! 

For Built-in policies repo, please visit here: [azure-policy](https://github.com/Azure/azure-policy)

## Contents

Outline the file contents of the repository. It helps users navigate the codebase, build configuration and any related assets.

| File/folder       | Description                                |
|-------------------|--------------------------------------------|
| `src`             | Sample source code.                        |       
| `CONTRIBUTING.md` | Guidelines for contributing to the sample. |
| `README.md`       | This README file.                          |
| `LICENSE`         | The license for the sample.                |


## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

To get started contributing to the samples, please visit our [**contribution guide**](./1-contribution-guide/README.md#contribution-guide).

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.


# Azure Policy Resources

## Articles

- [Azure Policy overview](https://docs.microsoft.com/azure/governance/policy/overview)
- [How to assign policies using the Azure portal](https://docs.microsoft.com/azure/governance/policy/assign-policy-portal)
- [How to assign policies using Azure PowerShell](https://docs.microsoft.com/azure/governance/policy/assign-policy-powershell)
- [How to assign policies using Azure CLI](https://docs.microsoft.com/azure/governance/policy/assign-policy-azurecli)
- [Definition structure](https://docs.microsoft.com/azure/governance/policy/concepts/definition-structure)
- [Understand Policy effects](https://docs.microsoft.com/azure/governance/policy/concepts/effects)
- [Programmatically create policies](https://docs.microsoft.com/azure/governance/policy/how-to/programmatically-create)
- [Get compliance data](https://docs.microsoft.com/azure/governance/policy/how-to/get-compliance-data)
- [Remediate non-compliant resources](https://docs.microsoft.com/azure/governance/policy/how-to/remediate-resources)

## References

- [Azure CLI](https://docs.microsoft.com/cli/azure/policy)
- Azure PowerShell
  - [Policy](https://docs.microsoft.com/powershell/module/az.resources/#policies)
- REST API
  - [Events](https://docs.microsoft.com/rest/api/policy-insights/policyevents)
  - [States](https://docs.microsoft.com/rest/api/policy-insights/policystates)
  - [Assignments](https://docs.microsoft.com/rest/api/resources/policyassignments)
  - [Policy Definitions](https://docs.microsoft.com/rest/api/resources/policydefinitions)
  - [Initiative Definitions](https://docs.microsoft.com/rest/api/resources/policysetdefinitions)
  - [Policy Tracked Resources](https://docs.microsoft.com/rest/api/policy-insights/policytrackedresources)
  - [Remediations](https://docs.microsoft.com/rest/api/policy-insights/remediations)


## Getting Support

The general Azure Policy support role of this repository has is not supported by standard Azure support channels. See below for information about getting support help for Azure Policy.

### General Questions

If you have questions you haven't been able to answer from the [**Azure Policy documentation**](https://docs.microsoft.com/azure/governance/policy), there are a few places that host discussions on Azure Policy:

 - [Microsoft Tech Community](https://techcommunity.microsoft.com/) [**Azure Governance conversation space**](https://techcommunity.microsoft.com/t5/Azure-Governance/bd-p/AzureGovernance)
 - Join the Monthly Call on Azure Governance (register [here](https://aka.ms/joinazuregovernance))
 - Search or add to Azure Policy discussions on [**StackOverflow**](https://stackoverflow.com/questions/tagged/azure-policy+or+azure+policy)

If your questions are more in-depth or involve information that is not public, open a new [**Azure Customer Support ticket**](https://azure.microsoft.com/support/create-ticket/).

### Documentation Corrections

To report issues in the Azure Policy online documentation, look for a feedback area at the bottom of the page. If you don't see a place to enter feedback, you can also directly open a new issue at the [**Microsoft Docs GitHub**](https://github.com/MicrosoftDocs/feedback/issues).

### New built-in Policy Proposals

If you have ideas for new built-in policies you want to suggest to Microsoft, you can submit them to [**Azure Governance User Voice**](https://feedback.azure.com/forums/915958-azure-governance). These suggestions are actively reviewed and prioritized for implementation.

### Other Support for Azure Policy

If you are encountering livesite issues or difficulties in implementing new policies that may be due to problems in Azure Policy itself, open a support ticket at [**Azure Customer Support**](https://azure.microsoft.com/support/create-ticket/). If you want to submit an idea for consideration, add an idea or upvote an existing idea at [**Azure Governance User Voice**](https://feedback.azure.com/forums/915958-azure-governance).
