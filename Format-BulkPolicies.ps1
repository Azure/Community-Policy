# Fix folders without 3 files (azurepolicy.json, azurepolicy.parameters.json, azurepolicy.rules.json)

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$Path
)

#TODO: Check if folder has 3 files

# Get all folders in Policies folder and create folders in policyDefinitions folder
$folders = Get-ChildItem -Path ./Policies -Directory


Get-ChildItem -Path "C:\Folder" -Recurse -Filter "*.json" | Where-Object { $_.Name -notmatch 'azurepolicy.json|azurepolicy.parameters.json|azurepolicy.rules.json' } | Select-Object Directory -Unique