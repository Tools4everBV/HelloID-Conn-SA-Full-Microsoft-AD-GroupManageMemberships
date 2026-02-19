$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

# variables configured in form
$group = $form.gridGroups
$usersToAdd = $form.members.leftToRight
$usersToRemove = $form.members.rightToLeft

foreach ($userToAdd in $usersToAdd) {
    try {
        # Add member to group
        # https://learn.microsoft.com/en-us/powershell/module/activedirectory/add-adgroupmember
        $actionMessage = "adding user with displayName [$($userToAdd.displayName)] and objectGuid [$($userToAdd.objectGuid)] as member to group with name [$($group.Name)] and objectGuid [$($group.ObjectGuid)]"

        $addGroupMemberSplatParams = @{
            Identity    = $group.ObjectGuid
            Members     = $userToAdd.ObjectGuid
            Verbose     = $false
            ErrorAction = "Stop"
        }
        Add-ADGroupMember @addGroupMemberSplatParams

        # Send auditlog to HelloID
        $Log = @{
            Action            = "GrantMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Added user with displayName [$($userToAdd.displayName)] and objectGuid [$($userToAdd.objectGuid)] as member to group with name [$($group.Name)] and objectGuid [$($group.ObjectGuid)]." # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $group.Name # optional (free format text) 
            TargetIdentifier  = $group.ObjectGuid # optional (free format text) 
        }
        Write-Information -Tags "Audit" -MessageData $log
    }
    catch {
        $ex = $PSItem
        $auditMessage = "Error $($actionMessage). Error: $($ex.Exception.Message)"
        $warningMessage = "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
        $log = @{
            Action            = "GrantMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = $auditMessage # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $group.Name # optional (free format text) 
            TargetIdentifier  = $group.ObjectGuid # optional (free format text) 
        }
        Write-Information -Tags "Audit" -MessageData $log
        Write-Warning $warningMessage   
        Write-Error $auditMessage
    }
}

foreach ($userToRemove in $usersToRemove) {
    try {
        # Remove member from group
        # https://learn.microsoft.com/en-us/powershell/module/activedirectory/remove-adgroupmember
        $actionMessage = "removing user with displayName [$($userToRemove.displayName)] and objectGuid [$($userToRemove.objectGuid)] as member from group with name [$($group.Name)] and objectGuid [$($group.ObjectGuid)]"
        
        $removeGroupMemberSplatParams = @{
            Identity    = $group.ObjectGuid
            Members     = $userToRemove.ObjectGuid
            Confirm     = $false
            ErrorAction = "Stop"
        }
        Remove-ADGroupMember @removeGroupMemberSplatParams

        # Send auditlog to HelloID
        $Log = @{
            Action            = "RevokeMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Removed user with displayName [$($userToRemove.displayName)] and objectGuid [$($userToRemove.objectGuid)] as member from group with name [$($group.Name)] and objectGuid [$($group.ObjectGuid)]." # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $group.Name # optional (free format text) 
            TargetIdentifier  = $group.ObjectGuid # optional (free format text) 
        }
        Write-Information -Tags "Audit" -MessageData $log
    }
    catch {
        $ex = $PSItem
        $auditMessage = "Error $($actionMessage). Error: $($ex.Exception.Message)"
        $warningMessage = "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
        $log = @{
            Action            = "RevokeMembership" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = $auditMessage # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $group.Name # optional (free format text) 
            TargetIdentifier  = $group.ObjectGuid # optional (free format text) 
        }
        Write-Information -Tags "Audit" -MessageData $log
        Write-Warning $warningMessage   
        Write-Error $auditMessage
    }
}
