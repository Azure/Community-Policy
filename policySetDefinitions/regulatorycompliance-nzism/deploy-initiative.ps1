param (
    [Parameter(
        Mandatory = $true,
        ParameterSetName = "ManagementGroup",
        HelpMessage = "Specify the management group ID."
    )]
    [string]$ManagementGroupId,

    [Parameter(
        Mandatory = $true,
        ParameterSetName = "Subscription",
        HelpMessage = "Specify the subscription ID."
    )]
    [string]$SubscriptionId
)

# Check if both parameters are specified
if ($PSCmdlet.ParameterSetName -eq "ManagementGroup" -and $SubscriptionId) {
    Write-Host "Error: Both management group and subscription cannot be specified. Choose one."
    exit 1
}

if ($PSCmdlet.ParameterSetName -eq "Subscription" -and $ManagementGroup) {
    Write-Host "Error: Both management group and subscription cannot be specified. Choose one."
    exit 1
}

$initname = "nzism-3.6-policyset" 
$initdisplayname = "New Zealand ISM Restricted v3.6" 
$initdescription = "This initiative includes policies that address a subset of New Zealand Information Security Manual v3.6 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/nzism-initiative." 
$initmetadata = "category=Regulatory Compliance","version=1.2-deprecated"
$initdefinitionsfile = 'azurepolicyset.definitions.json'
$initparamsfile = 'azurepolicyset.parameters.json'
$initgroupfile = 'azurepolicyset.groups.json'

#connect to Azure and auth
Connect-AzAccount

# Check the parameter set and run commands accordingly
if ($PSCmdlet.ParameterSetName -eq "ManagementGroup") {
    # Run command for management group
    Write-Host "Running command for management group with ID: $ManagementGroupId"
    az policy set-definition create --name $initname --display-name $initdisplayname --metadata $initmetadata --description $initdescription  --definitions $initdefinitionsfile --params $initparamsfile --definition-groups $initgroupfile --management-group $ManagementGroupId
}
elseif ($PSCmdlet.ParameterSetName -eq "Subscription") {
    # Run command for subscription
    Write-Host "Running command for subscription with ID: $SubscriptionId"
    az policy set-definition create --name $initname --display-name $initdisplayname --metadata $initmetadata --description $initdescription  --definitions $initdefinitionsfile --params $initparamsfile --definition-groups $initgroupfile --subscription $SubscriptionId
}
else {
    Write-Host "Error: Invalid parameter set."
}