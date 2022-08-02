#Current state 
Get-ADUser 'Jonathan.Fisher' -Properties PasswordExpired,LockedOut | Format-Table Name,PasswordExpired,LockedOut

#Reset the password
$securePassword = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
Set-ADAccountPassword 'Jonathan.Fisher' -NewPassword $securePassword -Reset

#Force a password change
Set-ADUser 'Jonathan.Fisher' -ChangePasswordAtLogon $true

#Current state 
Get-ADUser 'Jonathan.Fisher' -Properties PasswordExpired,LockedOut | Format-Table Name,PasswordExpired,LockedOut