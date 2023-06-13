function Validate-PolicyDefinition {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string] $filePath
    )
    
    begin {
        $allowedValuesSets = @{
            'append'            = @{
                defaultValue  = "Append"
                allowedValues = @("Append", "Deny", "Audit", "Disabled")
                description   = "Append, Deny, Audit or Disable the execution of the Policy"
            }
            'audit'             = @{
                defaultValue  = "Audit"
                allowedValues = @("Audit", "Disabled")
                description   = "Audit or Disable the execution of the Policy"
            }
            'deny'              = @{
                defaultValue  = "Deny"
                allowedValues = @("Deny", "Audit", "Disabled")
                description   = "Deny, Audit or Disable the execution of the Policy"
            }
            'modify'            = @{
                defaultValue  = "Modify"
                allowedValues = @("Modify", "Deny", "Audit", "Disabled")
                description   = "Modify, Deny, Audit or Disable the execution of the Policy"
            }
            'deployifnotexists' = @{
                defaultValue  = "DeployIfNotExists"
                allowedValues = @("DeployIfNotExists", "AuditIfNotExists", "Disabled")
                description   = "DeployIfNotExists, AuditIfNotExists or Disable the execution of the Policy"
            }
            'auditifnotexists'  = @{
                defaultValue  = "AuditIfNotExists"
                allowedValues = @("AuditIfNotExists", "Disabled")
                description   = "AuditIfNotExists or Disable the execution of the Policy"
            }
            'denyaction'        = @{
                defaultValue  = "DenyAction"
                allowedValues = @("DenyAction", "Disabled")
                description   = "DenyAction or Disable the execution of the Policy"
            }
            'manual'            = @{
                defaultValue  = "Manual"
                allowedValues = @("Manual", "Disabled")
                description   = "Manual or Disable the execution of the Policy"
            }
        }
    }
    process {
        if (!(Test-Path -Path $filePath)) {
            throw "The filepath '$filepath' is invalid."
        }
        $fileInfo = Get-ChildItem -Path $filePath -File
        $content = Get-Content -Path $filePath -Raw
        if (!(Test-Json $content -ErrorAction SilentlyContinue)) {
            throw "'$($fileInfo.FullName)' is not valid JSON."
        }
        $policyDefinition = $content | ConvertFrom-Json -Depth 100 -AsHashtable
        Write-Verbose "Processing policy '$($fileInfo.Directory.Name)' in '$($fileInfo.Directory.Parent)'"
        if (!$policyDefinition.properties) {
            Write-Verbose "The definition does not contain properties, assuming that the full definition is only wrapping properties."
            $policyDefinition = @{ properties = $policyDefinition }
        }
        switch ($policyDefinition) {
            { !$_.properties['displayName'] } {
                Write-verbose 'Does not include displayName, Setting to directory name.'
                $_.properties.Add('displayName', $($fileinfo.Directory.Name)) | Out-Null
            }
            { !$_.properties['description'] } {
                Write-verbose 'Does not include description, setting to a default value.'
                $_.properties.Add('description', "Policy description.") | Out-Null
            }
            { !$_.properties['mode'] } {
                Write-verbose 'Does not include mode, defaulting to indexed.'
                $_.properties.add('mode', "indexed") | Out-Null
            }
            { !$_.properties['metaData'] } {
                if ($_.properties['metadata']) {
                    Write-verbose "Metadata is named incorrectly, updating to metaData."
                    $currentMetaData = $_.properties['metadata']
                    if ($currentMetaData.keys -contains 'category' -and $currentMetaData.keys -contains 'version') {
                        $_.properties.add('metaData', $($currentMetaData | Select-Object 'version', 'category')) | Out-Null
                    }
                    else {
                        $newMetaData = @{
                            'category' = if ($currentMetaData.Keys -contains 'category') {
                                "$($currentMetaData['category'])"
                            }
                            else {
                                "$($fileinfo.Directory.Parent.name)"
                            }
                            'version'  = if ($currentMetaData.Keys -contains 'version') {
                                "$($currentMetaData['version'])"
                            }
                            else {
                                '1.0.0'
                            }
                        }
                        $_.properties.add('metaData', $newMetaData) | Out-Null
                    }
                    $_.properties.remove('metadata') | Out-Null
                }
                else {
                    Write-verbose "Does not include metaData nor metadata, defaulting to version 1.0.0 and category '$($fileinfo.Directory.Parent.name)'."
                    $_.properties.add('metaData',
                        @{
                            category = "$($fileinfo.Directory.Parent.name)"
                            version  = '1.0.0'
                        }) | Out-Null
                }

            }
            { !$_.properties['parameters'] } {
                throw 'parameters is missing!'
                $_.add('parameters', "indexed") | Out-Null
            }
            { !$_.properties['policyRule'] } {
                if ($_.properties['policyrule']) {
                    $_.properties.add('policyRule', $_.properties['policyrule']) | Out-Null
                }
                else {
                    throw 'policyRule is missing!'
                }
            }
        }
        if ($policyDefinition.properties['parameters'].Keys -notcontains 'effect') {
            Write-verbose "Missing effect in parameters, adding it."
            $currentEffect = $policyDefinition.properties['policyRule']['then']['effect']
            Write-Verbose "Current effect is set to: '$currentEffect', will update the parameter 'effect' accordingly."
            $currentParameters = $policyDefinition.properties['parameters']
            $currentParameters.add('effect', @{
                    "type"          = "string"
                    "metaData"      = @{
                        "displayName" = "Policy effect"
                        "description" = $allowedValuesSets["$($currentEffect.Tolower())"].description
                    }
                    "allowedValues" = $allowedValuesSets["$($currentEffect.Tolower())"].allowedValues
                    "defaultValue"  = $allowedValuesSets["$($currentEffect.Tolower())"].defaultValue
                
                })
        
            # throw '"effect" needs to be part of the parameter set. Please read the guidelines at https://github.com/Azure/Community-Policy/blob/main/CONTRIBUTING.md'
        }
        if ($policyDefinition.properties['policyRule']['then']['effect'] -ne '[parameters(''effect'')]') {
            Write-Verbose "Parameterizing the effect."
            $currentPolicyRuleThen = $policyDefinition.properties['policyRule']['then']
            $policyDefinition.properties['policyRule'].remove('then') | Out-Null
            $currentPolicyRuleThen.remove('effect') | Out-null
            # $currentPolicyRuleThen.add('effect', "[parameters('effect')]")  | Out-null
            $newPolicyRuleThen = @{
                'effect' = "[parameters('effect')]"
            }
            $currentPolicyRuleThen.Keys | Foreach-object {
                $newPolicyRuleThen.Add("$_", $currentPolicyRuleThen["$_"])
            }
            $policyDefinition.properties['policyRule'].add('then', $newPolicyRuleThen) | Out-Null
        }
        if ($policyDefinition.properties['metaData']) {
            if ($policyDefinition.properties['metaData'].Keys.Count -gt 2) {
                Write-verbose "Stripping away unneeded meta data keys"
                $unneededKeys = $policyDefinition.properties['metaData'].Keys | Where-Object { $_ -notin @('version', 'category') }
                $unneededKeys | ForEach-Object {
                    $policyDefinition.properties['metaData'].remove("$_") | Out-Null
                    Write-Verbose "Removed metadata key '$_'"
                }
            }
        }
        $SortedPolicy = @{
            "name"       = $policyDefinition.name
            "type"       = $policyDefinition.type
            "properties" = [ordered]@{
                "displayName" = $policyDefinition.properties['displayName']
                "mode"        = $policyDefinition.properties['mode']
                "description" = $policyDefinition.properties['description']
                "metaData"    = $policyDefinition.properties['metaData']
                "parameters"  = $policyDefinition.properties['parameters']
                "policyRule"  = $policyDefinition.properties['policyRule']
            }
        }
        New-item -Path $filePath -ItemType File -Value $($SortedPolicy | ConvertTo-Json -depth 100) -Force | Out-Null
        Write-Verbose "New Azure Policy restructed at '$filePath'" -Verbose
    }
}

function Fix-PolicyDefinition {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string] $filePath
    )

    if (!(Test-Path -Path $filePath)) {
        throw "$filePath is not a valid file."
    }

    $file = Get-ChildItem -Path $filePath -ErrorAction SilentlyContinue

    $content = Get-Content $file.FullName -Raw

    if (!(Test-Json $content -ErrorAction SilentlyContinue)) {
        throw "'$($file.FullName)' is not valid JSON."
    }
    $definition = ConvertFrom-Json $content -AsHashtable -Depth 100

    if ($definition.Keys -contains 'properties') {
        Write-Verbose "Definition contains properties."
    }
    else {
        Write-verbose 'Definition does not include properties, will verify the json object if it''s a valid policy.'
        try {
            Format-PolicyDefinition -fileName $filePath -category $category -WarningAction 'Stop'
        }
        catch {
            Throw 'Failed check, Fix manually as the Policy is not complete.'
        }
        $definition = @{
            'name'       = { 
                if ($definition.Keys -contains 'name') { $definition['name'] } else { $(new-guid).Guid }
            }
            'properties' = $definition
            'type'       = { 
                if ($definition.Keys -contains 'type') { $definition['type'] } else { "Microsoft.Authorization/policyDefinitions" } 
            }
        }
    }
    # analyze structure
    if (@('name', 'type', 'properties') -notin $definition.Keys) {
        Write-Warning "$filePath does not convene to the proper structure, it only has '$($definition.keys -join ',')'" 
        switch ($definition) {
            { !$_['name'] } {
                Write-verbose 'Does not include name'
                $definition.Add('name', $((new-guid).Guid)) | Out-Null
            }
            { $_['name'] } {
                if (!$_['name'] -eq [guid]) {
                    Write-verbose 'Name is not a GUID, Updating name.'
                    $definition.remove('name') | Out-Null
                    $definition.Add('name', $((new-guid).Guid))  | Out-Null
                }

            }
            { !$_['type'] } {
                Write-verbose 'Does not include type'
                $definition.add('type', "Microsoft.Authorization/policyDefinitions")  | Out-Null
            }
            { $_['type'] } {
                if ($_['type'] -ne "Microsoft.Authorization/policyDefinitions") {
                    Write-verbose "Type is currently '$($_['type'])' changing to 'Microsoft.Authorization/policyDefinitions'"
                    $definition.remove('type') | Out-Null
                    $definition.add('type', "Microsoft.Authorization/policyDefinitions")  | Out-Null
                }

            }
        }
        New-item -Path $filePath -ItemType File -Value $([ordered]@{
            'name' = $definition.name
            'type' = $definition.type
            'properties' = $definition.properties
        } | ConvertTo-Json -depth 100) -Force | Out-Null
        Write-Verbose "New Azure Policy restructed at '$filePath'" -Verbose
    }
}

Get-ChildItem -Path .\Policies -Recurse -File | Where-Object {$_.Name -in @('azurepolicy.json')} | ForEach-Object {
    Fix-PolicyDefinition -filePath $_.FullName
    Validate-PolicyDefinition -filePath $_.FullName
}