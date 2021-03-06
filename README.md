# openstack-cli-scripts
The lazy but efficient OPS Guy set of scripts for performing maintenance on a OpenStack deployment. :)

## Generic OpenStack scripts

1. Disable-Compute.sh
  1. Disable the services of selected nova-compute node and evacuates the instances (shared storage required).
  
1. Enable-Compute.sh
  1. Re-Enable a nova-compute node.
  
1. Remove-Compute.sh
  1. Remove a nova-compute node from nova services (execute after Disable-Compute.sh).

1. Remove-OSD.sh
  1. Remove a OSD from a Ceph cluster.

1. Remove-All-OSDs.sh
  1. Remove all OSDs linked to a host in a Ceph cluster.

1. Remove-Ceph-Host.sh
  1. Remove and delete all DOWN OSDs from a host then removes the host from the CRUCH Map (execute after Remove-All-OSDs.sh).
  
## Mirantis OpenStack Specific Scripts

1. Change-VNC-Address.sh
  1. Change VNC address to public VIP in nova.conf on each nova-compute node.
  
1. Restart-Collectors.sh - StackLight
  1. Restart the Log and Metric collectors on each OpenStack controllers
  
1. Restart-InfluxDB_Grafana.sh - StackLight
  1. Restart InfluxdB and Grafana services on all StackLight node(s).

1. Add-Compute-Puppet-LMA.sh - StackLight
  1. Appplies a Puppet manifest on all Controller and Stacklight nodes.
  
1. ElasticSearch-Replicas.sh - StackLight
  1. This script shows you your current ElasticSearch Index Replicas and also allows you to set new values.
  
1. Change-All-Ceph-TCmalloc.sh - Ceph
  1. Change the TCMALLOC value to 128MB on each Ceph OSD node.

1. Change-Ceph-TCmalloc.sh - Ceph
  1. Change the TCMALLOC value to 128MB on a SPECIFIC Ceph OSD node.
  
