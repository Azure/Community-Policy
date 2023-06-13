$policies = Get-ChildItem -Directory -LiteralPath .\Policies
$allowedPolicyFiles = @('azurepolicy.json', 'azurepolicy.parameters.json', 'azurepolicy.rules.json')

$policies | ForEach-Object {
    $category = $_.Name
    $childDirectories = Get-ChildItem -LiteralPath $_.FullName -Directory
    $childDirectories | ForEach-Object {
        $policyFiles = Get-ChildItem -Path $_.FullName -File | where-object {$_.Name -in $allowedPolicyFiles}
        $policyFiles | ForEach-Object {
            Format-PolicyDefinition -fileName $_ -category $category
        }
    }
}

