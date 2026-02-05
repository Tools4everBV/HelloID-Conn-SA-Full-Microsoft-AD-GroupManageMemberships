# Variables configured in form
$searchValue = $dataSource.searchValue
$searchQuery = "*$searchValue*"
$filter = "Name -like '$searchQuery'"

# Global variables
$searchOU = $ADgroupsSearchOU

$propertiesToSelect = @(                    
    "Name",
    "DistinguishedName",
    "ObjectGuid"
) # Properties to select from Microsoft AD, comma separated

# Set debug logging
$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

try {
    $actionMessage = "searching AD Group(s)"

    if (-not [String]::IsNullOrEmpty($searchValue)) {
        Write-information "SearchQuery: $searchQuery"
        Write-information "SearchBase: $searchOU"

        $ous = $searchOU -split ';' 
        $groups = foreach ($item in $ous) {
            $getAdGroupsSplatParams = @{
                Filter      = $filter
                Searchbase  = $item
                Properties  = $propertiesToSelect
                Verbose     = $False
                ErrorAction = "Stop"
            }
            Get-ADGroup @getAdGroupsSplatParams | Select-Object -Property $propertiesToSelect
        }
        
        $groups = $groups | Sort-Object -Property name
        $resultCount = @($groups).Count
        Write-Information "Result count: $resultCount"

        if ($resultCount -gt 0) {
            foreach ($adGroup in $groups) {
                Write-Output $adGroup
            }
        }
    }
}
catch {
    $ex = $PSItem
    Write-Warning "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    Write-Error "Error $($actionMessage). Error: $($ex.Exception.Message)"
}
