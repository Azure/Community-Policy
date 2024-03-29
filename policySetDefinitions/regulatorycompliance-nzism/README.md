# Deploy NZISM Restricted policy initiative to Azure
## Initiatve and NZISM Version 3.6

This document covers how to deploy and use the NZ ISM Restricted Policy Initiative.  If you have any feedback or requests, please send them to nzism@gcsb.govt.nz or contact bevan.sinclair@microsoft.com

## What is the NZISM Restricted Policy Initiative?

This policy initiative is a selection of built-in Azure policies that match controls in the current version of the NZISM.  It is designed to ensure that your Azure environment is operating at a level conformant with the Restricted level of security as defined in the NZISM.  The usage of this template is consistent with Microsoft's recommended practice for Compliance policies in that it is an assessment of the environment against a standard, not as an enforcement of that standard.  To that end, this policy initiative should always be deployed in Audit Only, and any non-compliance should be managed as an internal process to understand why a service is non-compliant, then remediated through design and re-deployment.

Before deploying this initiative in a Production subscription or management group in Azure, please ensure that you have tested the impact in a test subscription or management group as per recommended Microsoft practice for policy deployment.

To move to a more scalable and audited pattern for managing Azure Policy, utilise a CI/CD pipeline to deploy the policy initiative and manage it as code.  For more details about policy management as code, please see the Enterprise Policy As Code documentation and code repo https://aka.ms/epac

## Deployment and Assignment

There are two methods documented here for manual deployment either through powershell on your local PC, or via the Azure Cloud Shell.  This allows you to deploy to either a specific Subscription or Management Group for targeted assignment of a resource within that scope.  This is useful for testing or tightly scoped deployments in small environments.

In larger environments, it would be recommended to wrap this initiative into an automated solution from your own git repo via a pipeline to ensure quality control and audit capabilities.

## Prerequisites
To install the NZISM Restricted Policy Initiative, you will need:

1. Azure CLI - https://learn.microsoft.com/en-us/cli/azure/
2. Permission to create and assign policies in your Azure subscription or management group

## Download the files

In this GitHub repo, select the deployment subfolder and download all of the files in that folder to a temporary folder on your local machine.

## Files in this package

Included in this package should be the following files:
1. nzism3.6.definitions.json - definitions file
>The definitions file contains all of the policies and their linked groups and parameters for the NZISM initiative.  The definitions file is used to create the initiative in your subscription or management group.  The definitions file is also used to create the policy assignments for the initiative.
2. nzism3.6.groups.json - groups file
>The groups file contains the details of each control from the NZISM, including links to the initiative published on the NCSC website.
3. nzism3.6.parameters.json
>The parameters file contains any configurable parameter for each policy in the initiative and the appropriate values for each parameter where it is not covered by the default value.  All of these are set to Audit or have a specific value that mateches the NZISM control requirement.  e.g. Minimum RSA Key size is 3072
4. nzism_deployment.md
>This document you are reading.
5. deploy-initiative.ps1
>Sample PowerShell script to deploy the initiative to your subscription or management group

## Deploy initiative to your tenant using script

Download the files in this package individually or as a zip and extract them to a temporary folder.  The example below will be using C:\Temp

Open a powershell prompt and CD to the folder where you extracted the files

Run the following command to deploy the initiative to your tenant - you must specify either a subscription ID or management group (but not both)
```powershell
.\deploy-initiative.ps1 -subscriptionId <subscriptionId> -managementGroupId <managementGroupId>
```
Once complete with no errors, you will see the initiative in the Azure portal under Policy > Definitions

FYI - if you want to output the policy file that gets created as part of this deployment, you can append the command above with the following
```powershell
.\deploy-initiative.ps1 -subscriptionId <subscriptionId> -managementGroupId <managementGroupId> | Out-File -FilePath .\nzism3.6.policy.json
```
## Create an assignment in the Policy portal

Once the initiative is deployed, you can create an assignment to apply the initiative to a subscription or management group.  Remember that you cannot assign a policy to a different level to which it is deployed so ensure your deployment matches the intended scope of the assignment.

1. Log into the Azure portal and navigate to the Policy blade
2. Click on Definitions and click on the New Zealand ISM Restricted v3.6 initiative you deployed.
3. Click Assign Initiative
4. The scope should be automatically set to the subscription or management group where you deployed the initiative.  If not, select the appropriate scope.
5. The assignment name will default to the New Zealand ISM Restricted v3.6 initiative.  You can change this if you wish.
6. Set Policy Enforcement to Disabled.  While all policies and parameters are set to Audit, this is a recommended practice for all compliance policies.
7. Click Next
8. Resource Selectors and Overrides should be left blank.  Click Next
9. There should be no parameters to set.  Click Next
10. As the policy contains no deployifnotexists or modify effects, there is no remediation task to set, or Managed Identity required so ensure Managed Identity is deselected.  Click Next
11. Non-compliance messages should be left to default.  Click Next
12. Click Create

Once applied, you will see the initiative in the list of assignments for the subscription or management group.  You can click on the assignment to see the compliance state of the assignment.  Compliance is run once per day by default, but if you want to run this on demand, you can type the following command at the powershell or Azure shell prompt.

```powershell
az policy state trigger-scan
```

This defaults to the selected subscription, but you can specify a Resource Group to return a faster response on a smaller scope.

## Deploy initiative using Azure shell

As an alternative to running the script locally on your PC, you can take advantage of the cloud shell.  This is far more reliable as the cmdlets are always up to date and authentication is already established within the shell

1. Log into the Azure portal and open the cloud shell
>Git is preinstalled in the cloud shell so no need to install it
2. You should be in the clouddrive folder by default, but if not, change directory so you are in the clouddrive folder 
```bash
cd /home/<username>/clouddrive
```
3. Create a folder for your repos you use in your clouid shell.  For this example I will use 'repos'.  Once created, CD into the new dir
```bash
mkdir repos
cd repos
```
4. Clone the Azure Community repo to your cloud shell
```bash
git clone https://github.com/Azure/Community-Policy
```
5. Change directory to the NZISM Policy Definition folder
```bash
cd Community-Policy/policySetDefinitions/regulatorycompliance-nzism
```
6. Run one of the following 2 commands to deploy to either a Management Group or a Subscription

### To deploy to a Management Group use this command and replace *MANAGEMENT GROUP ID* with your Management Group GUID
```bash
az policy set-definition create --name nzism-3.6-policyset --display-name "New Zealand ISM Restricted v3.6" --metadata "category=Regulatory Compliance","version=1.1" --description "This initiative includes policies that address a subset of New Zealand Information Security Manual v3.6 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/nzism-initiative." --definitions 'azurepolicyset.definitions.json' --params 'azurepolicyset.parameters.json' --definition-groups 'azurepolicyset.groups.json' --management-group <MANGEMENT GROUP ID>
```

### To deploy to a Subscription use this command and replace *SUBSCRIPTION ID* with your Subscription GUID
```bash
az policy set-definition create --name nzism-3.6-policyset --display-name "New Zealand ISM Restricted v3.6" --metadata "category=Regulatory Compliance","version=1.1" --description "This initiative includes policies that address a subset of New Zealand Information Security Manual v3.6 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/nzism-initiative." --definitions 'azurepolicyset.definitions.json' --params 'azurepolicyset.parameters.json' --definition-groups 'azurepolicyset.groups.json' --subscription <SUBSCRIPTION ID>
```

7. After about 30 seconds the initiative will appear in the Policies console, ready to be assigned.

## Assignment via the Cloud Shell

Once the Policy is deployed to the Management Group or Subscription, you can run the following command to assign the policy.

Valid scopes are management group, subscription, resource group, and resource, for example:

| Scope | Parameter Format|
|-------|-----------------|
| Management Group | /providers/Microsoft.Management/managementGroups/MyManagementGroup |
| Subscription | /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333 |
| Resource Group | /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup |
| Resource | /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM |

This example expects the policy initiative to have been deployed to the subscription, and creates an assignment on the subscription.  If you have deployed it to the Management Group, change the --policy parameter to match your Management Group scope as per the format above.

```bash
az policy assignment create --name 'New Zealand ISM Restricted v3.6' --policy '/subscriptions/<SUBSCRIPTION ID>/providers/Microsoft.Authorization/policySetDefinitions/nzism-3.6-policyset' --enforcement-mode 'DoNotEnforce' --scope "/subscriptions/<SUBSCRIPTION ID>"
```

Once applied, you will see the initiative in the list of assignments for the subscription or management group.  You can click on the assignment to see the compliance state of the assignment.  Compliance is run once per day by default, but if you want to run this on demand, you can type the following command at the powershell or Azure shell prompt.

```bash
az policy state trigger-scan
```

This defaults to the selected subscription, but you can specify a Resource Group to return a faster response on a smaller scope.

## Feedback

Your use and feedback on this initiative is appreciated.  Please send any feedback to the email addresses mentioned at the top of this document.

## Documentation links

* [Azure Policy Recommended Practices](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/azure-policy-recommended-practices/ba-p/3798024)
* [Enterprise Policy As Code](https://aka.ms/epac)
* [Azure safe deployment practices for Policy](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/policy-safe-deployment-practices)
* [Azure Policy Compliance](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data)
* [Az policy command reference](https://learn.microsoft.com/en-us/cli/azure/policy?view=azure-cli-latest)
