$InformationPreference = "Continue"
Write-Information "==========================================================================================="
Write-Information "Test illegal fileName parameters"
Write-Information "==========================================================================================="
try {
    . ..\Submit-PolicyDefinitionFile.ps1 -fileName "bad-file-name.json" -outputDirectory ./output
}   
catch {
    # supress the exception
    Write-Host "Exception: $_" -ForegroundColor Red
}
try {
    . ..\Submit-PolicyDefinitionFile.ps1 -fileName "*.json"
}   
catch {
    # supress the exception
    Write-Host "Exception: $_" -ForegroundColor Red
}

Write-Information ""
Write-Information "==========================================================================================="
Write-Information "Test validating and rewriting as three files"
Write-Information "==========================================================================================="
Get-ChildItem -Path .\*.json | ForEach-Object {
    #Get the file name
    $fileName = $_.Name
    try {
        . ..\Submit-PolicyDefinitionFile.ps1 -fileName $fileName -outputDirectory ./output/three-files
    }   
    catch {
        # supress the exception
        Write-Host "Exception: $_" -ForegroundColor Red
    }
}

Write-Information ""
Write-Information "==========================================================================================="
Write-Information "Test validating and rewriting as one files"
Write-Information "==========================================================================================="
Get-ChildItem -Path .\*.json | ForEach-Object {
    #Get the file name
    $fileName = $_.Name
    try {
        . ..\Submit-PolicyDefinitionFile.ps1 -fileName $fileName -outputDirectory ./output/one-file -skipFileSplitting
    }   
    catch {
        # supress the exception
        Write-Host "Exception: $_" -ForegroundColor Red
    }
}

Write-Information ""
Write-Information "==========================================================================================="
Write-Information "Test validating ONLY"
Write-Information "==========================================================================================="
Get-ChildItem -Path .\*.json | ForEach-Object {
    #Get the file name
    $fileName = $_.Name
    try {
        . ..\Submit-PolicyDefinitionFile.ps1 -fileName $fileName -validateOnly
    }   
    catch {
        # supress the exception
        Write-Host "Exception: $_" -ForegroundColor Red
    }
}
