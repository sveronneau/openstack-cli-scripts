# openstack-cli-scripts
Quick set of scripts for performing maintenance on a OpenStack deployment.

## Generic OpenStack scripts

1. Disable-Compute.sh
  1. Disable the services of selected nova-compute node and evacutes the instances (shared storage required).
  
1. Enable-Compute.sh
  1. Re-Enable a nova-compute node.
  
1. Remove-Compute.sh
  1. Remove a nova-compute node from nova services (execute after Disable-Compute.sh).

1. Remove-OSD.sh
  1. Remove a OSD from Ceph cluster.
  
## Mirantis OpenStack Specific Scripts

1. Restart-Collectors.sh
  1. Restart the Log and Metric collectors on each OpenStack controllers
  
1. Change-VNC-Address.sh
  1. Change VNC address to public VIP in nova.conf on each nova-compute node.

1. Restart-InfluxDB_Grafana.sh
  1. Restart InfluxdB and Grafana services on all StackLight node(s).
