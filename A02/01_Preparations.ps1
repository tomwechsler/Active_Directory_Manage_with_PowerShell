#Install RSAT Tools
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

#Import AD-Module
Import-Module ActiveDirectory

#Displaying the number of CMDLETs from the AD module
(Get-Command -Module ActiveDirectory).count