#Let me explain my "stale"
#1. Haven't logged in for X days
#2. Hasn't logged in
#3. Created at least X days ago


#Using Search-ADAccount
Search-ADAccount -AccountInactive -TimeSpan '90.00:00:00' -UsersOnly

#Using a filter
Get-ADUser "Leonard.Clark" -Properties LastLogonTimeStamp | Select-Object Name,LastLogonTimeStamp

#If it is older than $LogonDate
$LogonDate = (Get-Date).AddHours(-1).ToFileTime()
Get-ADUser -Filter {LastLogonTimeStamp -lt $LogonDate}

#If it doesn't have value
Get-ADUser -Filter {LastLogonTimeStamp -notlike "*"} -Properties LastLogonTimeStamp |
Select-Object Name,LastLogonTimeStamp

#And if the account was created before $createdDate
$createdDate = (Get-Date).AddDays(-14)
Get-ADUser -Filter {Created -lt $createdDate} -Properties Created |
Select-Object Name,Created

#Add them all together:
$filter = {
    ((LastLogonTimeStamp -lt $logonDate) -or (LastLogonTimeStamp -notlike "*"))
    -and (Created -lt $createdDate)
}

Get-ADuser -Filter $filter | Where-Object {$_.info -notmatch "System Account"} | Select-Object SamAccountName