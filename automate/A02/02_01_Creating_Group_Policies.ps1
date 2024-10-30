#Create a new Group Policy Object (GPO)
New-GPO -Name "Desktop Einstellungen"

#Get the GPO
$GPO = Get-GPO -Name "Desktop Einstellungen"

#Modify the GPO
Set-GPRegistryValue -Name $GPO.DisplayName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -ValueName 'NoChangingWallPaper' -Value 1 -Type Dword

#Do Prevent changing desktop icons
Set-GPRegistryValue -Name "Desktop Einstellungen" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName 'NoDispBackgroundPage' -Value 1 -Type Dword

#Desktop Wallpaper
Set-GPRegistryValue -Name "Desktop Einstellungen" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName 'WallpaperStyle' -Value 0 -Type Dword

#Linking the GPO to the OU
Get-GPO -Name "Desktop Einstellungen" | New-GPLink -target "OU=CFO,DC=corp,DC=pri" -LinkEnabled Yes

#Create a new Group Policy Object (GPO)
New-GPO -Name "TestGPO"

#Configure a registry-based policy setting for a registry value
$params = @{
    Name      = 'TestGPO'
    Key       = 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop'
    ValueName = 'ScreenSaveTimeOut'
    Value     = 900
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

#Configure a registry-based policy settings for multiple registry values
$params = @{
    Name      = 'TestGPO'
    Key       = 'HKCU\Software\Policies\Microsoft\ExampleKey'
    ValueName = 'ValueOne', 'ValueTwo', 'ValueThree'
    Value     = 'String 1', 'String 2', 'String 3'
    Type      = 'String'
}
Set-GPRegistryValue @params

#Disable registry-based policy settings for a specific registry key
Set-GPRegistryValue -Disable -Name 'TestGPO' -Key 'HKCU\Software\Policies\Microsoft\ExampleKey'