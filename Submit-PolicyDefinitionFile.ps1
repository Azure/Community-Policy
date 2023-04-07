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

.PARAMETER skipFileSplitting
Switch parameter to skip creating the <filename>.parameters.json and <filename>.rules.json files. Optional.

.INPUTS

None. You cannot pipe objects to Submit-PolicyDefinitionFile.

.OUTPUTS

None.

.EXAMPLE

Submit-PolicyDefinitionFile.ps1 -fileName "azurepolicy.json"

.EXAMPLE

Submit-PolicyDefinitionFile.ps1 azurepolicy.json output-folder -skipFileSplitting

#>

param(
    [parameter(Mandatory = $true, Position = 0)] $fileName,
    [parameter(Mandatory = $false, Position = 1)] [string] $outputDirectory = $null,
    [switch] $skipFileSplitting
)

$ErrorActionPreference = "Stop"

$files = Get-ChildItem -Path $fileName
if ($files.Count -eq 0) {
    Write-Error "File not found: $fileName."
}
elseif ($files.Count -gt 1) {
    Write-Error "Multiple files found: $fileName. Specify a file, not a directory"
}
$file = $files[0]
$content = Get-Content $file.FullName -Raw
if (!(Test-Json $content)) {
    Write-Error "File is not valid JSON: $fileName."
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
        Write-Warning "name $oldName not a GUID. Using generated GUID $name as the name"
    }
}
else {
    $name = (New-Guid).Guid
    Write-Warning "name missing. Using generated GUID $name as the name"
}

$displayName = $properties.displayName
if (!$displayName) {
    Write-Error "displayName not found."
}
$description = $properties.description
if (!$description) {
    Write-Error "description not found."
}


# Temporary until versions available
$metadataVersion = "1.0.0"
$metadata = $properties.metadata
if ($metadata) {
    $metadataVersion = $metadata.version
    if (!$metadata.version) {
        $null = $metadata.Add("version", $metadataVersion)
        Write-Warning "metadata version not found. Defaulting to $($metadataVersion)"
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
    Write-Warning "metadata version not found. Defaulting to $($metadataVersion)"
}

# $version = $properties.version
# if (!$version) {
#     if ($properties.metadata.version) {
#         $version = $properties.metadata.version
#         Write-Warning "version not found. Using version from metadata $($version)"
#     }
#     else {
#         $version = "1.0.0"
#         Write-Warning "version not found. Defaulting to $($version)"
#     }
# }


$mode = $properties.mode
if (!$mode) {
    Write-Error "mode not found."
}

$category = $properties.metadata.category
if (!$category) {
    $category = $file.Directory.Parent.Name
    Write-Warning "category not found in metadata. Using parent directory name $category instead."
    if (!$properties.metadata) {
        $properties.Add("metadata", @{
                category = $category
            }
        )
    }
    else {
        $properties.metadata.Add("category", $category)
    }
}

# analyze effect in then clause
$effect = $properties.policyRule.then.effect
if (!$effect) {
    Write-Error "effect not found."
}

if ($effect -cne "[parameters('effect')]") {
    Write-Error "effect is not a parameterized. Change $effect to [parameters('effect')] and add a parameter definition for effect."
}

if (!$properties.parameters.effect) {
    Write-Error "effect parameter definition not found."
}

$allowedValues = $effectParameter.allowedValues
$defaultValue = $effectParameter.defaultValue
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

if ($allowedValuesSet) {
    # Check if the default value is valid
    $setDefaultValues = $allowedValuesSet.defaultValues
    if (!($setDefaultValues -ccontains $defaultValue)) {
        $effectParameter.defaultValue = $allowedValuesSet.defaultValue
        Write-Warning "Invalid or missing defaultValue $($defaultValue) for allowedValues $(ConvertTo-Json $allowedValues -Compress); fixed defaultValue=$(ConvertTo-Json $effectParameter.defaultValue)"
    }
}
else {
    # Attempting to fix the allowed values
    $found = $false
    $effectParameter = $properties.parameters.effect
    if ($effectParameter.allowedValues) {
        foreach ($set in $allowedValuesSets) {
            if ($allowedValues -contains $set.hasMember) {
                $setAllowedValues = $set.allowedValues
                $setDefaultValues = $set.defaultValues
                if (!($defaultValue -and $setDefaultValues -ccontains $defaultValue)) {
                    $effectParameter.defaultValue = $set.defaultValue
                }
                $effectParameter.allowedValues = $setAllowedValues
                $found = $true
                break
            }
        }
    }
    if ($found) {
        Write-Warning "Invalid or missing allowedValues; fixed allowedValues=$(ConvertTo-Json $effectParameter.allowedValues -Compress) defaultValue=$(ConvertTo-Json $effectParameter.defaultValue)"
    }
    else {
        # should never happen, unless a new effect value has been introduced by Azure Policy
        Write-Error "Invalid or missing allowedValues $(ConvertTo-Json $effectParameter.allowedValues -Compress). Consult the CONTRIBUTING.md file for allowed sets."
    }
}

if ($properties.policyType) {
    Write-Warning "policyType ($($properties.policyType)) is not allowed, removing it from the definition."
    $properties.Remove("policyType")
}

if ($properties.metadata.createdBy) {
    Write-Warning "createdBy ($($properties.metadata.createdBy)) is not allowed, removing it from the definition."
    $properties.metadata.Remove("createdBy")
}
if ($properties.metadata.createdOn) {
    Write-Warning "createdOn ($($properties.metadata.createdOn)) is not allowed, removing it from the definition."
    $properties.metadata.Remove("createdOn")
}
if ($properties.metadata.updatedBy) {
    Write-Warning "updatedBy ($($properties.metadata.updatedBy)) is not allowed, removing it from the definition."
    $properties.metadata.Remove("updatedBy")
}
if ($properties.metadata.updatedOn) {
    Write-Warning "updatedOn ($($properties.metadata.updatedOn)) is not allowed, removing it from the definition."
    $properties.metadata.Remove("updatedOn")
}

if ($validateOnly) {
    Write-Host "Validation successful."
    return
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
