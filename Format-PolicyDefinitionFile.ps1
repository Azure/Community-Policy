#Requires -PSEdition Core

<#
.SYNOPSIS

Validates and repairs (formats) Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements
Fixes some errors with a warning
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

None. You cannot pipe objects to Format-PolicyDefinitionFile.

.OUTPUTS

None.

.EXAMPLE

Format-PolicyDefinitionFile.ps1 -fileName "<policy-directory>/azurepolicy.json"

.EXAMPLE

Format-PolicyDefinitionFile.ps1 <policy-directory>/azurepolicy.json output-folder -skipFileSplitting

#>

[CmdletBinding()]
param(
    [parameter(Mandatory = $true, Position = 0)] $fileName,
    [parameter(Mandatory = $false, Position = 1)] [string] $outputDirectory = "output",
    [switch] $validateOnly,
    [switch] $skipFileSplitting
)

$errorMessages = [System.Collections.ArrayList]::new()
$warningMessages = [System.Collections.ArrayList]::new()

$files = Get-ChildItem -Path $fileName -ErrorAction SilentlyContinue
if ($files.Count -eq 0) {
    throw "'$fileName' not found."
}
elseif ($files.Count -gt 1) {
    throw "Multiple files ($($files.Count)) found. Instead of '$fileName', specify a file, not a directory or wild card."
}
$file = $files[0]
$content = Get-Content $file.FullName -Raw
if (!(Test-Json $content -ErrorAction SilentlyContinue)) {
    throw "'$($file.FullName)' is not valid JSON."
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
if ($name) {
    if (!([guid]::TryParse($name, $([ref][guid]::Empty)))) {
        $oldName = $name
        $name = (New-Guid).Guid
        if ($oldName.Length -gt 64) {
            if ($validateOnly) {
                $null = $errorMessages.Add("Policy name is too long. Must be 64 characters or less.")
                $null = $errorMessages.Add("Policy name not a GUID. Use generated GUID '$name' as the name.")
            }
            else {
                $null = $warningMessages.Add("Policy name is too long. Must be 64 characters or less.")
                $null = $warningMessages.Add("Policy name not a GUID. Using generated GUID '$name' as the name.")
            }
        }
        else {
            if ($validateOnly) {
                $null = $errorMessages.Add("Policy name '$oldName' not a GUID. Use generated GUID '$name' as the name.")
            }
            else {
                $null = $warningMessages.Add("Policy name '$oldName' not a GUID. Using generated GUID '$name' as the name.")
            }
        }
    }
}
else {
    $name = (New-Guid).Guid
    if ($validateOnly) {
        $null = $errorMessages.Add("Policy name missing, must be a GUID. Use generated GUID '$name' as the name.")
    }
    else {
        $null = $warningMessages.Add("Policy name missing. Using generated GUID '$name' as the name.")
    }
}
if ($oldNname.Length -gt 64) {
    $null = $errorMessages.Add("Policy name is too long. Must be 64 characters or less.")
}

$displayName = $properties.displayName
if (!$displayName) {
    $null = $errorMessages.Add("Policy displayName not found.")
}
elseif ($displayName.Length -gt 128) {
    $null = $errorMessages.Add("Policy displayName is too long. Must be 128 characters or less.")
}

$description = $properties.description
if (!$description) {
    $null = $errorMessages.Add("Policy description not found.")
}
elseif ($description.Length -gt 512) {
    $null = $errorMessages.Add("Policy description is too long. Must be 512 characters or less.")
}

if ($null -eq $properties.metadata) {
    $null = $properties.Add("metadata", @{})
}
$metadata = $properties.metadata

# Temporary until versions available
if (!$metadata.version) {
    $null = $metadata.Add("version", "1.0.0")
    if ($validateOnly) {
        $null = $errorMessages.Add("Policy metadata version not found. Add a metadata version (1.0.0).")
    }
    else {
        $null = $warningMessages.Add("Policy metadata version not found. Defaulting to 1.0.0.")
    }
}
$metadataVersion = $metadata.version

# $version = $properties.version
# if (!$version) {
#     if ($metadata.version) {
#         $version = $metadata.version
#         $null = $warningMessages.Add("version not found. Using version from metadata $($version)")
#     }
#     else {
#         $version = "1.0.0"
#         $null = $warningMessages.Add("version not found. Defaulting to $($version)")
#     }
# }

if (!$metadata.category) {
    $category = $file.Directory.Parent.Name
    if ($validateOnly) {
        $null = $errorMessages.Add("Field category not found in metadata. Add a metadata category ($category).")
    }
    else {
        $null = $warningMessages.Add("Field category not found in metadata. Using parent directory name $category instead.")
    }
    $metadata.Add("Field category", $category)
}

$mode = $properties.mode
if (!$mode) {
    $mode = "All"
    if ($validateOnly) {
        $null = $errorMessages.Add("Policy mode not found. Add a mode (All, Indexed).")
    }
    else {
        $null = $warningMessages.Add("Policy mode not found. Defaulting to $mode.")
    }
}

# analyze effect in then clause
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

$parameters = $properties.parameters
if (!$parameters) {
    $parameters = @{}
    $properties.Add("parameters", $parameters)
}
$effect = $properties.policyRule.then.effect
if (!$effect) {
    $null = $errorMessages.Add("Policy effect not found. Every rule must have an effect.")
}
else {
    if ($effect.StartsWith(("[parameters('")) -and $effect.EndsWith("')]")) {
        $value1 = $effect.Replace("[parameters('", "")
        $parameterName = $value1.Replace("')]", "")
        if ($parameterName -cne "effect") {
            if ($validateOnly) {
                $null = $errorMessages.Add("Policy effect is not correctly parameterized. Change $effect to [parameters('effect')] and rename the parameter to effect.")
            }
            else {
                $null = $warningMessages.Add("Policy effect is not correctly parameterized. Changeing $effect to [parameters('effect')] and renameing the parameter to effect.")
            }
            $effect = "[parameters('effect')]"
            $currentEffectParameter = $parameters.$parameterName
            if (!$currentEffectParameter) {
                $null = $errorMessages.Add("Policy parameter definition '$parameterName' not found.")
            }
            else {
                $parameters.Add("effect", $currentEffectParameter)
                $parameters.Remove($parameterName)
            }
        }
        else {
            if (!$parameters.effect) {
                $null = $errorMessages.Add("Policy parameter definition 'effect' not found.")
            }
        }
    }
    else {
        $defaultValue = $effect
        $effect = "[parameters('effect')]"
        $allowedValuesSet = $null
        foreach ($set in $allowedValuesSets) {
            if ($defaultValue -eq $set.hasMember) {
                $allowedValuesSet = $set
                break
            }
        }
        if ($allowedValuesSet) {
            $allowedValues = $allowedValuesSet.allowedValues
            $defaultValue = $allowedValuesSet.defaultValue
            $parameters.Add("effect", @{
                    type          = "String"
                    metadata      = @{
                        displayName = "Effect"
                        description = "Enable or disable the execution of the policy"
                    }
                    allowedValues = $allowedValues
                    defaultValue  = $defaultValue
                })
            if ($validateOnly) {
                $null = $errorMessages.Add("Policy effect $effect is hard coded. Change $effect to [parameters('effect')] and add the parameter effect.")
            }
            else {
                $null = $warningMessages.Add("Policy effect $effect is hard coded. Changeing $effect to [parameters('effect')] and adding the parameter effect.")
            }
        }
        else {
            $null = $errorMessages.Add("Policy effect $effect is hard coded and value is not recogized as valid. Change $effect to [parameters('effect')] and add the parameter effect.")
        }
    }
    if ($parameters.effect) {
        # orevious check/fixes suceeded; find allowed values set
        $effectParameter = $properties.parameters.effect
        if ($effectParameter.type -cne "String") {
            if ($validateOnly) {
                $null = $errorMessages.Add("Policy parameter effect is not of type String. Change the type to String.")
            }
            else {
                $null = $warningMessages.Add("Policy parameter effect is not of type String. Changeing the type to String.")
            }
        }
        if ($effectParameter.metadata) {
            $effectParameterMetadata = $effectParameter.metadata
            if ($effectParameterMetadata.displayName -ne "Effect") {
                if ($validateOnly) {
                    $null = $errorMessages.Add("Policy parameter effect does not have metadata with displayName Effect. Change the displayName to Effect.")
                }
                else {
                    $null = $warningMessages.Add("Policy parameter effect does not have metadata with displayName Effect. Changeing the displayName to Effect.")
                    $effectParameterMetadata.displayName = "Effect"
                }
            }
            if (!($effectParameterMetadata.description)) {
                if (!$validateOnly) {
                    $null = $warningMessages.Add("Policy parameter effect does not have metadata with description. Adding metadata with description 'Enable or disable the execution of the policy'.")
                    $effectParameterMetadata.description = "Enable or disable the execution of the policy"
                }
            }
        }
        else {
            if ($validateOnly) {
                $null = $errorMessages.Add("Policy parameter effect does not have metadata. Add metadata with the displayName Effect and description 'Enable or disable the execution of the policy'.")
            }
            else {
                $null = $warningMessages.Add("Policy parameter effect does not have metadata. Adding metadata.")
                $effectParameter.metadata = @{
                    displayName = "Effect"
                    description = "Enable or disable the execution of the policy"
                }
            }
        }
        $allowedValues = $effectParameter.allowedValues
        $defaultValue = $effectParameter.defaultValue
        $allowedValuesSet = $null
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
                    if ($validateOnly) {
                        $null = $errorMessages.Add("Invalid allowedValues $(ConvertTo-Json $allowedValues -Compress); use $(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                    }
                    else {
                        $null = $warningMessages.Add("Invalid allowedValues $(ConvertTo-Json $allowedValues -Compress); fixed with allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                    }
                }
                else {
                    if ($validateOnly) {
                        $null = $errorMessages.Add("Missing allowedValues; use $(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                    }
                    else {
                        $null = $warningMessages.Add("Missing allowedValues; fixed allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                    }
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
                    if ($validateOnly) {
                        $null = $errorMessages.Add("Invalid defaultValue $($defaultValue) for effect parameter; use defaultValue=$($effectParameter.defaultValue)")
                    }
                    else {
                        $null = $warningMessages.Add("Invalid defaultValue $($defaultValue) for effect parameter; fixed defaultValue=$($effectParameter.defaultValue)")
                    }
                }
            }
            else {
                $effectParameter.defaultValue = $allowedValuesSet.defaultValue
                if ($validateOnly) {
                    $null = $errorMessages.Add("Missing defaultValue for effect parameter; use defaultValue=$($effectParameter.defaultValue)")
                }
                else {
                    $null = $warningMessages.Add("Missing defaultValue for effect parameter; fixed defaultValue=$($effectParameter.defaultValue)")
                }
            }
        }
    }
}

if ($properties.policyType) {
    if ($validateOnly) {
        $null = $errorMessages.Add("policyType ($($properties.policyType)) is not allowed, remove it from the definition.")
    }
    else {
        $null = $warningMessages.Add("policyType ($($properties.policyType)) is not allowed, removing it from the definition.")
    }
    $properties.Remove("policyType")
}

if ($properties.metadata.createdBy) {
    if ($validateOnly) {
        $null = $errorMessages.Add("createdBy ($($properties.metadata.createdBy)) is not allowed, remove it from the definition.")
    }
    else {
        $null = $warningMessages.Add("createdBy ($($properties.metadata.createdBy)) is not allowed, removing it from the definition.")
    }
    $properties.metadata.Remove("createdBy")
}
if ($properties.metadata.createdOn) {
    if ($validateOnly) {
        $null = $errorMessages.Add("createdOn ($($properties.metadata.createdOn)) is not allowed, remove it from the definition.")
    }
    else {
        $null = $warningMessages.Add("createdOn ($($properties.metadata.createdOn)) is not allowed, removing it from the definition.")
    }
    $properties.metadata.Remove("createdOn")
}
if ($properties.metadata.updatedBy) {
    if ($validateOnly) {
        $null = $errorMessages.Add("updatedBy ($($properties.metadata.updatedBy)) is not allowed, remove it from the definition.")
    }
    else {
        $null = $warningMessages.Add("updatedBy ($($properties.metadata.updatedBy)) is not allowed, removing it from the definition.")
    }
    $properties.metadata.Remove("updatedBy")
}
if ($properties.metadata.updatedOn) {
    if ($validateOnly) {
        $null = $errorMessages.Add("updatedOn ($($properties.metadata.updatedOn)) is not allowed, remove it from the definition.")
    }
    else {
        $null = $warningMessages.Add("updatedOn ($($properties.metadata.updatedOn)) is not allowed, removing it from the definition.")
    }
    $properties.metadata.Remove("updatedOn")
}

if ($validateOnly) {
    # validate only, no need to write the file
    if ($errorMessages.Count -gt 0) {
        $messagesString = ($errorMessages.ToArray()) -join "`n    "
        throw "'$($file.FullName)' failed validation:`n    $messagesString"
    }
    else {
        Write-Host "'$($file.FullName)' is valid." -ForegroundColor Blue
    }
}
else {
    if ($errorMessages.Count -gt 0) {
        $messagesString = "'$($file.FullName)' failed validation:`n    Errors:`n        "
        $messagesString += (($errorMessages.ToArray()) -join "`n        ")
        if ($warningMessages.Count -gt 0) {
            $messagesString += "`n    Warnings and fixes:`n        "
            $messagesString += (($warningMessages.ToArray()) -join "`n        ")
        }
        throw $messagesString
    }
    elseif ($warningMessages.Count -gt 0) {
        $messagesString = "'$($file.FullName)' is valid with warnings and fixes; writing fixed file(s):`n    "
        $messagesString += (($warningMessages.ToArray()) -join "`n    ")
        Write-Host $messagesString -ForegroundColor Yellow
    }
    else {
        Write-Host "'$($file.FullName)' is valid; writing file(s)" -ForegroundColor Blue
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



