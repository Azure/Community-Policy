<#
.SYNOPSIS

Validates and repairs (formats) Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements
Fixes some errors with a warning
Outputs the file

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

    $file = Get-Item -Path $fileName
    $folderPath = $file.DirectoryName
    if (!([string]::IsNullOrEmpty($outputDirectory))) {
        $folderPath = $outputDirectory
        #create the directory if it doesn't exist
        if (!(Test-Path $folderPath)) {
            $null = (New-Item -ItemType Directory -Path $folderPath -Force -InformationAction SilentlyContinue)
        }
    }

    $baseName = $file.BaseName
    $fullPath = "$($folderPath)/$($baseName).json"
    $null = ($newDefinitionJson | Out-File -FilePath $fullPath -Encoding utf8 -Force)
}