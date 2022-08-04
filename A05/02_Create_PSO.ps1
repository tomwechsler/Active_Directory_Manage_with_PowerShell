#What are the settings?
Get-ADDefaultDomainPasswordPolicy

#New OU for executives
New-ADOrganizationalUnit CFO

#And a group
New-ADGroup -Name "Executives" `
-GroupScope Universal `
-Description "Executives of corp.pri" `
-GroupCategory "Security" `
-Path "OU=CFO,DC=corp,DC=pri" `
-SAMAccountName "Executives" `
-PassThru

#New CFO needs an account
New-ADUser -Name "Erika Meister" `
-GivenName "Erika" `
-SurName "Meister" `
-Department "Finance" `
-Description "Chief Financial Officer" `
-ChangePasswordAtLogon $True `
-EmailAddress "Erika.Meister@corp.pri" `
-Enabled $True `
-PasswordNeverExpires $False `
-SAMAccountName "Erika.Meister" `
-AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
-Title "Chief Financial Officer" `
-PassThru

#This account is a member of the new group
Add-ADPrincipalGroupMembership -Identity "Erika.Meister" `
-MemberOf "Executives" `
-PassThru

#Did it work?
Get-ADGroupMember "Executives" | Select-Object SamAccountName

#Now we create a PSO
New-ADFineGrainedPasswordPolicy `
-description:"Minimum12 characters for all executives" `
-LockoutDuration 00:10:00 `
-LockoutObservationWindow 00:10:00 `
-LockoutThreshold 5 `
-MaxPasswordAge 65.00:00:00 `
-MinPasswordLength 12 `
-Name:"Management Pwd Policy" `
-Precedence 10 `
-PassThru

#We set this new PSO to the new group
Get-ADGroup -Identity "Executives" `
| Add-ADFineGrainedPasswordPolicySubject `
-Identity "Management Pwd Policy"

#And see if it worked => check can also be done in AD management center
Get-ADFineGrainedPasswordPolicySubject -Identity "Management Pwd Policy"