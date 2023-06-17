# Fix folders without 3 files (azurepolicy.json, azurepolicy.parameters.json, azurepolicy.rules.json)

[CmdletBinding()]
param (
    [parameter(Mandatory = $false, Position = 0)]
    [string] $inputDirectory = "$($PSScriptRoot)/Policies",

    [parameter(Mandatory = $false, Position = 0)]
    [string] $outputDirectory = "$($PSScriptRoot)/output-bulk"
)

#TODO: Check if folder has 3 files

# Get all folders in Policies folder and create folders in policyDefinitions folder
$folders = Get-ChildItem $inputDirectory -Directory
foreach ($folder in $folders) {
    $folderName = $folder.FullName
    $files = Get-ChildItem -Path $folderName -Filter "azurepolicy.json" -Recurse
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        $newDefinition, $warningMessages, $errorMessages, $path = Format-PolicyDefinition $content -category $folderName

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
            if ($warningMessages.Count -gt 0 -and $null -ne $newDefinition) {
                $messagesString = "'$($file.FullName)' has $($warningMessages.Count) auto-fix warnings; writing files to output."
                Write-Host $messagesString -ForegroundColor Blue
            }
            else {
                Write-Host "'$($file.FullName)' is valid; writing files to output." -ForegroundColor Blue
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

                # Find files and directories in $inputDirectory not named azurepolicy.json, azurepolicy.parameters.json or azurepolicy.rules.json and copy them to $folderPath
                $readMeFile = Get-ChildItem -Path "$($file.DirectoryName)/README.md"
                if ($readMeFile) {
                    Copy-Item -Path $readMeFile.FullName -Destination "$($folderPath)/README.md" -Force
                }
            }
        }
    }
}


