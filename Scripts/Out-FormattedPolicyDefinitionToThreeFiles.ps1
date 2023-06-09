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

.PARAMETER outputDirectory
Output directory. Default is output.

.PARAMETER category
Category of the Policy definition. Default is empty indicating to preserve the existing category in metadata.

.EXAMPLE
Out-FormattedPolicyDefinitionToOneFiles.ps1 -fileName azurepolicy.json -category "Custom"

.EXAMPLE
Out-FormattedPolicyDefinitionToOneFiles.ps1 -fileName azurepolicy.json

.EXAMPLE
Out-FormattedPolicyDefinitionToOneFiles.ps1 -fileName azurepolicy.json -outputDirectory "output"

#>

[CmdletBinding()]
param(
    [parameter(Mandatory = $true, Position = 0)]
    [string] $fileName,

    [parameter(Mandatory = $false, Position = 1)]
    [string] $outputDirectory = "output",

    [parameter(Mandatory = $false)]
    [string] $category = ""
)

. "$($PSScriptRoot)/Format-PolicyDefinition.ps1"
$newDefinition = Format-PolicyDefinition -fileName $fileName -category $category

if ($null -ne $newDefinition) {
    $newDefinitionJson = $newDefinition | ConvertTo-Json -Depth 100

    $newDisplayName = $newDefinition.properties.displayName

    $file = Get-Item -Path $fileName
    $folderPath = $file.DirectoryName
    if (!([string]::IsNullOrEmpty($outputDirectory))) {
        $folderPath = ($outputDirectory + "\" + $newDisplayName)
        #create the directory if it doesn't exist
        if (!(Test-Path $folderPath)) {
            $null = (New-Item -ItemType Directory -Path $folderPath -Force -InformationAction SilentlyContinue)
        }
    }

    # $action -eq "split"
    $newParameters = $newDefinition.properties.parameters
    $newPolicyRule = $newDefinition.properties.policyRule
    $basePath = "$($folderPath)/azurepolicy"
   $null = ($newDefinitionJson | Out-File -FilePath "$($basePath).json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
    $null = ($newParameters | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($basePath).parameters.json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
    $null = ($newPolicyRule | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($basePath).rules.json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
}
