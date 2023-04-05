#Requires -PSEdition Core

param(
    [parameter(Mandatory = $true, Position = 0)] $folderPath,
    [switch] $validateOnly,
    [switch] $generateReadme
)

$ErrorActionPreference = "Stop"
if ($validateOnly) {
    $WarningPreference = "Stop"
}

$files = Get-ChildItem -Path $folderPath -Filter "azurepolicy.json"
$file = $files[0]
$content = Get-Content $file.FullName -Raw

# if (!(Test-Json $content -SchemaFile "$($PSScriptRoot)/azurepolicy.schema.json")) {
#     Write-Error "Invalid JSON in file $($file.FullName)"
# }
$definition = ConvertFrom-Json $content -AsHashtable -Depth 100

# analyze structure
$name = ""
$displayName = ""
$properties = $null

if ($definition.name) {
    $isNameGuid = [guid]::TryParse($name, [out] $null)
    if ($isNameGuid) {
        $name = $definition.name
    }
    else {
        $guid = New-Guid
        $name = $guid.ToString()
        Write-Warning "name is not a GUID. Changing to $name"
    }
}
else {
    $guid = New-Guid
    $name = $guid.ToString()
    Write-Warning "name not found. Generating GUID $name"
}
if ($definition.properties) {
    $properties = $definition.properties
}
else {
    $properties = $definition
}
if ($properties.displayName) {
    $displayName = $properties.displayName
}
else {
    Write-Error "displayName not found."
}

$description = $properties.description
if (!$description) {
    Write-Error "description not found."
}

$version = $properties.version
if (!$version) {
    if ($properties.metadata.version) {
        $version = $properties.metadata.version
    }
    else {
        $version = "1.0.0"
    }
    Write-Warning "version not found. Using version $($version)"
}

$mode = $properties.mode
if (!$mode) {
    Write-Error "mode not found."
}

$category = $properties.metadata.category
if (!$category) {
    Write-Error "category not found in metadata."
}

# analyze effect in then clause
$effect = $properties.policyRule.then.effect
if (!$effect) {
    Write-Error "effect not found."
}

if ($effect -cne "[parameters('effect')]") {
    Write-Error "effect is not a parameterized. Change $effect to [parameters('effect')]"
}

if (!$properties.parameters.effect) {
    Write-Error "effect parameter definition not found."
}

$effectParameter = $properties.parameters.effect
if (!$effectParameter.allowedValues) {
    Write-Error "effect parameter allowed values not found."
}

if (!$effectParameter.defaultValue) {
    Write-Error "effect parameter defaultValue not found."
}

if (!$effectParameter.metadata.displayName) {
    Write-Error "effect parameter displayName not found in metadata."
}

$allowedValues = $effectParameter.allowedValues
$defaultValue = $effectParameter.defaultValue
$allowedValuesSets = @(
    @{
        allowedValues = @("Append", "Deny", "Audit", "Disabled")
        defaultValues = @("Append", "Audit")
    },
    @{
        allowedValues = @("Append", "Audit", "Disabled")
        defaultValues = @("Append", "Audit")
    },
    @{
        allowedValues = @("Modify", "Deny", "Audit", "Disabled")
        defaultValues = @("Modify", "Audit")
    },
    @{
        allowedValues = @("Modify", "Audit", "Disabled")
        defaultValues = @("Modify", "Audit")
    },
    @{
        allowedValues = @("Deny", "Audit", "Disabled")
        defaultValues = @("Audit")
    },
    @{
        allowedValues = @("Audit", "Disabled")
        defaultValues = @("Audit")
    },
    @{
        allowedValues = @("DeployIfNotExists", "AuditIfNotExists", "Disabled")
        defaultValues = @("DeployIfNotExists", "AuditIfNotExists")
    },
    @{
        allowedValues = @("AuditIfNotExists", "Disabled")
        defaultValues = @("AuditIfNotExists")
    },
    @{
        allowedValues = @("DenyAction", "Disabled")
        defaultValues = @("DenyAction")
    },
    @{
        allowedValues = @("Manual", "Disabled")
        defaultValues = @("Manual")
    }
)

# find allowed values set
$allowedValuesSet = $null
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
if (!$allowedValuesSet) {
    Write-Error "Invalid allowedValues combination. Consult the CONTRIBUTING.md file for allowed sets."
}
$allowedDefaultValues = $allowedValuesSet.defaultValues
if (!$allowedDefaultValues -ccontains $defaultValue) {
    Write-Error "Invalid defaultValue. Consult the CONTRIBUTING.md file for allowed values for defaultValue."
}

if ($definition.type) {
    Write-Warning "type ($($definition.type)) is not allowed, removing it from the definition."
    $definition.Remove("type")
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
    properties = [ordered]@{
        displayName = $displayName
        description = $description
        metadata    = $properties.metadata
        mode        = $properties.mode
        parameters  = $properties.parameters
        policyRule  = [ordered]@{
            if   = $properties.policyRule.if
            then = $properties.policyRule.then
        }
    }
}

$newParameters = $properties.parameters
$newPolicyRule = $properties.policyRule

# write new structure
$newDefinition | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($folderPath)/azurepolicy.json" -Encoding utf8 -Force
$newParameters | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($folderPath)/azurepolicy.parameters.json" -Encoding utf8 -Force
$newPolicyRule | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($folderPath)/azurepolicy.rules.json" -Encoding utf8 -Force

if ($generateReadme) {
    # maybe implement this later
}
