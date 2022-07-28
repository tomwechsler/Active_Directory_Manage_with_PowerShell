Install-Module ImportExcel
Import-Module ActiveDirectory
$cred = Get-Credential

$PSDefaultParameterValues = @{
    '*-AD*:Server' = 'DC01'
    '*-AD*:Credential' = $cred
}

Import-Module ImportExcel

$data = Import-Excel '.\02 User Onboarding\ADData.xlsx'

ForEach($user in $data){
    New-ADUser -Name "$($user.GivenName) $($user.SurName)" `
        -UserPrincipalName "$($user.GivenName).$($user.SurName)@techsnipsdemo.local" `
        -GivenName $user.GivenName `
        -Surname $user.SurName `
        -OfficePhone $user.PhoneNumber `
        -Department $user.Department `
        -Title $user.Title `
        -State $user.State -Verbose
}
(get-aduser -Filter * -Properties department).department | select -unique | %{New-ADGroup -GroupCategory Security -GroupScope Global -Name "$_ Department"}
#get-aduser -Filter * -Properties department | %{Add-ADGroupMember "$($_.department) Department" -Members $_}

Get-ADUser -filter {department -eq "Marketing"} -Properties department
Get-ADUser -filter {department -eq "Marketing"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Marketing Department"
Get-ADGroupMember "Marketing Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Engineering"} -Properties department
Get-ADUser -filter {department -eq "Engineering"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Engineering Department"
Get-ADGroupMember "Engineering Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Engineering"} -Properties department
Get-ADUser -filter {department -eq "Engineering"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Engineering Department"
Get-ADGroupMember "Engineering Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Product Management"} -Properties department
Get-ADUser -filter {department -eq "Product Management"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Product Management Department"
Get-ADGroupMember "Product Management Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Sales"} -Properties department
Get-ADUser -filter {department -eq "Sales"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Sales Department"
Get-ADGroupMember "Sales Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Research and Development"} -Properties department
Get-ADUser -filter {department -eq "Research and Development"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Research and Development Department"
Get-ADGroupMember "Research and Development Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Training"} -Properties department
Get-ADUser -filter {department -eq "Training"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Training Department"
Get-ADGroupMember "Training Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Human Resources"} -Properties department
Get-ADUser -filter {department -eq "Human Resources"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Human Resources Department"
Get-ADGroupMember "Human Resources Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Business Development"} -Properties department
Get-ADUser -filter {department -eq "Business Development"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Business Development Department"
Get-ADGroupMember "Business Development Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Accounting"} -Properties department
Get-ADUser -filter {department -eq "Accounting"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Accounting Department"
Get-ADGroupMember "Accounting Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Support"} -Properties department
Get-ADUser -filter {department -eq "Support"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Support Department"
Get-ADGroupMember "Support Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Services"} -Properties department
Get-ADUser -filter {department -eq "Services"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Services Department"
Get-ADGroupMember "Services Department" | Get-ADUser -Properties department

Get-ADUser -filter {department -eq "Legal"} -Properties department
Get-ADUser -filter {department -eq "Legal"} -Properties department | Add-ADPrincipalGroupMembership -memberOf "Legal Department"
Get-ADGroupMember "Legal Department" | Get-ADUser -Properties department

(get-aduser -Filter * -Properties title).title | %{$_ -replace ' [IV]+$',''} | select -unique | %{New-ADGroup -GroupCategory Security -GroupScope Global -Name "$($_)s"}

get-aduser -Filter * -Properties title | %{$group = $_.title -replace ' [IV]+$','';Add-ADGroupMember -Identity "$($group)s" -Members $_}

New-ADGroup -GroupCategory Security -GroupScope Global -Name 'Managers'

get-aduser -Filter {Title -like '*manager*'} | %{Add-ADGroupMember -Identity Managers -Members $_}

New-ADGroup -GroupCategory Security -GroupScope Global -Name 'Executives'

get-aduser -Filter {Title -like '*Executive*'} | %{Add-ADGroupMember -Identity 'Executives' -Members $_}

New-ADGroup -GroupCategory Security -GroupScope Global -Name 'VPs'

get-aduser -Filter {Title -like '*VP*'} | %{Add-ADGroupMember -Identity 'VPs' -Members $_}

New-ADGroup -GroupCategory Security -GroupScope Global -Name 'Engineers'

get-aduser -Filter {Title -like '*Engineer*'} | %{Add-ADGroupMember -Identity 'Engineers' -Members $_}