<#
    Enter-PSSession -Computername DC01
    Set-Location C:\ps\
    Install-Module ImportExcel -Verbose -Force
    Import-Module ImportExcel
    Import-Module ActiveDirectory
#>

# Show modules
Get-Module ImportExcel
Get-Module ActiveDirectory

(Get-ADDomainController).Name

#region prep work
# Import the spreadsheet
$SpreadSheet = 'C:\ps\UserUpdate.xlsx'
$Data = Import-Excel $SpreadSheet

# Check the data
$Data | Format-Table

# Correlate fields
$expectedProperties = @{
    Name = 'Full Name'
    GivenName = 'First Name'
    SurName = 'Last Name'
    Title = 'Job Title'
    Department = 'Department'
    OfficePhone = 'Phone Number'
}

# Correlate 'Manager' field
Get-Help New-ADUser -Parameter Manager

<# <ADUser> can be:
    SamAccountName
    DistinguishedName
    GUID
    SID
#>

Get-ADUser $Data[0].Manager

Get-ADUser $Data[0].Manager.Replace(' ','.')

# Manager
$Data[0].Manager.Replace(' ','.')

# SamAccountName
"$($Data[0].'First Name').$($Data[0].'Last Name')"

# Create a single user
$user = $Data[0]
$params = @{}
ForEach($property in $expectedProperties.GetEnumerator()){
    # If the new user has the property
    If($user."$($property.value)".Length -gt 0){
        # Add it to the splat
        $params["$($property.Name)"] = $user."$($property.value)"
    }
}
# Deal with other values
If($user.Manager.length -gt 0){
    $params['Manager'] = $user.Manager.Replace(' ','.')
}
$params['SamAccountName'] = "$($user.$($expectedProperties['GivenName'])).$($user.$($expectedProperties['SurName']))"
# Create the user
New-ADUser @params

# Did it work
Get-ADUser $params.SamAccountName

#endregion

#region Create a function
Function Import-ADUsersFromSpreadsheet {
    [cmdletbinding()]
    Param(
        [ValidatePattern('.*\.xlsx$')]
        [ValidateNotNullOrEmpty()]
        [string]$PathToSpreadsheet
    )
    # Hashtable to correlate properties
    $expectedProperties = @{
        Name = 'Full Name'
        GivenName = 'First Name'
        SurName = 'Last Name'
        Title = 'Job Title'
        Department = 'Department'
        OfficePhone = 'Phone Number'
    }
    # Make sure the xlsx exists
    If(Test-Path $PathToSpreadsheet){
        $data = Import-Excel $PathToSpreadsheet
        ForEach($user in $data){
            # Build a splat
            $params = @{}
            ForEach($property in $expectedProperties.GetEnumerator()){
                # If the new user has the property
                If($user."$($property.value)".Length -gt 0){
                    # Add it to the splat
                    $params["$($property.Name)"] = $user."$($property.value)"
                }
            }
            # Deal with other values
            If($user.Manager.length -gt 0){
                $params['Manager'] = $user.Manager.Replace(' ','.')
            }
            $params['SamAccountName'] = "$($user.$($expectedProperties['GivenName'])).$($user.$($expectedProperties['SurName']))"
            # Create the user
            New-ADUser @params
        }
    }
}

# Usage
Import-ADUsersFromSpreadsheet -PathToSpreadsheet '.\UserUpdate.xlsx'

# Verify
ForEach($user in $data){
    Get-ADUser "$($user.'First Name').$($user.'Last Name')" | Select-Object Name
}
#endregion