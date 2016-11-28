#!/bin/bash
# Before running this openrc must be loaded and a compute nod selected.
# > source openrc
#
rm -f /tmp/instances_list
clear
#
echo --- Getting list of enabled compute nodes
echo
nova service-list | grep nova-compute | grep enabled
echo
echo "Please enter the node host name you want to disable: "
read node_name
#
###### Validate if node exist
echo
echo --- Validating host name: $node_name
echo
ok_node=$(nova hypervisor-list | grep -c $node_name | grep -v grep);
if [ $ok_node = 0 ]; then
	echo '*** Invalid Node Name - Script will exit ***'
	echo
	exit
fi
#
###### Disable services for a specific compute node
echo
echo --- Disabling services for node $node_name
echo
nova service-disable $node_name nova-compute --reason 'Maintenance'
#
##### List all hypervisors hotname and their Status - Selected compute node should be Status=Disabled
echo
nova hypervisor-list
echo --- Hypervisors list - $node_name should be marked with status disabled
echo
#
##### Capturing the list of instances on selected compute node 
nova hypervisor-servers $node_name | awk '{if(NR>3)print}' | head -n -1 | cut -c 3-38 > /tmp/instances_list
echo --- List of instances on node $node_name
cat /tmp/instances_list
echo
#
##### Loop that migrates all instances from selected compute node
#
filename='/tmp/instances_list'
filelines=`cat $filename`
echo --- Starting migration of instances:
#
for line in $filelines ; do
    echo $line
	nova live-migration $line
done
sleep 30s
#
echo
echo --- List of instances on compute node $node_name
echo --- If list not empty, wait a bit and re-run: nova hypervisor-servers $node_name
nova hypervisor-servers $node_name
echo
#