<#
.SYNOPSIS

Validates and repairs (formats) Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements
Fixes some errors with a warning
Splits the file into the required three files

.PARAMETER fileName
Input file name.

.PARAMETER outputDirectory
Output directory. Default is output.

.PARAMETER category
Category of the Policy definition. Default is empty indicating to preserve the existing category in metadata.

.EXAMPLE
Out-FormattedPolicyDefinition.ps1 -fileName azurepolicy.json -category "Custom"

.EXAMPLE
Out-FormattedPolicyDefinition.ps1 -fileName azurepolicy.json

.EXAMPLE
Out-FormattedPolicyDefinition.ps1 -fileName azurepolicy.json -outputDirectory "output"

#>

[CmdletBinding()]
param(
    [parameter(Mandatory = $true, Position = 0)]
    [string] $fileName,

    [parameter(Mandatory = $false, Position = 1)]
    [string] $outputDirectory = "output",

    [parameter(Mandatory = $false)]
    [string] $category = "",

    [parameter(Mandatory = $false)]
    [switch] $singleFile
)

. "$($PSScriptRoot)/Format-PolicyDefinition.ps1"

$files = Get-ChildItem -Path $fileName -ErrorAction SilentlyContinue
if ($files.Count -eq 0) {
    throw "'$fileName' not found."
}
elseif ($files.Count -gt 1) {
    throw "Multiple files ($($files.Count)) found. Instead of '$fileName', specify a file, not a directory or wild card."
}

$file = $files[0]
$content = Get-Content $file.FullName -Raw
$newDefinition, $warningMessages, $errorMessages, $path = Format-PolicyDefinition $content -category $category

if ($errorMessages.Count -gt 0) {
    $messagesString = "'$($file.FullName)' failed validation:"
    $messagesString += "`n    Hard errors:`n        "
    $messagesString += (($errorMessages.ToArray()) -join "`n        ")
    if ($warningMessages.Count -gt 0) {
        $messagesString += "`n    Auto-fixes available:`n        "
        $messagesString += (($warningMessages.ToArray()) -join "`n        ")
    }
    Write-Host $messagesString -ForegroundColor Red
}
else {
    if ($warningMessages.Count -gt 0) {
        $messagesString = "'$($file.FullName)' has auto-fix warnings:`n    "
        $messagesString += (($warningMessages.ToArray()) -join "`n    ")
        Write-Host $messagesString -ForegroundColor Yellow
    }
    else {
        Write-Host "'$($file.FullName)' is valid." -ForegroundColor Blue
    }

    if ($null -ne $newDefinition) {

        $folderPath = $path
        if (!([string]::IsNullOrEmpty($outputDirectory))) {
            $folderPath = ($outputDirectory + "/" + $path)
        }
        #create the directory if it doesn't exist
        if (!(Test-Path $folderPath)) {
            $null = (New-Item -ItemType Directory -Path $folderPath -Force -InformationAction SilentlyContinue)
        }
        $newDefinitionJson = $newDefinition | ConvertTo-Json -Depth 100
        $newParametersJson = $newDefinition.properties.parameters | ConvertTo-Json -Depth 100
        $newPolicyRuleJson = $newDefinition.properties.policyRule | ConvertTo-Json -Depth 100
        $basePath = "$($folderPath)/azurepolicy"
        $null = ($newDefinitionJson | Out-File -FilePath "$($basePath).json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
        if (!$singleFile) {
            $null = ($newParametersJson | Out-File -FilePath "$($basePath).parameters.json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
            $null = ($newPolicyRuleJson | Out-File -FilePath "$($basePath).rules.json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
        }
    }
}
