# Fix folders without 3 files (azurepolicy.json, azurepolicy.parameters.json, azurepolicy.rules.json)

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$Path
)

#TODO: Check if folder has 3 files

# Get all folders in Policies folder and create folders in policyDefinitions folder
$folders1 = Get-ChildItem -Path ./Policies -Directory
foreach ($folder1 in $folders1) {
    $folderName1 = $folder1.Name
    $folderPath1 = "./policyDefinitions/$folderName1"
    if (!(Test-Path -Path $folderPath1)) {
        New-Item -Path $folderPath1 -ItemType Directory
    }

    $folders2 = Get-ChildItem -Path $folderPath1 -Filter "*.json" | Where-Object { $_.Name -notmatch 'azurepolicy.json|azurepolicy.parameters.json|azurepolicy.rules.json' } | Select-Object Directory -Unique
    foreach ($folder2 in $folders2) {
        $folderName2 = $folder2.Name
        if (!(Test-Path -Path $folderPath)) {
            New-Item -Path $folderPath -ItemType Directory
        }
    }
}


