#Search for some master roles
Get-ADDomain corp | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator