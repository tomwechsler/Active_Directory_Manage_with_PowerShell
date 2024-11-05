# Active Directory Domain Controller Replication Status
$domaincontroller = Read-Host 'What is your Domain Controller?'

# Define Objects
$report = New-Object PSObject -Property @{
ReplicationPartners = $null
LastReplication = $null
FailureCount = $null
FailureType = $null
FirstFailure = $null
}

# Replication Partners
$report.ReplicationPartners = (Get-ADReplicationPartnerMetadata -Target $domaincontroller).Partner
$report.LastReplication = (Get-ADReplicationPartnerMetadata -Target $domaincontroller).LastReplicationSuccess

# Replication Failures
$report.FailureCount  = (Get-ADReplicationFailure -Target $domaincontroller).FailureCount
$report.FailureType = (Get-ADReplicationFailure -Target $domaincontroller).FailureType
$report.FirstFailure = (Get-ADReplicationFailure -Target $domaincontroller).FirstFailureTime

# Format Output
$report | Select-Object ReplicationPartners,LastReplication,FirstFailure,FailureCount,FailureType | Out-GridView