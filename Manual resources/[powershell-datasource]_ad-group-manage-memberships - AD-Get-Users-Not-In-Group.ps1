# Variables configured in form
$filter = "*"

# Global variables
$searchOUs = $ADusersSearchOU

# Fixed values
$propertiesToSelect = @(                    
    "SamAccountName",
    "DisplayName",
    "Name",
    "UserPrincipalName",
    "Enabled", 
    "Description", 
    "Company",
    "Department",
    "Title",
    "ObjectGuid"
) # Properties to select from Microsoft AD, comma separated

try {
    #region Searching user
    $actionMessage = "searching AD account(s)"

    $ous = $searchOUs -split ';'
    $users = foreach ($item in $ous) {
        $getAdUsersSplatParams = @{
            Filter      = $filter
            Searchbase  = $item
            Properties  = $propertiesToSelect
            Verbose     = $False
            ErrorAction = "Stop"
        }
        Get-AdUser @getAdUsersSplatParams | Select-Object -Property $propertiesToSelect
    }


    #endregion Searching user

    #region Sorting user object(s)
    $users = $users | Sort-Object -Property DisplayName
    $resultCount = @($users).Count
    Write-Information "Result count: $resultCount"
         
    if ($resultCount -gt 0) {
        foreach ($user in $users) {
            Write-Output $user
        }
    }
    #endregion Sorting user object(s)
}
catch {
    $ex = $PSItem
    Write-Warning "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    Write-Error "Error $($actionMessage). Error: $($ex.Exception.Message)"
    # exit # use when using multiple try/catch and the script must stop
}
