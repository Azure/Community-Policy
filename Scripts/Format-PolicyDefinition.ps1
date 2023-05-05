<#
.SYNOPSIS

Validates and repairs (formats) Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements
Fixes some errors with a warning
Splits the file into the required three files

.PARAMETER fileName
Input file name. Default is azurepolicy.json.

.PARAMETER category
Category of the Policy definition. Default is empty indicating to preserve the existing category in metadata.

.PARAMETER validateOnly
Validates the Policy definition without writing re-formatted Policy to the output.

.EXAMPLE
Format-PolicyDefinition -fileName azurepolicy.json -category "Custom"

.EXAMPLE
Format-PolicyDefinition -fileName azurepolicy.json -validateOnly

#>

function Format-PolicyDefinition {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [string] $fileName,

        [parameter(Mandatory = $false)]
        [string] $category = "",

        [parameter(Mandatory = $false)]
        [switch] $validateOnly
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

    # check that it is aPolicy, ignore file if it is not, uses primitive heuristic
    if (!($definition.type -eq "Microsoft.Authorization/policyDefinitions" -or $properties.policyRule)) {
        $messagesString = "'$($file.FullName)' is not a Policy definition. Ignoring."
        Write-Host $messagesString -ForegroundColor Yellow
        return $null
    }
    else {
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
            $guid = [guid]::Empty
            $isGuid = [guid]::TryParse($name, $([ref]$guid))
            if (!$isGuid) {
                $oldName = $name
                $name = (New-Guid).Guid
                if ($oldName.Length -gt 64) {
                    $null = $warningMessages.Add("Policy name is too long. Must be 64 characters or less.")
                    $null = $warningMessages.Add("Policy name not a GUID. Fix using generated GUID '$name' as the name.")
                }
                else {
                    $null = $warningMessages.Add("Policy name '$oldName' not a GUID. Fix using generated GUID '$name' as the name.")
                }
            }
        }
        else {
            $name = (New-Guid).Guid
            $null = $warningMessages.Add("Policy name missing, must be a GUID. Fix using generated GUID '$name' as the name.")
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

        $metadata = @{}
        if ($properties.metadata) {
            $metadata = $properties.metadata
        }

        # Temporary until versions available
        if (!$metadata.version) {
            $metadata.version = "1.0.0"
            $null = $warningMessages.Add("Policy metadata version not found. Fix using 1.0.0.")
        }

        # $metadataVersion = $metadata.version
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
            if ($category.Length -gt 0) {
                $null = $warningMessages.Add("Field category not found in metadata. Fix using parameter category $category instead.")
            }
            else {
                $null = $errorMessages.Add("Field category not found in metadata.")
            }
            $metadata.category = $category
        }

        $mode = $properties.mode
        if (!$mode) {
            $mode = "All"
            $null = $warningMessages.Add("Policy mode not found. Fix using 'All'.")
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

        $parameters = @{}
        if ($properties.parameters) {
            $parameters = $properties.parameters
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
                    $null = $warningMessages.Add("Policy effect is not correctly parameterized. Fix by changeing '$effect' to [parameters('effect')] and renameing the parameter to effect.")
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
                    $null = $warningMessages.Add("Policy effect $effect is hard coded. Fix by changeing $effect to [parameters('effect')] and adding the parameter effect.")
                }
                else {
                    $null = $errorMessages.Add("Policy effect $effect is hard coded and value is not recogized as valid. Change $effect to [parameters('effect')] and add the parameter effect.")
                }
            }

            if ($parameters.effect) {
                # orevious check/fixes suceeded; find allowed values set
                $effectParameter = $properties.parameters.effect
                if ($effectParameter.type -cne "String") {
                    $null = $warningMessages.Add("Policy parameter effect is not of type String. Fix by changeing the type to String.")
                }
                if ($effectParameter.metadata) {
                    $effectParameterMetadata = $effectParameter.metadata
                    if ($effectParameterMetadata.displayName -ne "Effect") {
                        $null = $warningMessages.Add("Policy parameter effect does not have metadata with displayName Effect. Fix by changeing the displayName to Effect.")
                        $effectParameterMetadata.displayName = "Effect"
                    }
                    if (!($effectParameterMetadata.description)) {
                        $null = $warningMessages.Add("Policy parameter effect does not have metadata with description. Fix by adding metadata with description 'Enable or disable the execution of the policy'.")
                        $effectParameterMetadata.description = "Enable or disable the execution of the policy"
                    }
                }
                else {
                    $null = $warningMessages.Add("Policy parameter effect does not have metadata. Fix by adding metadata.")
                    $effectParameter.metadata = @{
                        displayName = "Effect"
                        description = "Enable or disable the execution of the policy"
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
                            $null = $warningMessages.Add("Invalid allowedValues $(ConvertTo-Json $allowedValues -Compress); fix with allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress)")
                        }
                        else {
                            $null = $warningMessages.Add("Missing allowedValues; fix with allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress)")
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
                            $null = $warningMessages.Add("Invalid defaultValue $($defaultValue) for effect parameter; fix with defaultValue=$($effectParameter.defaultValue)")
                        }
                    }
                    else {
                        $effectParameter.defaultValue = $allowedValuesSet.defaultValue
                        $null = $warningMessages.Add("Missing defaultValue for effect parameter; fix with defaultValue=$($effectParameter.defaultValue)")
                    }
                }
            }
        }

        if ($properties.policyType) {
            $null = $warningMessages.Add("policyType ($($properties.policyType)) is not allowed, fix by removing it from the definition.")
            $properties.Remove("policyType")
        }
        if ($metadata.createdBy) {
            $null = $warningMessages.Add("createdBy ($($metadata.createdBy)) is not allowed, fix by removing it from the definition.")
            $metadata.Remove("createdBy")
        }
        if ($metadata.createdOn) {
            $null = $warningMessages.Add("createdOn ($($metadata.createdOn)) is not allowed, fix by removing it from the definition.")
            $metadata.Remove("createdOn")
        }
        if ($metadata.updatedBy) {
            $null = $warningMessages.Add("updatedBy ($($metadata.updatedBy)) is not allowed, fix by removing it from the definition.")
            $metadata.Remove("updatedBy")
        }
        if ($metadata.updatedOn) {
            $null = $warningMessages.Add("updatedOn ($($metadata.updatedOn)) is not allowed, fix by removing it from the definition.")
            $metadata.Remove("updatedOn")
        }

        if ($validateOnly) {
            # validate only, no need to write the file
            if ($errorMessages.Count -gt 0 -or $warningMessages.Count -gt 0) {
                $messagesString = "'$($file.FullName)' failed validation:"
                if ($errorMessages.Count -gt 0) {
                    $messagesString += "`n    Hard errors:`n        "
                    $messagesString += (($errorMessages.ToArray()) -join "`n        ")
                }
                if ($warningMessages.Count -gt 0) {
                    $messagesString += "`n    Auto-fixes available:`n        "
                    $messagesString += (($warningMessages.ToArray()) -join "`n        ")
                }
                throw $messagesString
            }
            else {
                Write-Host "'$($file.FullName)' is valid." -ForegroundColor Blue
            }
            return $null
        }
        else {
            if ($errorMessages.Count -gt 0) {
                $messagesString = "'$($file.FullName)' failed validation:"
                $messagesString += "`n    Hard errors:`n        "
                $messagesString += (($errorMessages.ToArray()) -join "`n        ")
                if ($warningMessages.Count -gt 0) {
                    $messagesString += "`n    Auto-fixes available:`n        "
                    $messagesString += (($warningMessages.ToArray()) -join "`n        ")
                }
                throw $messagesString
            }
            elseif ($warningMessages.Count -gt 0) {
                $messagesString = "'$($file.FullName)' has auto-fix warnings:`n    "
                $messagesString += (($warningMessages.ToArray()) -join "`n    ")
                Write-Host $messagesString -ForegroundColor Yellow
            }
            else {
                Write-Host "'$($file.FullName)' is valid." -ForegroundColor Blue
            }

            # create new structure
            $newDefinition = [ordered]@{
                name       = $name
                type       = "Microsoft.Authorization/policyDefinitions"
                properties = [ordered]@{
                    displayName = $displayName
                    description = $description
                    metadata    = $metadata
                    # version     = $version
                    mode        = $mode
                    parameters  = $parameters
                    policyRule  = [ordered]@{
                        if   = $properties.policyRule.if
                        then = $properties.policyRule.then
                    }
                }
            }
            return $newDefinition
        }
    }
}