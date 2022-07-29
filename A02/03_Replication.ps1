#Check the replication errors
Get-ADReplicationFailure -Target dc01

#For a given domain controller we can find its inbound replication partners
Get-ADReplicationPartnerMetadata -Target dc01.corp.pri

#We can list down all the inbound replication partners for given domain
Get-ADReplicationPartnerMetadata -Target "corp.pri" -Scope Domain

#We can review AD replication site objects
Get-ADReplicationSite -Filter *

#We can review AD replication site links on the AD forest
Get-ADReplicationSiteLink -Filter *