# HelloID-Conn-SA-Full-AD-GroupManageMemberships
| :information_source: Information |
| :------------------------------- |
| This repository contains the connector and configuration code only. The implementer is responsible for acquiring the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements. |

## Description
_HelloID-Conn-SA-Full-AD-GroupManageMemberships_ is a template designed for use with HelloID Service Automation (SA) Delegated Forms. It can be imported into HelloID and customized according to your requirements. 

By using this delegated form, you can manage Active Directory group memberships across your connected systems. The following options are available:
 1. Search and select the target AD group
1. Search and select an AD group
2. View current group members
3. Select users to add to or remove from the group
4. Group memberships are updated in Microsoft Active Directory

## Getting started

### Requirements
- **Active Directory Access**:<br>
  A service account with appropriate permissions to query and modify Active Directory groups must be available. The account should have the necessary rights to add and remove members from AD groups.
- **HelloID SA Agent**:<br>
  A HelloID Service Automation agent must be installed and configured within your environment to execute PowerShell tasks against Active Directory.

### Connection settings
The following user-defined variables are used by the connector:

| Setting  | Description                        | Mandatory |
| -------- | ---------------------------------- | --------- |
| ADgroupsSearchOU | Array of Active Directory OUs for scoping AD groups in the search result | Yes |
| ADusersSearchOU | Array of Active Directory OUs for scoping AD user accounts to modify memberships | Yes |

## Remarks

### Wildcard Search
- **Search Functionality**: Users can search for groups using a wildcard (`*`) to return all groups, or by entering partial text to search across display name, description, and mail fields. This provides flexible group discovery based on multiple attributes.

## Development resources

### PowerShell Module
This connector uses the ActiveDirectory PowerShell module for managing Active Directory groups and user accounts.

- [ActiveDirectory Module Documentation](https://learn.microsoft.com/en-us/powershell/module/activedirectory/)

### Cmdlets
The following PowerShell cmdlets are used by the connector:

| Cmdlet | Description |
| --- | --- |
| Get-ADGroup | Retrieves Active Directory groups |
| Get-ADUser | Retrieves Active Directory user accounts |
| Get-ADGroupMember | Retrieves the members of an Active Directory group |
| Add-ADGroupMember | Adds one or more users to an Active Directory group |
| Remove-ADGroupMember | Removes one or more users from an Active Directory group |

### Cmdlet documentation
- [Get-ADGroup](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adgroup)
- [Get-ADUser](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser)
- [Get-ADGroupMember](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adgroupmember)
- [Add-ADGroupMember](https://learn.microsoft.com/en-us/powershell/module/activedirectory/add-adgroupmember)
- [Remove-ADGroupMember](https://learn.microsoft.com/en-us/powershell/module/activedirectory/remove-adgroupmember)



## Getting help
> :bulb: **Tip:**  
> _For more information on Delegated Forms, please refer to our [documentation](https://docs.helloid.com/en/service-automation/delegated-forms.html) pages_.

## HelloID docs
The official HelloID documentation can be found at: [https://docs.helloid.com/](https://docs.helloid.com/)