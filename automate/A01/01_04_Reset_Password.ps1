#region Resetting passwords
# Current state 
Get-ADUser 'Walter White' -Properties PasswordExpired,LockedOut | Format-Table Name,PasswordExpired,LockedOut

# Reset the password
$securePassword = ConvertTo-SecureString 'IWillNotForgetMyPasswordEverAgain8675309!' -AsPlainText -Force
Set-ADAccountPassword 'Walter White' -NewPassword $securePassword -Reset

# Force a password change
Set-ADUser 'Walter White' -ChangePasswordAtLogon $true

#endregion

#region Functioning password resets
Function Reset-ADUserPassword {
    [cmdletbinding(
        DefaultParameterSetName = 'Random'
    )]
    Param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Plain',
            Position = 1
        )]
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Random',
            Position = 1
        )]
        [Microsoft.ActiveDirectory.Management.ADUser]$Identity,
        [Parameter(
            ParameterSetName = 'Plain',
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Password
    )
    Begin{
        If($PSCmdlet.ParameterSetName -eq 'Plain'){
            # If $Password is specified, convert it to a secure string
            $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        }ElseIf($PSCmdlet.ParameterSetName -eq 'Random'){
            # Otherwise add this type to use the GeneratePassword method
            Add-Type -AssemblyName System.Web
        }
    }
    Process{
        If($PSCmdlet.ParameterSetName -eq 'Random'){
            # Generate a new random password for each user
            $securePassword = ConvertTo-SecureString ([System.Web.Security.Membership]::GeneratePassword(10,1)) -AsPlainText -Force
        }
        # Set the password
        Set-ADAccountPassword $Identity -NewPassword $securePassword -Reset
        # Force a password change
        Set-ADUser $Identity -ChangePasswordAtLogon $true
        # Output the user's name and result
        [pscustomobject]@{
            User = $Identity
            Password = [PScredential]::new("user",$SecurePassword).GetNetworkCredential().Password
        }
    }
    End{}
}

# Usage
Reset-ADUserPassword 'Walter White'

# Current State
Get-ADUser -Filter {Title -like '*Health*'} -Properties PasswordExpired | Format-Table Name,PasswordExpired

# Multipe accounts
Get-ADUser -Filter {Title -like '*Health*'} | Reset-ADUserPassword