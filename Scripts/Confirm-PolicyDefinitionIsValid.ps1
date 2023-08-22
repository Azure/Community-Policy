<#
.SYNOPSIS

Validates Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements

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
    exit 2 # Errors found
}
else {
    if ($warningMessages.Count -gt 0) {
        $messagesString = "'$($file.FullName)' has auto-fix warnings:`n    "
        $messagesString += (($warningMessages.ToArray()) -join "`n    ")
        Write-Host $messagesString -ForegroundColor Yellow
        exit 3 # Warnings found
    }
    else {
        Write-Host "'$($file.FullName)' is valid." -ForegroundColor Blue
        exit 0 # No errors or warnings foundS
    }
}