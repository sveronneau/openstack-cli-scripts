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
echo "Please enter the node ID number name you want to remove: "
read node_id
#
###### Validate if node exist
echo
echo --- Validating Node ID: $node_id
echo
ok_id=$(nova service-list | grep nova-compute | grep disabled | awk -F'|' '$0=$2' | tr -d ' ' | grep $node_id);
if [ "$ok_id" = "" ]; then
	echo '*** Invalid Node ID - Script will exit ***'
	echo
	exit
fi
#
###### Delete node from list of Nova services
echo
echo --- Deleting node with ID $node_id from the list of Nova services
echo
nova service-delete $node_id
#
echo --- Getting list of disabled compute nodes
echo
nova service-list | grep nova-compute | grep disabled
echo
#