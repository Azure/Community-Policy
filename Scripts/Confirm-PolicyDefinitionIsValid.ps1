<#
.SYNOPSIS

Validates and repairs (formats) Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements
Fixes some errors with a warning
Splits the file into the required three files

.PARAMETER fileName
Input file name. Default is azurepolicy.json.

.PARAMETER category
Category of the Policy definition. Default is empty indicating to preserve the existing category in metadata.

.EXAMPLE
Confirm-PolicyDefinitionIsValid.ps1 -fileName azurepolicy.json -category "Custom"

.EXAMPLE
Confirm-PolicyDefinitionIsValid.ps1 -fileName azurepolicy.json

#>

[CmdletBinding()]
param(
    [parameter(Mandatory = $true, Position = 0)]
    [string] $fileName,

    [parameter(Mandatory = $false)]
    [string] $category = ""

)

. "$($PSScriptRoot)/Format-PolicyDefinition.ps1"
$null = Format-PolicyDefinition -fileName $fileName -category $category -validateOnly
