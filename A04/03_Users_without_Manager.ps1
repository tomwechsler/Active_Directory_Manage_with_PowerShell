#Define needed info
$properties = 'Name','Department','Title','GivenName','SurName'

#Build a filter
$filterString = "($($properties[0]) -notlike '*')"
For($x=1;$x -lt $properties.count; $x++){
    $filterString += " -or ($($properties[$x]) -notlike '*')"
}
$filterString

#Get those users
Get-ADUser -Filter $filterString -Properties $properties | Format-Table $properties

#We can filter for specific managers
Get-ADUser -Filter {Manager -eq 'Leonard.Clark'}

#But not empty manager
Get-ADUser -Filter {Manager -eq ''}

#Using an LDAPFilter
Get-ADUser -LDAPFilter "(!manager=*)" -Properties Manager | Format-Table Name,Manager

#Combine both into an LDAP filter
$properties += 'Manager'
$ldapFilter = "(|(!$($properties[0])=*)"
For($x=1;$x -lt $properties.count; $x++){
    $ldapFilter += "(!$($properties[$x])=*)"
}
$ldapFilter += ')'
$ldapFilter

Get-ADUser -LDAPFilter $ldapFilter -Properties $properties | Format-Table $properties