# Deny SQL Server Virtual Machine License Model

Customers can leverage 3 different license models for their SQL Servers. These are Pay-as-You-Go ('PAYG'), Azure Hybrid Benefit ('AHUB'), and HA/DR ('DR'). This policy will DENY the creation of any SQL Server VM resource which does not conform to the specified License Model.

## Try on Portal

<!-- [![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Faudit-sql-server-public-network-access%2Fazurepolicy.json) -->

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deny-sql-server-vm-license" -DisplayName "Deny SQL Server VM License Model" -description "Denies the deployment and modification of any SQL Server Virtual Machine when attempting to set a license model not in compliance with the policy." -Policy '[To_Be_Filled_In_When_Code_Has_Been_Merged]' -Parameter '[To_Be_Filled_In_When_Code_Has_Been_Merged]' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
