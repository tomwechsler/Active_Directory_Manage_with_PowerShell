#region Gather info
# Single User's group membership:
(Get-ADUser 'Walter White' -Properties MemberOf).MemberOf

# Nicely formated
(Get-ADUser 'Walter White' -Properties MemberOf).MemberOf | ForEach-Object {Get-ADGroup $_}

# Multiple Users
Get-ADUser -Filter {Title -like '*manager*'} -Properties MemberOf

# Format
$users = Get-ADUser -Filter {Title -like '*manager*'} -Properties MemberOf
foreach($user in $users){
    [pscustomobject]@{
        Name = $user.Name
        User = $user.SamAccountName
        Memberships = ($user.MemberOf | ForEach-Object{Get-ADGroup $_}).Name
    }
}

# Make it presentable
$userGroups = @()
$users = Get-ADUser -Filter {Title -like '*manager*'} -Properties MemberOf
foreach($user in $users){
    $userGroups += [pscustomobject]@{
        User = $user.SamAccountName
        Name = $user.Name
        Memberships = ($user.MemberOf | ForEach-Object{Get-ADGroup $_}).Name -join ', '
    }
}
$userGroups | Export-Excel .\UserGroups.xlsx -Title 'Manager Group Memberships'

# Validate
Import-Excel .\UserGroups.xlsx -StartRow 2

#endregion

#region Functionize it!
Function Get-ADUserGroupMembershipReport {
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipeline = $true
        )]
        [Microsoft.ActiveDirectory.Management.ADUser]$Identity,
        [Parameter(
            Mandatory = $true
        )]
        [string]$FilePath,
        [string]$Title = 'AD User Membership Report',
        [string[]]$Properties
    )
    begin{
        $out = @()
    }
    process{
        $propertiesToQuery = $Properties + 'MemberOf'
        $user = Get-ADUser $Identity -Properties $propertiesToQuery
        $tmp = [pscustomobject]@{
            User = $user.SamAccountName
            Name = $user.Name
            Memberships = ($user.MemberOf | ForEach-Object{Get-ADGroup $_}).Name -join ', '
        }
        ForEach($property in $Properties){
            $tmp | Add-Member -MemberType NoteProperty -Name $property -Value $user."$property"
        }
        $out += $tmp
    }
    end{
        $out | Export-Excel $FilePath -Title $Title
    }
}

# Usage
Get-ADUserGroupMembershipReport -Identity 'Walter White' -FilePath .\Test.xlsx -Title "Walter's Memberships"

# Verify
Import-Excel .\Test.xlsx -StartRow 2
Remove-Item .\Test.xlsx

# All of a manager's reports
Get-ADUser -Filter {Manager -eq 'Sona.May'} | `
Get-ADUserGroupMembershipReport -FilePath .\Test.xlsx -Properties Title -Title "Minion membership report for Marie-ann"

#endregion