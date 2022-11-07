# Audit Azure Machine Learning Compute Instances with an outdated operating system

Compute instances are non-compliant if the instance has a pending operating system image update. For more details, see [Vulnerability Management](https://learn.microsoft.com/azure/machine-learning/concept-vulnerability-management#compute-instance).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMachineLearningServices%2Faudit-compute-instance-os-version%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-compute-instance-os-version" -DisplayName "Audit Azure Machine Learning Compute Instances with an outdated operating system" -description "Compute instances are non-compliant if the instance has a pending operating system image update." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/MachineLearningServices/audit-compute-instance-os-version/azurepolicy.rules.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-compute-instance-os-version' --display-name 'Audit Azure Machine Learning Compute Instances with an outdated operating system' --description 'Compute instances are non-compliant if the instance has a pending operating system image update.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/MachineLearningServices/audit-compute-instance-os-version/azurepolicy.rules.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy 'audit-compute-instance-os-version' 

````
