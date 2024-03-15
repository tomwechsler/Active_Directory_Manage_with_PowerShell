#Declare variables
$domainName = "corp.pri"
$dsrmPassword = ConvertTo-SecureString "yourpassword" -AsPlainText -Force
$NetbiosName = "CORP"

#Install the AD Domain Services role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature

#Import the ServerManager module
Import-Module ServerManager

#Install the AD Domain Services
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $domainName `
-DomainNetbiosName $NetbiosName `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true `
-SafeModeAdministratorPassword $dsrmPassword

#Install RSAT Tools
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

#(Optional) Install all RSAT Tools
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

#Import AD-Module
Import-Module ActiveDirectory

#Displaying the number of CMDLETs from the AD module
(Get-Command -Module ActiveDirectory).count