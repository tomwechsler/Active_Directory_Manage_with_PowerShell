#region Creating groups
# Global Security
New-ADGroup 'Neueinstellungen' -GroupCategory Security -GroupScope Global

# Verify
Get-ADGroup 'Neueinstellungen'

# Universal distribution
New-ADGroup 'HR-Aktualisierungen' -GroupCategory Distribution -GroupScope Universal

# Verify
Get-ADGroup 'HR-Aktualisierungen'

#endregion

#region Populating a group
# One user
Add-ADGroupMember 'Neueinstellungen' -Members 'Walter White'

# Verify
Get-ADGroupMember 'Neueinstellungen' | Format-Table Name

# Remove that user
Remove-ADGroupMember 'Neueinstellungen' -Members 'Walter White'

# Multiple Users
Add-ADGroupMember 'Neueinstellungen' -Members 'Walter White','Esma.Font'

# Add all users from a spreadsheet
$SpreadSheet = '.\UserUpdate.xlsx'
$Data = Import-Excel $SpreadSheet

$data | ForEach-Object {Add-ADGroupMember 'Neueinstellungen' -Members $_.'Full Name'.replace(' ','.')}

# Verify
Get-ADGroupMember 'Neueinstellungen' | Format-Table Name

# Manager group, current state
(Get-ADGroupMember 'Managers').Count

# Add users based on a filter
Get-ADUser -Filter {Title -like '*manager*'} -Properties Title | Format-Table Name,Title
Get-ADUser -Filter {Title -like '*manager*'} | ForEach-Object {Add-ADGroupMember 'Managers' -Members $_}

# Verify
(Get-ADGroupMember 'Managers').Count

#endregion