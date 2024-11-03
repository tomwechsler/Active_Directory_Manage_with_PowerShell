#Step 1: Define the backup directory
$backupDir = "C:\gpobackup"

#Step 2: Create the backup directory
New-Item -Path $backupDir -ItemType Directory -Force

#Step 3: Backup the GPOs
Backup-GPO -All -Path $backupDir

#Step 4: Validate the backup
Get-ChildItem -Path $backupDir

#Step 5: Restore the GPOs
Restore-GPO -Name "FirewallSettings" -Path $backupDir