#!/bin/bash
# This script is for a FUEL based OpenStack deployment and shoudl be run ONLY post-deployment.
#
# Change the TCMALLOC value to 128MB on each Ceph OSD node.
#
# To Verify that the new value has been taken by the service restart, do the following on a Ceph OSD node: ps -C ceph-osd -fH eww | egrep --color 'TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES|$'
#
echo --- Changing TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES on each OSD node
#
for node_name in $(fuel node list | grep ready | awk '/ceph-osd/ {print $5}'); do	 
	#
	ssh ${node_name} "cp /etc/init/ceph-osd.conf /etc/init/ceph-osd.conf-BAK"
	ssh ${node_name} "awk -v n=2 -v s='env TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES=128MB' 'NR == n {print s} {print}' /etc/init/ceph-osd.conf > /etc/init/NEW-ceph-osd.conf"
	ssh ${node_name} "mv /etc/init/NEW-ceph-osd.conf /etc/init/ceph-osd.conf"
	ssh ${node_name} "awk -v n=3 -v s='export TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES' 'NR == n {print s} {print}' /etc/init/ceph-osd.conf > /etc/init/NEW-ceph-osd.conf"
	ssh ${node_name} "mv /etc/init/NEW-ceph-osd.conf /etc/init/ceph-osd.conf"
	#
done
#
echo --- Restarting ceph-all on each OSD node
#
for node_name in $(fuel node list | grep ready | awk '/ceph-osd/ {print $5}'); do	 
	#
	ssh ${node_name} "stop ceph-all ; sleep 15s ; start ceph-all"	
	sleep 15s;
	#
done
#