#Gather Information
Get-ADOptionalFeature -Identity "Recycle Bin Feature"

#Enable
Enable-ADOptionalFeature `
-Identity "Recycle Bin Feature" `
-Scope ForestOrConfigurationSet `
-Target "corp.pri" `
-Confirm:$False

#Search for a user
Get-ADUser -Identity "Boris.Jones"

#Delete
Get-ADUser -Identity "Boris.Jones" | Remove-ADUser -Confirm:$False

#We check
Get-ADUser -Identity "Boris.Jones"

#We look closer
Get-ADObject -Filter {Name -like "Boris Jones*"} -IncludeDeletedObjects

#Restore
Get-ADObject -Filter {Name -like "Boris Jones*"} `
-IncludeDeletedObjects | Restore-ADObject

#We check
Get-ADObject -Filter {Name -like "Boris Jones"}