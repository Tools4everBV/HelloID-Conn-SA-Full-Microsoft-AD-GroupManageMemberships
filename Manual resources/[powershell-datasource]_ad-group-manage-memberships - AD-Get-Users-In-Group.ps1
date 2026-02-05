# Variables configured in form
$group = $datasource.selectedGroup

# Fixed values
$propertiesToSelect = @( 
    "Name",                 
    "ObjectGuid"
) # Properties to select from Microsoft AD, comma separated

try {
    $actionMessage = "searching user(s) for group [$($group.Name)] with ObjectGuid [$($group.ObjectGuid)]"
     
    # Get group memberships for the user
    $getAdGroupsSplatParams = @{
        Verbose     = $False
        ErrorAction = "Stop"
        Identity    = $group.ObjectGuid
    }
         
    $users = Get-ADGroupMember @getAdGroupsSplatParams | 
    Where-Object { $_.objectClass -eq "user" } |
    Sort-Object Name |
    Select-Object -Property $propertiesToSelect

    $resultCount = @($users).Count       
    Write-information "User memberships: $resultCount"
        
    if ($resultCount -gt 0) {
        foreach ($user in $users) {
            Write-output $user
        }
    }
}
catch {
    $ex = $PSItem
    Write-Warning "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    Write-Error "Error $($actionMessage). Error: $($ex.Exception.Message)"
}
