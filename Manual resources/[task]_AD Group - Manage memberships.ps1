# variables configured in form
$group = $form.gridGroups
$usersToAdd = $form.members.leftToRight
$usersToRemove = $form.members.rightToLeft

# Set debug logging
$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

Write-Verbose "User(s) to add: $usersToAdd"
Write-Verbose "User(s) to remove: $usersToRemove"

foreach ($user in $usersToAdd) {
    try {
        $actionMessage = "adding AD user(s) to group [$($group.DisplayName)] with objectguid [$($group.ObjectGuid)]"
                    
        Add-ADGroupMember -Identity $group.ObjectGuid -Members $user.sAMAccountName -Confirm:$false
        Write-Information "Successfully added AD user $adUserDisplayName ($adUserSID) to group $adGroupDisplayName ($adGroupSID)"

        $Log = @{
            Action            = "GrantMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Successfully added AD user $adUserDisplayName ($adUserSID) to group $adGroupDisplayName ($adGroupSID)" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $groupName # optional (free format text)
            TargetIdentifier  = $adGroupSID # optional (free format text)
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log
    }
    catch {
        $adGroupSID = $([string]$adGroup.SID)
        $Log = @{
            Action            = "GrantMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Failed to add AD user $adUserDisplayName ($adUserSID) to group $adGroupDisplayName ($adGroupSID). Error: $($_.Exception.Message)" # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $groupName # optional (free format text)
            TargetIdentifier  = $adGroupSID # optional (free format text)
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log

        Write-Error "Could not add AD user $adUserDisplayName ($adUserSID) to group $adGroupDisplayName ($adGroupSID). Error: $($_.Exception.Message)"            
    }
}

foreach ($user in $usersToRemove) {
    try {
        $actionMessage = "removing AD group(s) for user [$($user.userPrincipalName)] with objectguid [$($user.ObjectGuid)]"

        Remove-ADGroupMember -Identity $group.ObjectGuid -Members $user.sAMAccountName -Confirm:$false
        Write-verbose -verbose "Successfully removed AD user [$($user.userPrincipalName)] with objectguid [$($user.ObjectGuid)] from AD group [$($group.name)]"

        $Log = @{
            Action            = "RevokeMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Successfully removed AD user [$($user.userPrincipalName)] with objectguid [$($user.ObjectGuid)] from group $($group.name)" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $user.userPrincipalName # optional (free format text) 
            TargetIdentifier  = $user.ObjectGuid # optional (free format text) 
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log
    }
    catch {
        $ex = $PSItem
        $auditMessage = "Error $($actionMessage). Error: $($ex.Exception.Message)"
        $warningMessage = "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"

        $Log = @{
            Action            = "RevokeMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = $auditMessage # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $user.userPrincipalName # optional (free format text) 
            TargetIdentifier  = $user.ObjectGuid # optional (free format text) 
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log
        Write-Warning $warningMessage   
        Write-Error $auditMessage
    }
}
