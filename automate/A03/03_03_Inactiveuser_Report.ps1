#IMPORTANT: The following two accounts must be excluded (Gast krbtgt)

#Imports active directory module to only current session
Import-Module ActiveDirectory

#Get-Date gives the present date in the server and is assigned to the variable presentdate
$presentdate= Get-Date

#User names whose lastlogondate is less than the presentdate-90days and those usernames are given to the variable output 
$output=Get-ADUser -Filter * -Properties lastlogondate | Where-Object {$_.lastlogondate -lt $presentdate.adddays(-90)} | Select-Object Name

#This output is exported to a .csv file 
$output | Export-Csv C:\inactiveusers.csv -NoTypeInformation

#This prints the users who are inactive by taking from the output
Write-Host "The following users are inactive : " -ForegroundColor DarkYellow
$output