<#
.DESCRIPTION
    This script is used to invoke the tests for the scripts in this folder.

.EXAMPLE
PS> .\Invoke-ScriptTests.ps1

#>

[CmdletBinding()]
param (
)
    
$InformationPreference = "Continue"
Write-Information "==========================================================================================="
Write-Information "Test illegal fileName parameters"
Write-Information "==========================================================================================="
try {
    . "$($PSScriptRoot)/Out-FormattedPolicyDefinition.ps1" -fileName "Test/bad-file-name.json" -outputDirectory "$($PSScriptRoot)/output"
}   
catch {
    # supress the exception
    Write-Host "$_" -ForegroundColor Red
}
try {
    . "$($PSScriptRoot)/Out-FormattedPolicyDefinition.ps1" -fileName "Test/*.json" -outputDirectory "$($PSScriptRoot)/output"
}   
catch {
    # supress the exception
    Write-Host "$_" -ForegroundColor Red
}

Write-Information ""
Write-Information "==========================================================================================="
Write-Information "Test validating and rewriting as three files"
Write-Information "==========================================================================================="
Get-ChildItem -Path Test\*.json | ForEach-Object {
    #Get the file name
    $fileName = $_.FullName
    try {
        . "$($PSScriptRoot)/Out-FormattedPolicyDefinition.ps1" -fileName $fileName -outputDirectory "$($PSScriptRoot)/output"
    }   
    catch {
        # supress the exception
        Write-Host "$_" -ForegroundColor Red
    }
}
