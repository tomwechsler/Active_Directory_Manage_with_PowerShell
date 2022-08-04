#Session to DC01
Enter-PSSession -ComputerName DC01

#Install feature
Install-WindowsFeature -Name Windows-Server-Backup

#Update-Help
Update-Help -Module WindowsServerBackup -Force

#A list of modules, but not very helpful
Get-Command -Module WindowsServerBackup

#This is a bit better
Get-Command -Module WindowsServerBackup | Sort-Object Noun,Verb | Format-Table -AutoSize Verb,Noun

#We start with a new policy
$newWbPol = New-WBPolicy

#Which drives are present
Get-WBVolume -AllVolumes

#The backup of drive C
$wbVol = Get-WBVolume -VolumePath C:

#The drive will be added to the policy
Add-WBVolume -Policy $newWBPol -Volume $wbVol

#The following 2 variables are used to include and exclude files
$incFSpec = New-WBFileSpec -FileSpec "C:\Temp"
$excFSpec = New-WBFileSpec -FileSpec "C:\ps" -Exclude

#These two variables are added to the policy
Add-WBFileSpec -Policy $newWBPol -FileSpec $incFSpec
Add-WBFileSpec -Policy $newWBPol -FileSpec $excFSpec

#Let's quickly look at the contents of the variables
$newWBPol

#A new variable with the contents of the disks
$wbDisks = Get-WBDisk

#Which disk do I write the backup to
$wbDisks

#Add the disk to the policy
$wbTarget = New-WBBackupTarget -Disk $wbDisks[1]
Add-WBBackupTarget -Policy $newWBPol -Target $wbTarget

#With BMR
Add-WBBareMetalRecovery -Policy $newWBPol

#Is set to "True"
$newWBPol

#Incl. Systemstate
Add-WBSystemState -Policy $newWBPol

#Schedule
Set-WBSchedule -Policy $newWBPol -Schedule 12:00,20:00

#is now created
$newWBPol

#Before I make another change to the policy, I save the settings in the following variable
$curPol = Get-WBPolicy

#Do not overwrite the backup
Set-WBPolicy -Policy $newWBPol -AllowDeleteOldBackups:$False -Force

#Did it work?
Get-WBPolicy

#Lets go!
Start-WBBackup -Policy $newWBPol

#Some Infos
Get-WBSummary