#Search for some master roles
Get-ADDomain corp | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

#The PDCEmulator is important to know for the Event IDs: 4625 and 4750
#These contain information about bad password and account blocking

#Search for some master roles
Get-ADForest corp | Select-Object DomainNamingMaster, SchemaMaster

#List domaincontrollers and OperationMasterRoles
Get-ADDomainController -Filter * | Select-Object Name, Domain, Forest, OperationMasterRoles

#Search RSAT tool
Get-WindowsCapability -Online | Where-Object -Property Name -Like *group*

#Install RSAT Tools
Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0