#The AD has no command for OUs to move content
Get-Command *org*

#Wir muessen uns mit dem cmdlet get-adobject helfen. Was gibt uns die Hilfe?
Get-Help Get-ADObject

#Let's search for accounts
Get-ADObject -SearchBase "OU=NewUsers,DC=prime,DC=pri" -Filter *

#By department
Get-ADUser -Filter "department -eq 'Engineers'"

#By department and city
Get-ADUser -Filter "department -eq 'Engineers' -and city -eq 'Luzern'"

#Listed a little bit better
Get-ADUser -Filter "department -eq 'Engineers' -and city -eq 'Luzern'" -Properties department, city | Select-Object name, city, department

#Now we move these three accounts
Get-ADUser -Filter "department -eq 'Engineers' -and city -eq 'Luzern'" -Properties department, city | Move-ADObject -TargetPath "OU=Engineers,OU=Luzern,DC=prime,DC=pri"

#Did it work?
Get-ADObject -SearchBase "OU=Engineers,OU=Luzern,DC=prime,DC=pri" -Filter *