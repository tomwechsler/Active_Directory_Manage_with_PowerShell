#Status of Microsoft Defender
Get-MpComputerStatus

#Gets the history of threats detected on the computer
Get-MpThreat

#Gets known threats from the definitions catalog
Get-MpThreatCatalog | more

#Gets active and past malware threats that Windows Defender detected
Get-MpThreatDetection

#Settings on local machine
Get-MpPreference

#Settings on domain connected remote system
Get-MpPreference -CimSession dc01

#Adjust settings
Set-MpPreference -DisableRemovableDriveScanning $false

Set-MpPreference -ScanScheduleTime 17:00:00

#Check for updates
Update-MpSignature

#Start Scan
Start-MpScan -ScanType FullScan

Start-MpScan -ScanType Quickscan

#Multiple systems
Invoke-Command -ComputerName dc02, dc01 -ScriptBlock {Start-MpScan -ScanType Quickscan}

#Starts a Windows Defender offline scan
Start-MpWDOScan