#Provide the destination DC in which you want to transfer the fsmo role
$destinationdc= Read-Host "Provide the Destination domain controller" 

#Choose the role you want to transfer
$role=read-host "Choose the role"
Switch($role)
{

1 { $result = 'DomainNamingMaster'}
2 { $result = 'PDCEmulator'}
3 { $result = 'RIDMaster'}
4 { $result = 'SchemaMaster'}
5 { $result = 'InfrastructureMaster'}
6 {$result = 'All'}
}

if($role -gt 6)

{
Write-host "Choose correct option" -ForegroundColor Cyan

}

#This will transfer DomainNamingMaster role to destination server
if ($role -eq 1)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole DomainNamingMaster -Identity $destinationDc -confirm:$false

 Write-host "$result is transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "Domain Naming Master" 
}

#This will transfer PDCEmulator role to destination server
 if ($role -eq 2)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole PDCEmulator -Identity $destinationDc -confirm:$false

 Write-host "$result is transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "PDC" 
}

#This will transfer RID pool manager role to destination server
 if ($role -eq 3)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole RIDMaster -Identity $destinationDc -confirm:$false

 Write-host "$result is transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "RID pool manager" 
}

#This will transfer Schema Master role to destination server
 if ($role -eq 4)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole SchemaMaster -Identity $destinationDc -confirm:$false

 Write-host "$result is transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "Schema Master" 
}

#This will transfer Infrastructure Master role to destination server
 if ($role -eq 5)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole InfrastructureMaster -Identity $destinationDc -Credential  -confirm:$false

 Write-host "$result is transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "Infrastructure Master" 
}

#This will transfer All roles to destination server
 if ($role -eq 6)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster -Identity $destinationDc  -confirm:$false 

 Write-host "$result roles are transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo  
}
 
