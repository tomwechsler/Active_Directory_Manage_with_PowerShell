#region Gathering the data
# Define the properties to retrieve
$properties = 'Name','Department','Title','EmailAddress','OfficePhone'

# Get one user's info
Get-ADUser 'Walter White' -Properties $properties | Format-Table $properties

# For all applicable users
$users = Get-ADUser -Filter {Department -like '*'} -Properties $properties

# Export-Excel settings
$exportExcelParams = @{
    Autosize = $true
    TableName = 'Contacts'
    TableStyle = 'Light1'
}

# Output to .xlsx to make printable
$users | Select-Object $properties | Export-Excel .\Contacts.xlsx -Title Contacts @exportExcelParams

# Open the file
Exit-PSSession
Copy-Item C:\users\administrator\documents\Contacts.xlsx -Destination .\Contacts.xlsx -FromSession $Sessions[0]
. .\Contacts.xlsx

# Remote back to DC01
Enter-PSSession $Sessions[0]

#endregion

#region Sort the data a bit better
# Group by department, as an example
$users | Group-Object Department

# Format on different spreadsheets
ForEach($group in ($users | Group-Object Department)){
    $groupParams = @{
        Path = ".\Contacts\$($Group.Name)_Contacts.xlsx"
        Title = "$($Group.Name) Contact List"
    }
    $group.Group | Select-Object $properties | Export-Excel @groupParams @exportExcelParams
}

# List the directory
Get-ChildItem .\Contacts

# Open one of the files
Exit-PSSession
Copy-Item C:\users\administrator\documents\Contacts\Accounting_Contacts.xlsx -Destination .\Accounting_Contacts.xlsx -FromSession $Sessions[0]
. .\Accounting_contacts.xlsx

# Remote back to DC01
Enter-PSSession $Sessions[0]

#endregion

#region Of course we'll make that a function
Function New-ADContactList {
    [cmdletbinding(
        DefaultParameterSetName = 'All'
    )]
    Param(
        [Parameter(
            ParameterSetName = 'GroupBy'
        )]
        [string]$GroupBy = 'Department',
        [Parameter(
            ParameterSetName = 'GroupBy'
        )]
        [string]$OutFolderPath,
        [Parameter(
            ParameterSetName = 'All'
        )]
        [string]$OutFilePath,
        [string]$Filter = "Department -like '*'",
        [string[]]$Properties = @('Name','Department','Title','EmailAddress','OfficePhone'),
        [hashtable]$ExportExcelParams = @{
            Autosize = $true
            TableName = 'Contacts'
            TableStyle = 'Light1'   
        }
    )
    $users = Get-ADUser -Filter $Filter -Properties $Properties
    If($PSCmdlet.ParameterSetName -eq 'GroupBy'){
        ForEach($group in ($users | Group-Object $GroupBy)){
            $groupParams = @{
                Path = "$OutFolderPath\$($Group.Name)_Contacts.xlsx"
                Title = "$($Group.Name) Contact List"
            }
            $group.Group | Select-Object $properties | Export-Excel @groupParams @ExportExcelParams
        }
    }ElseIf($PSCmdlet.ParameterSetName -eq 'All'){
        $allParams = @{
            Path = $OutFilePath
            Title = 'Contact List'
        }
        $users | Select-Object $properties | Export-Excel @allParams @ExportExcelParams
    }
}

# Usage
New-ADContactList -GroupBy 'Department' -OutFolderPath .\Department

# Verify
Get-ChildItem .\Department
Import-Excel .\Department\Accounting_Contacts.xlsx -StartRow 2

# Usage
New-ADContactList -OutFilePath .\AllContacts.xlsx
Import-Excel .\AllContacts.xlsx -StartRow 2

#endregion