#Requires -PSEdition Core

<#
.SYNOPSIS

Validates and repairs Azure Policy definitions.

.DESCRIPTION

Takes in a complete Policy definition file
Checks required elements
Splits the file into the required three files

.PARAMETER fileName
Specifies the file name ro process. Positional parameter 0. Mandatory.

.PARAMETER outputDirectory
Specifies the output directory. If not supplied puts the output in the same directory and overwrites the input file. Positional parameter 1. Optional.

.PARAMETER validateOnly
Switch parameter to validate only without rewriting the file. Optional.

.PARAMETER skipFileSplitting
Switch parameter to skip creating the <filename>.parameters.json and <filename>.rules.json files. Optional.

.INPUTS

None. You cannot pipe objects to Submit-PolicyDefinitionFile.

.OUTPUTS

None.

.EXAMPLE

Submit-PolicyDefinitionFile.ps1 -fileName "<policy-directory>/azurepolicy.json"

.EXAMPLE

Submit-PolicyDefinitionFile.ps1 <policy-directory>/azurepolicy.json output-folder -skipFileSplitting

#>

param(
    [parameter(Mandatory = $true, Position = 0)] $fileName,
    [parameter(Mandatory = $false, Position = 1)] [string] $outputDirectory = "output",
    [switch] $validateOnly,
    [switch] $skipFileSplitting
)

$InformationPreference = "Continue"
$WarningPreference = "Continue"
$ErrorActionPreference = "Continue"

Write-Information "Processing $fileName"
$errorMessages = [System.Collections.ArrayList]::new()
$warningMessages = [System.Collections.ArrayList]::new()

$files = Get-ChildItem -Path $fileName -ErrorAction SilentlyContinue
if ($files.Count -eq 0) {
    throw "File '$fileName' not found."
}
elseif ($files.Count -gt 1) {
    throw "Multiple files ($($files.Count)) found. Instead of '$fileName', specify a file, not a directory or wild card."
}
$file = $files[0]
$content = Get-Content $file.FullName -Raw
if (!(Test-Json $content -ErrorAction SilentlyContinue)) {
    throw "File '$($fileName)' is not valid JSON."
}
$definition = ConvertFrom-Json $content -AsHashtable -Depth 100

# analyze structure
$properties = $definition
if ($definition.properties) {
    $properties = $definition.properties
}

$name = $definition.name
if (!$name) {
    if ($definition.id) {
        $idSplits = $definition.id -split "/"
        $name = $idSplits[-1]
    }
    elseif ($properties.id) {
        $idSplits = $properties.id -split "/"
        $name = $idSplits[-1]
    }
}
$oldName = $name
if ($name) {
    if (!([guid]::TryParse($name, $([ref][guid]::Empty)))) {
        $name = (New-Guid).Guid
        $null = $warningMessages.Add("Policy name '$oldName' not a GUID. Using generated GUID '$name' as the name.")
    }
}
else {
    $name = (New-Guid).Guid
    $null = $warningMessages.Add("Policy name missing. Using generated GUID '$name' as the name.")
}

$displayName = $properties.displayName
if (!$displayName) {
    if ([string]::IsNullOrEmpty($oldName) -or $oldName -eq $name) {
        $null = $errorMessages.Add("Policy displayName not found.")
    }
    else {
        $displayName = $oldName
        $null = $warningMessages.Add("Policy displayName not found. Using name '$oldName' as the displayName.")
    }
}
$description = $properties.description
if (!$description) {
    $null = $errorMessages.Add("Policy description not found.")
}


# Temporary until versions available
$metadataVersion = "1.0.0"
$metadata = $properties.metadata
if ($metadata) {
    $metadataVersion = $metadata.version
    if (!$metadata.version) {
        $null = $metadata.Add("version", $metadataVersion)
        $null = $warningMessages.Add("Policy metadata version not found. Defaulting to $($metadataVersion).")
    }
    else {
        $metadataVersion = $metadata.version
    }
}
else {
    $null = $properties.Add("metadata", @{
            version = $metadataVersion
        }
    )
    $null = $warningMessages.Add("Policy metadata version not found. Defaulting to $($metadataVersion).")
}

# $version = $properties.version
# if (!$version) {
#     if ($properties.metadata.version) {
#         $version = $properties.metadata.version
#         $null = $warningMessages.Add("version not found. Using version from metadata $($version)")
#     }
#     else {
#         $version = "1.0.0"
#         $null = $warningMessages.Add("version not found. Defaulting to $($version)")
#     }
# }


$mode = $properties.mode
if (!$mode) {
    $null = $errorMessages.Add("Policy mode not found.")
}

$category = $properties.metadata.category
if (!$category) {
    $category = $file.Directory.Parent.Name
    $null = $warningMessages.Add("Field category not found in metadata. Using parent directory name $category instead.")
    if (!$properties.metadata) {
        $properties.Add("metadata", @{
                category = $category
            }
        )
    }
    else {
        $properties.metadata.Add("Field category", $category)
    }
}

# analyze effect in then clause
$effect = $properties.policyRule.then.effect
if (!$effect) {
    $null = $errorMessages.Add("Policy effect not found. Every rule must have an effect.")
}
else {

    if ($effect -cne "[parameters('effect')]") {
        $null = $errorMessages.Add("Policy effect is not correctly parameterized. Change $effect to [parameters('effect')] and add a parameter definition for effect.")
    }
    elseif (!$properties.parameters.effect) {
        $null = $errorMessages.Add("effect parameter definition not found.")
    }
    else {

        $allowedValuesSets = @(
            @{
                hasMember     = "Append"
                defaultValue  = "Append"
                allowedValues = @("Append", "Deny", "Audit", "Disabled")
                defaultValues = @("Append", "Audit")
            },
            @{
                hasMember     = ""
                defaultValue  = "Append"
                allowedValues = @("Append", "Audit", "Disabled")
                defaultValues = @("Append", "Audit")
            },
            @{
                hasMember     = "Modify"
                defaultValue  = "Modify"
                allowedValues = @("Modify", "Deny", "Audit", "Disabled")
                defaultValues = @("Modify", "Audit")
            },
            @{
                hasMember     = ""
                defaultValue  = "Modify"
                allowedValues = @("Modify", "Audit", "Disabled")
                defaultValues = @("Modify", "Audit")
            },
            @{
                hasMember     = "Deny"
                defaultValue  = "Audit"
                allowedValues = @("Deny", "Audit", "Disabled")
                defaultValues = @("Audit")
            },
            @{
                hasMember     = "Audit"
                defaultValue  = "Audit"
                allowedValues = @("Audit", "Disabled")
                defaultValues = @("Audit")
            },
            @{
                hasMember     = "DeployIfNotExists"
                defaultValue  = "DeployIfNotExists"
                allowedValues = @("DeployIfNotExists", "AuditIfNotExists", "Disabled")
                defaultValues = @("DeployIfNotExists", "AuditIfNotExists")
            },
            @{
                hasMember     = "AuditIfNotExists"
                defaultValue  = "AuditIfNotExists"
                allowedValues = @("AuditIfNotExists", "Disabled")
                defaultValues = @("AuditIfNotExists")
            },
            @{
                hasMember     = "DenyAction"
                defaultValue  = "DenyAction"
                allowedValues = @("DenyAction", "Disabled")
                defaultValues = @("DenyAction")
            },
            @{
                hasMember     = "Manual"
                defaultValue  = "Manual"
                allowedValues = @("Manual", "Disabled")
                defaultValues = @("Manual")
            }
        )

        # find allowed values set
        $allowedValuesSet = $null
        $effectParameter = $properties.parameters.effect
        $allowedValues = $effectParameter.allowedValues
        $defaultValue = $effectParameter.defaultValue
        if ($allowedValues) {
            foreach ($set in $allowedValuesSets) {
                $setAllowedValues = $set.allowedValues
                if ($setAllowedValues.Count -eq $allowedValues.Count) {
                    $foundMatch = $true
                    foreach ($item1 in $setAllowedValues) {
                        $innerFoundMatch = $false
                        foreach ($item2 in $allowedValues) {
                            if ($item1 -ceq $item2) {
                                $innerFoundMatch = $true
                                break
                            }
                        }
                        if (!$innerFoundMatch) {
                            $foundMatch = $false
                            break
                        }
                    }
                    if ($foundMatch) {
                        $allowedValuesSet = $set
                        break
                    }
                }
            }
        }

        if (!$allowedValuesSet) {
            # Attempting to fix the allowed values
            $found = $false
            $effectParameter = $properties.parameters.effect
            if ($effectParameter.allowedValues) {
                foreach ($set in $allowedValuesSets) {
                    if ($allowedValues -contains $set.hasMember) {
                        $allowedValuesSet = $set
                        $found = $true
                        break
                    }
                }
            }
            if (!$found -and !([string]::IsNullOrEmpty($defaultValue))) {
                foreach ($set in $allowedValuesSets) {
                    if ($defaultValue -eq $set.hasMember) {
                        $allowedValuesSet = $set
                        $found = $true
                        break
                    }
                }
            }
            if ($found) {
                $effectParameter.allowedValues = $allowedValuesSet.allowedValues
                if ($allowedValues) {
                    $null = $warningMessages.Add("Invalid allowedValues $(ConvertTo-Json $allowedValues -Compress); fixed with allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                }
                else {
                    $null = $warningMessages.Add("Missing allowedValues; fixed allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                }
            }
            else {
                if ($allowedValues) {
                    $null = $errorMessages.Add("Invalid allowedValues $(ConvertTo-Json $allowedValues -Compress) and no valid susbstitution found. Consult the CONTRIBUTING.md file for allowed sets.")
                }
                else {
                    $null = $errorMessages.Add("Missing allowedValues and no valid susbstitution found. Consult the CONTRIBUTING.md file for allowed sets.")
                }
            }
        }
        if ($allowedValuesSet) {
            $setDefaultValues = $allowedValuesSet.defaultValues
            if ($defaultValue) {
                if ($setDefaultValues -cnotcontains $defaultValue) {
                    $effectParameter.defaultValue = $allowedValuesSet.defaultValue
                    $null = $warningMessages.Add("Invalid defaultValue $($defaultValue) for effect parameter; fixed defaultValue=$($effectParameter.defaultValue)")
                }
            }
            else {
                $effectParameter.defaultValue = $allowedValuesSet.defaultValue
                $null = $warningMessages.Add("Missing defaultValue for effect parameter; fixed defaultValue=$($effectParameter.defaultValue)")
            }
        }
    }
}

if ($properties.policyType) {
    $null = $warningMessages.Add("policyType ($($properties.policyType)) is not allowed, removing it from the definition.")
    $properties.Remove("policyType")
}

if ($properties.metadata.createdBy) {
    $null = $warningMessages.Add("createdBy ($($properties.metadata.createdBy)) is not allowed, removing it from the definition.")
    $properties.metadata.Remove("createdBy")
}
if ($properties.metadata.createdOn) {
    $null = $warningMessages.Add("createdOn ($($properties.metadata.createdOn)) is not allowed, removing it from the definition.")
    $properties.metadata.Remove("createdOn")
}
if ($properties.metadata.updatedBy) {
    $null = $warningMessages.Add("updatedBy ($($properties.metadata.updatedBy)) is not allowed, removing it from the definition.")
    $properties.metadata.Remove("updatedBy")
}
if ($properties.metadata.updatedOn) {
    $null = $warningMessages.Add("updatedOn ($($properties.metadata.updatedOn)) is not allowed, removing it from the definition.")
    $properties.metadata.Remove("updatedOn")
}

if ($validateOnly) {
    # validate only, no need to write the file
    if ($errorMessages.Count -gt 0) {
        if ($warningMessages.Count -gt 0) {
            $messagesString = ($warningMessages.ToArray()) -join "`n         "
            Write-Warning "Validation detected warnings/fixes for $fileName. `n         $messagesString"
        }
        $messagesString = ($errorMessages.ToArray()) -join "`n           "
        throw "Validation failed for $fileName. `n           $messagesString"
    }
    elseif ($warningMessages.Count -gt 0) {
        $messagesString = ($warningMessages.ToArray()) -join "`n         "
        Write-Warning "Validation failed with warnings/fixes for $fileName. `n         $messagesString"
    }
    else {
        Write-Host "Validation succeeded for $fileName" -ForegroundColor Blue
    }
}
else {
    if ($errorMessages.Count -gt 0) {
        if ($warningMessages.Count -gt 0) {
            $messagesString = ($warningMessages.ToArray()) -join "`n         "
            Write-Warning "Validation detected warnings/fixes for $fileName. `n         $messagesString"
        }
        $messagesString = ($errorMessages.ToArray()) -join "`n           "
        throw "Validation failed for $fileName. `n           $messagesString"
    }
    elseif ($warningMessages.Count -gt 0) {
        $messagesString = ($warningMessages.ToArray()) -join "`n         "
        Write-Warning "Validation succeeded with warnings/fixes for $fileName. `n         $messagesString"
    }
    else {
        Write-Host "Validation succeeded for $fileName" -ForegroundColor Blue
    }

    # create new structure
    $newDefinition = [ordered]@{
        name       = $name
        type       = "Microsoft.Authorization/policyDefinitions"
        properties = [ordered]@{
            displayName = $displayName
            description = $description
            metadata    = $properties.metadata
            # version     = $version
            mode        = $properties.mode
            parameters  = $properties.parameters
            policyRule  = [ordered]@{
                if   = $properties.policyRule.if
                then = $properties.policyRule.then
            }
        }
    }
    $newDefinitionJson = $newDefinition | ConvertTo-Json -Depth 100

    # write new structure
    $folderPath = $file.DirectoryName
    if (!([string]::IsNullOrEmpty($outputDirectory))) {
        $folderPath = $outputDirectory
        #create the directory if it doesn't exist
        if (!(Test-Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath -Force
        }
    }

    $baseName = $file.BaseName
    if ($skipFileSplitting) {
        $fullPath = "$($folderPath)/$($baseName).json"
        $newDefinitionJson | Out-File -FilePath $fullPath -Encoding utf8 -Force
    }
    else {
        $newParameters = $properties.parameters
        $newPolicyRule = $properties.policyRule
        $basePath = "$($folderPath)/$baseName"
        $newDefinitionJson | Out-File -FilePath "$($basePath).json" -Encoding utf8 -Force
        $newParameters | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($basePath).parameters.json" -Encoding utf8 -Force
        $newPolicyRule | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($basePath).rules.json" -Encoding utf8 -Force
    }
}