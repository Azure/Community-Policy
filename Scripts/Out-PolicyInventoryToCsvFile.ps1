$directory = "policyDefinitions"
$filePattern = "*.rules.json"

$files = Get-ChildItem -Path $directory -Filter $filePattern -File -Recurse
$ErrorView = 'ConciseView'

#generate a CSV file list of the file names, sub folder, name in the file, displayname in the file and effect allowed values
$rows = [System.Collections.ArrayList]::new()
foreach ($fileInfo in $files) {
    $fullName = $fileInfo.FullName -replace '\.rules\.json', '.json'
    $directoryName = $fileInfo.DirectoryName
    # check if file exists
    if (-not (Test-Path $fullName)) {
        Write-Error "Policy definition file not found: $fullName" -ErrorAction Continue
        # Write-Information of file names in directory
        $filesInDirectory = Get-ChildItem -Path $directoryName | Select-Object -ExpandProperty Name
        foreach ($file in $filesInDirectory) {
            Write-Information "   $($file)" -InformationAction Continue
        }
        continue
    }
    $json = Get-Content $fullName -Raw
    $definition = ConvertFrom-Json $json
    $subFolder = $directoryName -replace [regex]::Escape($directory), ''
    $name = $definition.Name
    $properties = $definition.properties
    $displayName = $properties.displayName
    $category = "unknown"
    if ($properties.metadata) {
        $metadata = $properties.metadata
        if ($metadata.category) {
            $category = $metadata.category
        }
    }
    $row = [ordered]@{
        category    = $category
        displayName = $displayName
        subFolder   = $subFolder
        name        = $name
    }
    $null = $rows.Add($row)
}

# sort rows by category, displayName, subFolder, name
$sortedRows = $rows | Sort-Object -Property { $_.category }, { $_.displayName }, { $_.subFolder }, { $_.name }
if (-not (Test-Path "Output")) {
    $null = New-Item -Path "Output" -ItemType Directory
}
$sortedRows | Export-Csv -Path "$PSScriptRoot/PolicyInventory.csv" -NoTypeInformation -Force
