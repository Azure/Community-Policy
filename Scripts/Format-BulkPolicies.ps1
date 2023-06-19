# Fix folders without 3 files (azurepolicy.json, azurepolicy.parameters.json, azurepolicy.rules.json)

[CmdletBinding()]
param (
    [parameter(Mandatory = $false, Position = 0)]
    [string] $inputDirectory = "$($PSScriptRoot)/../Policies",

    [parameter(Mandatory = $false, Position = 1)]
    [string] $outputDirectory = "$($PSScriptRoot)/output-bulk",

    [parameter(Mandatory = $false)]
    [switch] $removeProcssedPolicyDefinitions
)

. "$($PSScriptRoot)/Format-PolicyDefinition.ps1"

# Get all folders in Policies folder and create folders in policyDefinitions folder
$validPolicyDefinitions = 0
$displayNamePolicyDefinitions = 0
$autoFixedPolicyDefinitions = 0
$invalidPolicyDefinitions = 0

$folders = Get-ChildItem $inputDirectory -Directory
foreach ($folder in $folders) {
    $folderName = $folder.FullName
    $files = Get-ChildItem -Path $folderName -Filter "azurepolicy.json" -Recurse
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        $newDefinition, $warningMessages, $errorMessages, $path = Format-PolicyDefinition $content -category $folder.Name -alternateDisplayName $file.Directory.Name

        if ($errorMessages.Count -gt 0) {
            $messagesString = "'$($file.FullName)' failed validation:`n    "
            $messagesString += (($errorMessages.ToArray()) -join "`n    ")
            Write-Host $messagesString -ForegroundColor Red
            $invalidPolicyDefinitions++
        }
        else {
            if ($warningMessages.Count -gt 0) {
                if ($warningMessages[0].StartsWith("Policy displayName not found. Using ")) {
                    $messagesString = "'$($file.FullName)' auto-fixed displayName and $($warningMessages.Count -1) other auto-fixes."
                    Write-Host $messagesString -ForegroundColor Yellow
                    $displayNamePolicyDefinitions++
                }
                else {
                    $messagesString = "'$($file.FullName)' has $($warningMessages.Count) auto-fixes."
                    Write-Host $messagesString -ForegroundColor Blue
                    $autoFixedPolicyDefinitions++
                }
            }
            else {
                Write-Host "'$($file.FullName)' is valid." -ForegroundColor Blue
                $validPolicyDefinitions++
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
                $null = ($newParametersJson | Out-File -FilePath "$($basePath).parameters.json" -Encoding utf8 -Force -InformationAction SilentlyContinue)
                $null = ($newPolicyRuleJson | Out-File -FilePath "$($basePath).rules.json" -Encoding utf8 -Force -InformationAction SilentlyContinue)

                $readMeFileName = "$($file.DirectoryName)/README.md"
                if (Test-Path $readMeFileName) {
                    Copy-Item -Path $readMeFileName -Destination "$($folderPath)/README.md" -Force
                }
                if ($removeProcssedPolicyDefinitions) {
                    Remove-Item -Path $file.DirectoryName -Force -Recurse
                }
            }
        }
    }
}

$totalPolicyDefinitions = $validPolicyDefinitions + $displayNamePolicyDefinitions + $autoFixedPolicyDefinitions + $invalidPolicyDefinitions
Write-Host ""
Write-Host "-------------------------------------------------------------------------------------------------------" -ForegroundColor Magenta
Write-Host "Policy definition processed: $totalPolicyDefinitions" -ForegroundColor Magenta
Write-Host "-------------------------------------------------------------------------------------------------------" -ForegroundColor Magenta
Write-Host "Valid:        $($validPolicyDefinitions + $autoFixedPolicyDefinitions)" -ForegroundColor Blue
Write-Host "Display Name: $displayNamePolicyDefinitions" -ForegroundColor Yellow
Write-Host "Invalid:      $invalidPolicyDefinitions" -ForegroundColor Red
