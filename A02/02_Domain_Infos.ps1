#Search for some master roles
Get-ADDomain corp | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

#Search for some master roles
Get-ADForest corp | Select-Object DomainNamingMaster, SchemaMaster

#List domaincontrollers and OperationMasterRoles
Get-ADDomainController -Filter * | Select-Object Name, Domain, Forest, OperationMasterRoles