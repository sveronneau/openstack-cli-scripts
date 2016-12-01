#!/bin/bash
# This script is for a FUEL based OpenStack deployment
#
# Change VNC address to public VIP
#
### Please change those values to reflect your environment
old_vnc="public.fuel.local";
new_vnc="openstack.rocks.com";
#
for node_num in $(fuel node list | grep ready | awk '/compute/ {print $5}'); do
	ssh ${node_name} "cp /etc/nova/nova.conf /etc/nova/nova.conf.org"
	ssh ${node_name} "sed -i 's/$old_vnc/$new_vnc/' /etc/nova/nova.conf"
	ssh ${node_name} "service nova-compute restart"  
done
#