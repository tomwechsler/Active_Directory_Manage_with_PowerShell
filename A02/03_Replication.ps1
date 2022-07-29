#Check the replication errors
Get-ADReplicationFailure -Target dc01

#For a given domain controller we can find its inbound replication partners
Get-ADReplicationPartnerMetadata -Target dc01.corp.pri