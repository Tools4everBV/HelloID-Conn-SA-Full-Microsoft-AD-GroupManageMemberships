# Use Name -like '*' to query all users
$filter = "Name -like '*'"

# Global variables
$searchOUs = $AdUsersSearchOu

# Fixed values
$propertiesToSelect = @(
    "ObjectGuid",
    "SamAccountName",
    "UserPrincipalName",
    "Name",
    "DisplayName",
    "DistinguishedName"
) # Properties to select from Microsoft AD, comma separated

# Set debug logging
$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

try {
    #region Searching user
    $actionMessage = "querying AD account(s) matching the filter [$filter] in OU(s) [$($searchOUs)]"

    $ous = $searchOUs -split ';'
    $adUsers = [System.Collections.ArrayList]@()
    foreach ($ou in $ous) {
        $actionMessage = "querying AD account(s) matching the filter [$filter] in OU [$($ou)]"
        $getAdUsersSplatParams = @{
            Filter      = $filter
            Searchbase  = $ou
            Properties  = $propertiesToSelect
            Verbose     = $False
            ErrorAction = "Stop"
        }
        $getAdUsersResponse = Get-AdUser @getAdUsersSplatParams | Select-Object -Property $propertiesToSelect

        if ($getAdUsersResponse -is [array]) {
            [void]$adUsers.AddRange($getAdUsersResponse)
        }
        else {
            [void]$adUsers.Add($getAdUsersResponse)
        }
    }
    # Filter out users with no name
    $adUsers = $adUsers | Where-Object { $_.Name -ne "" }

    Write-Information "Queried AD account(s) matching the filter [$filter] in OU(s) [$($searchOUs)]. Result count: $(($adUsers | Measure-Object).Count)"

    # Sort and Send results to HelloID
    $actionMessage = "sending results to HelloID"
    # Add DisplayValue property
    $adUsers | Add-Member -MemberType NoteProperty -Name "DisplayValue" -Value $null -Force
    $adUsers | Sort-Object -Property Name | ForEach-Object {
        # Set DisplayValue property with format: Display Name [UserPrincipalName]
        $_.DisplayValue = "$($_.Name) ($($_.UserPrincipalName))"

        Write-Output $_
    } 
}
catch {
    $ex = $PSItem
    Write-Warning "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    Write-Error "Error $($actionMessage). Error: $($ex.Exception.Message)"
    # exit # use when using multiple try/catch and the script must stop
}
