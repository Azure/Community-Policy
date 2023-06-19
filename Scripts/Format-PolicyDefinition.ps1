<#
.SYNOPSIS

Validates and repairs (formats) Azure Policy definitions.

.DESCRIPTION

Ingests complete Policy definition file
Checks required elements
Fixes some errors with a warning
Splits the file into the required three files

.PARAMETER content
Content of the Policy definition.

.PARAMETER category
Category of the Policy definition, if metadat does not conatin a valid category. Default is empty indicating to fail validation if metadata category no valid.

.EXAMPLE
$definition = Format-PolicyDefinition -content $content -category "Compute"

#>
function Format-PolicyDefinition {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [string] $content,

        [parameter(Mandatory = $false)]
        [string] $alternateDisplayName = "",

        [parameter(Mandatory = $false)]
        [string] $category = ""
    )
    
    begin {
        $allowedCategories = @(
            "API for FHIR",
            "API Management",
            "App Configuration",
            "App Platform",
            "App Service",
            "Attestation",
            "Authorization",
            "Automanage",
            "Automation",
            "Azure Active Directory",
            "Azure Arc",
            "Azure Data Explorer",
            "Azure Databricks",
            "Azure Edge Hardware Center",
            "Azure Load Testing",
            "Azure Purview",
            "Azure Stack Edge",
            "Backup",
            "Batch",
            "Bot Service",
            "Cache",
            "CDN",
            "ChangeTrackingAndInventory",
            "Cognitive Services",
            "Compute",
            "Container Apps",
            "Container Instance",
            "Container Instances",
            "Container Registry",
            "Cosmos DB",
            "Cost Optimization",
            "Custom Provider",
            "Data Box",
            "Data Factory",
            "Data Lake",
            "Dev Test Labs",
            "Desktop Virtualization",
            "Event Grid",
            "Event Hub",
            "Fluid Relay",
            "General",
            "Guest Configuration",
            "HDInsight",
            "Health Bot",
            "Health Data Services workspace",
            "Healthcare APIs",
            "Internet of Things",
            "Key Vault",
            "Kubernetes",
            "Lab Services",
            "Lighthouse",
            "Logic Apps",
            "Machine Learning",
            "Managed Application",
            "Managed Grafana",
            "Managed Identity",
            "Maps",
            "Media Services",
            "Migrate",
            "Monitoring",
            "Network",
            "Policy",
            "Portal",
            "Regulatory Compliance",
            "SDN",
            "Search",
            "Security Center",
            "Service Bus",
            "Service Fabric",
            "SignalR",
            "Site Recovery",
            "SQL",
            "SQL Server",
            "Storage",
            "Stream Analytics",
            "Synapse",
            "Tags",
            "Trusted Launch",
            "Update Management Center",
            "Video Analyzers",
            "VM Image Builder",
            "Web PubSub"
        )
        
        $allowedValuesSets = @(
            @{
                hasMember     = "Append"
                defaultValue  = "Append"
                allowedValues = @("Append", "Deny", "Audit", "Disabled")
                defaultValues = @("Append", "Audit")
                description   = "Append, Deny, Audit or Disable the execution of the Policy"
            },
            @{
                hasMember     = "Modify"
                defaultValue  = "Modify"
                allowedValues = @("Modify", "Deny", "Audit", "Disabled")
                defaultValues = @("Modify", "Audit")
                description   = "Modify, Deny, Audit or Disabled the execution of the Policy"
            },
            @{
                hasMember     = "Deny"
                defaultValue  = "Audit"
                allowedValues = @("Deny", "Audit", "Disabled")
                defaultValues = @("Audit")
                description   = "Deny, Audit or Disabled the execution of the Policy"
            },
            @{
                hasMember     = "Audit"
                defaultValue  = "Audit"
                allowedValues = @("Audit", "Disabled")
                defaultValues = @("Audit")
                description   = "Audit or Disabled the execution of the Policy"
            },
            @{
                hasMember     = "DeployIfNotExists"
                defaultValue  = "DeployIfNotExists"
                allowedValues = @("DeployIfNotExists", "AuditIfNotExists", "Disabled")
                defaultValues = @("DeployIfNotExists", "AuditIfNotExists")
                description   = "DeployIfNotExists, AuditIfNotExists or Disabled the execution of the Policy"
            },
            @{
                hasMember     = "AuditIfNotExists"
                defaultValue  = "AuditIfNotExists"
                allowedValues = @("AuditIfNotExists", "Disabled")
                defaultValues = @("AuditIfNotExists")
                description   = "AuditIfNotExists or Disabled the execution of the Policy"
            },
            @{
                hasMember     = "DenyAction"
                defaultValue  = "DenyAction"
                allowedValues = @("DenyAction", "Disabled")
                defaultValues = @("DenyAction")
                description   = "DenyAction or Disabled the execution of the Policy"
            },
            @{
                hasMember     = "Manual"
                defaultValue  = "Manual"
                allowedValues = @("Manual", "Disabled")
                defaultValues = @("Manual")
                description   = "Manual or Disabled the execution of the Policy"
            }
        )

        [char[]] $invalidChars = [IO.Path]::GetInvalidFileNameChars()
        $invalidChars += ("[]()$ /\".ToCharArray())
    }
    
    process {
        
        $errorMessages = [System.Collections.ArrayList]::new()
        $warningMessages = [System.Collections.ArrayList]::new()

        if (!(Test-Json $content -ErrorAction SilentlyContinue)) {
            throw "'$($file.FullName)' is not valid JSON."
        }
        $definition = ConvertFrom-Json $content -AsHashtable -Depth 100

        #region fix tolerate flat or nested properties structure, wrong capiatalization of property members

        $properties = $definition
        if ($definition.properties) {
            $properties = $definition.properties
        }
        elseif ($definition.Properties) {
            $properties = $definition.Properties
        }

        $name = $properties.name
        if (!$name) {
            $name = $properties.Name
        }
        
        $displayName = $properties.displayName
        if (!$displayName) {
            $displayName = $properties.DisplayName
        }

        $description = $properties.description
        if (!$description) {
            $description = $properties.Description
        }

        $metadata = $properties.metadata
        if (!$metadata) {
            $metadata = $properties.Metadata
            if (!$metadata) {
                $metadata = @{}
            }
        }

        $mode = $properties.mode
        if (!$mode) {
            $mode = $properties.Mode
        }

        $parameters = $properties.parameters
        if (!$parameters) {
            $parameters = $properties.Parameters
            if (!$parameters) {
                $parameters = @{}
            }
        }

        $policyRule = $properties.policyRule
        if (!$policyRule) {
            $policyRule = $properties.PolicyRule
        }

        #endregion

        # region check that it is a Policy definition , ignore file if it is not, uses primitive heuristic

        $notPolicyDefinition = $true
        $if = $null
        $then = $null
        $effect = $null
        if ($policyRule) {
            $then = $policyRule.then
            if ($then) {
                $effect = $then.effect
            }
            $if = $policyRule.if
            $notPolicyDefinition = $null -eq $if -or $null -eq $effect
        }
        if ($notPolicyDefinition) {
            $messagesString = "'$($file.FullName)' is not a Policy definition."
            $null = $errorMessages.Add($messagesString)
            return $null, $warningMessages, $errorMessages, $null
        }

        #endregion

        #region naming

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
        $isGuid = $false
        if ($name) {
            $guid = [guid]::Empty
            $isGuid = [guid]::TryParse($name, $([ref]$guid))
        }
        $nonGuidName = $null
        if (!$isGuid) {
            $nonGuidName = $name
        }
        if (!$displayName) {
            if ($nonGuidName -and $alternateDisplayName -ne "") {
                $displayName = $nonGuidName
                $null = $warningMessages.Add("Policy displayName not found. Using name '$displayName' as the displayName.")
            }
            elseif ($alternateDisplayName -ne "") {
                $displayName = $alternateDisplayName
                $null = $warningMessages.Add("Policy displayName not found. Using alternateDisplayName '$displayName' as the displayName.")
            }
            else {
                $null = $errorMessages.Add("Policy displayName not found.")
            }
        }
        elseif ($displayName.Length -gt 128) {
            $null = $warningMessages.Add("Policy displayName is too long. Must be 128 characters or less; truncating displayName.")
            $displayName = $displayName.Substring(0, 128)
        }
        if (!$description) {
            if ($alternateDisplayName -eq "") {
                $null = $errorMessages.Add("Policy description not found.")
            }
            else {
                $description = "need to add description"
                $null = $warningMessages.Add("Policy description not found. Using '$description' as the description.")
            }
        }
        elseif ($description.Length -gt 512) {
            $null = $warningMessages.Add("Policy description is too long. Must be 512 characters or less; truncating description")
            $description = $description.Substring(0, 512)
        }
        if (!$isGuid) {
            $name = (New-Guid).Guid
            $null = $warningMessages.Add("Policy name missing or not a GUID. Fix using generated GUID '$name' as the name.")
        }

        #endregion

        #region metadata

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

        if ($metadata.category) {
            if ($allowedCategories -ccontains $metadata.category) {
                $category = $metadata.category
            }
            elseif ($category.Length -gt 0) {
                if ($allowedCategories -ccontains $category) {
                    $metadata.category = $category
                    $null = $warningMessages.Add("Category '$($metadata.category)' is not in allowed list. Using category parameter $category instead.")
                }
                else {
                    $null = $errorMessages.Add("Metadata category '$($metadata.category)' and category parameter $($category) are not in allowed list.")
                }
            }
            else {
                $null = $errorMessages.Add("Metadata category '$($metadata.category)' is not in allowed list and category parameter is empty.")
            }
        }
        elseif ($category.Length -gt 0) {
            if ($allowedCategories -ccontains $category) {
                $null = $warningMessages.Add("Metadata category is not supplied. Using category parameter $category instead.")
                $metadata.category = $category
            }
            else {
                $null = $errorMessages.Add("Metadata category is not supplied and category parameter $($category) is not in allowed list.")
            }
        }
        else {
            $null = $errorMessages.Add("Metadata category is not supplied and category parameter is empty.")
        }

        #endregion

        if (!$mode) {
            $mode = "All"
            $null = $warningMessages.Add("Policy mode not found. Fix using 'All'.")
        }

        #region effect paramteter

        $defaultValue = $null
        $allowedValues = $null
        $allowedValuesSet = $null
        if ($effect.StartsWith(("[parameters('")) -and $effect.EndsWith("')]")) {
            # parameterized effect
            $value1 = $effect.Replace("[parameters('", "")
            $parameterName = $value1.Replace("')]", "")
            $effectParameter = $parameters.$parameterName
            $allowedValues = $effectParameter.allowedValues
            $defaultValue = $effectParameter.defaultValue

            if ($parameterName -cne "effect") {
                $null = $warningMessages.Add("Policy effect parameter name must be effect. Autofix available.")
            }
            if (!$defaultValue) {
                $null = $warningMessages.Add("Policy effect parameter default value not found. Autofix available.")
            }
            if (!$allowedValues) {
                $null = $warningMessages.Add("Policy effect parameter allowed values not found. Autofix available.")
            }
            if ($effectParameter.type -ne "String") {
                $null = $warningMessages.Add("Policy effect parameter type must be String. Autofix available.")
            }
            if ($effectParameter.metadata.displayName -ne "Effect") {
                $null = $warningMessages.Add("Policy effect parameter displayName must be Effect. Autofix available.")
            }
            if ($null -eq $effectParameter.metadata.description) {
                $null = $warningMessages.Add("Policy effect parameter description must be set. Autofix available.")
            }

            $parameters.Remove($parameterName)
        }
        else {
            # hard coded effect
            $defaultValue = $effect
            $null = $warningMessages.Add("Policy effect is hard coded. Autofix available.")
        }

        # find allowed values set
        if (!$allowedValues -and $defaultValue) {
            # find allowed values set by default value
            foreach ($set in $allowedValuesSets) {
                if ($defaultValue -eq $set.hasMember) {
                    $allowedValuesSet = $set
                    break
                }
            }
        }
        elseif ($allowedValues) {
            # find allowed values set by allowed values
            foreach ($set in $allowedValuesSets) {
                foreach ($allowedValue in $allowedValues) {
                    if ($set.hasMember -eq $allowedValue) {
                        $allowedValuesSet = $set
                        break
                    }
                }
                if ($allowedValuesSet) {
                    break
                }
            }
        }

        # create effect parameter
        if ($allowedValuesSet) {
            $newEffect = [ordered]@{
                type          = "String"
                metadata      = [ordered]@{
                    displayName = "Effect"
                    description = $allowedValuesSet.description
                }
                allowedValues = $allowedValuesSet.allowedValues
                defaultValue  = $allowedValuesSet.defaultValue
            }
            $parameters["effect"] = $newEffect
            $then["effect"] = "[parameters('effect')]"
        }
        else {
            $null = $errorMessages.Add("Policy effect parameter does not specify a valid allowedValues or a valid defaultValue; therefore the values cannot be inferred.")
        }

        #endregion

        #region remove invalid elements
        
        if ($properties.policyType -or $properties.PolicyType) {
            $null = $warningMessages.Add("policyType ($($properties.policyType)) is not allowed, fix by removing it from the definition.")
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

        #endregion

        #region create new structure

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
                    if   = $if
                    then = $then
                }
            }
        }

        #endregion

        #region create new directory name

        $pathTemp = $name
        if (!([string]::IsNullOrEmpty($displayName))) {
            $pathTemp = $displayName.Trim()
            $pathTemp = $pathTemp.ToLower()
            $pathSplits = $pathTemp.Split($invalidChars, [System.StringSplitOptions]::RemoveEmptyEntries)
            $pathTemp = $pathSplits -join "-"
            $previousPath = ""
            while ($previousPath -ne $pathTemp) {
                # remove multiple --
                $previousPath = $pathTemp
                $pathTemp = $pathTemp -replace "--", "-"
            }
            $pathTemp = $pathTemp.Trim("-")
        }

        #endregion

        return $newDefinition, $warningMessages, $errorMessages, "$category/$pathTemp"
    }

    
    end {
        
    }
}