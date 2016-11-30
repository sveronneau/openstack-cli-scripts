#!/bin/bash
# This script is for a FUEL based OpenStack deployment and shoudl be run post-deployment.
#
# Change the TCMALLOC value to 128MB on a SPECIFIC Ceph OSD node.
#
# To Verify that the new value has been taken by the service restart, do the following on the chosen Ceph OSD node: ps -C ceph-osd -fH eww | egrep --color 'TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES|$'
#
clear
#
echo --- List of CEPH-OSD nodes
echo
fuel node list | grep ceph-osd
echo
echo "Please enter the Ceph node ID you want to update TCMALLOC on: "
read node_id
#
###### Validate if node exist
echo
echo --- Validating Node ID: $node_id
echo
ok_id=$(fuel node | grep ceph-osd | awk -F'|' '$0=$1' | tr -d ' ' | grep -c $node_id);
if [ "$ok_id" = 0 ]; then
	echo '*** Invalid Node ID - Script will exit ***'
	echo
	exit
fi
#
echo --- Changing TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES on node-$node_id
#
ssh node-$node_id "cp /etc/init/ceph-osd.conf /etc/init/ceph-osd.conf-BAK"
ssh node-$node_id "awk -v n=2 -v s='env TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES=128MB' 'NR == n {print s} {print}' /etc/init/ceph-osd.conf > /etc/init/NEW-ceph-osd.conf"
ssh node-$node_id "mv /etc/init/NEW-ceph-osd.conf /etc/init/ceph-osd.conf"
ssh node-$node_id "awk -v n=3 -v s='export TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES' 'NR == n {print s} {print}' /etc/init/ceph-osd.conf > /etc/init/NEW-ceph-osd.conf"
ssh node-$node_id "mv /etc/init/NEW-ceph-osd.conf /etc/init/ceph-osd.conf"
#
echo --- Restarting ceph-all on each OSD node
#
ssh node-$node_id "stop ceph-all ; sleep 15s ; start ceph-all"
sleep 15s;
#