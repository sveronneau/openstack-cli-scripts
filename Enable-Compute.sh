#!/bin/bash
# Before running this openrc must be loaded and a compute nod selected.
# > source openrc
#
clear
#
echo --- Getting list of disabled compute nodes
echo
nova service-list | grep nova-compute | grep disabled
echo
echo "Please enter the node host name you want to enable: "
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
###### Enable services for a specific compute node
echo
echo --- Enabling services for node $node_name 
echo
nova service-enable $node_name nova-compute
echo
echo --- Host $node_name should be marked with status enabled
echo
#