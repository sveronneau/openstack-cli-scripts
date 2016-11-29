#!/bin/bash
# This script is for a FUEL based OpenStack deployment
#
# Change VNC address to public VIP
#
### Please change those values to reflect your environment
old_vnc="public.fuel.local";
new_vnc="openstack.rocks.com";
#
for node_num in $(fuel node list | grep ready | awk '/compute/ {print $1}'); do
	ssh node-${node_num} "cp /etc/nova/nova.conf /etc/nova/nova.conf.org"
	ssh node-${node_num} "sed -i 's/$old_vnc/$new_vnc/' /etc/nova/nova.conf"
	ssh node-${node_num} "service nova-compute restart"  
done
#