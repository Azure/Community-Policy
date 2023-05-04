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
    . "$($PSScriptRoot)/Confirm-PolicyDefinitionIsValid.ps1" -fileName "Test/bad-file-name.json"
}   
catch {
    # supress the exception
    Write-Host "$_" -ForegroundColor Red
}
try {
    . "$($PSScriptRoot)/Confirm-PolicyDefinitionIsValid.ps1" -fileName "Test/*.json"
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
    $baseName = $_.BaseName
    try {
        . "$($PSScriptRoot)/Out-FormattedPolicyDefinitionToThreeFiles.ps1" -fileName $fileName -outputDirectory "./output/three-files/$baseName"
    }   
    catch {
        # supress the exception
        Write-Host "$_" -ForegroundColor Red
    }
}

Write-Information ""
Write-Information "==========================================================================================="
Write-Information "Test validating and rewriting as one files"
Write-Information "==========================================================================================="
Get-ChildItem -Path Test\*.json | ForEach-Object {
    #Get the file name
    $fileName = $_.FullName
    try {
        . "$($PSScriptRoot)/Out-FormattedPolicyDefinitionToOneFiles.ps1" -fileName $fileName -outputDirectory "./output/one-file"
    }   
    catch {
        # supress the exception
        Write-Host "$_" -ForegroundColor Red
    }
}

Write-Information ""
Write-Information "==========================================================================================="
Write-Information "Test validating ONLY"
Write-Information "==========================================================================================="
Get-ChildItem -Path Test\*.json | ForEach-Object {
    #Get the file name
    $fileName = $_.FullName
    try {
        . "$($PSScriptRoot)/Confirm-PolicyDefinitionIsValid.ps1" -fileName $fileName
    }   
    catch {
        # supress the exception
        Write-Host "$_" -ForegroundColor Red
    }
}
