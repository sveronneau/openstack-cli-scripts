#!/bin/bash
# Before running this, openrc must be loaded.
# > source openrc
#
clear
#
echo --- Getting list of Hosts and OSDs
echo
ceph osd tree
echo
echo "Please enter the Ceph OSD ID you want to remove: "
read osd_id
#
###### Validate if node exist
echo
echo --- Validating OSD ID: $osd_id
echo
ok_osd=$(ceph osd tree | grep -c osd.$osd_id | grep -v grep);
if [ $ok_osd = 0 ]; then
	echo '*** Invalid OSD ID - Script will exit ***'
	echo
	exit
fi
#
###### Remove OSD from Ceph cluster (On Controller node)
echo --- OSD ID $osd_id valid.
echo
echo --- Removing OSD.$osd_id from Ceph cluster
echo
ceph osd out $osd_id
echo
sleep 5s
#
###### Stopping Ceph OSD (On Storage node)
osd_host=$(ceph osd tree | awk '/host/{a=$0}/'osd.$osd_id'/ && a {print a;a=""}' | sed 's/.*host //');
echo --- Stopping Ceph OSD.$osd_id on host $osd_host
echo
ssh root@$osd_host "stop ceph-osd id=$osd_id";
echo
sleep 5s
#
###### Removing Ceph OSD from CRUSH map (On Controller node)
echo --- Removing Ceph OSD.$osd_id from CRUSH map.
echo
ceph osd crush remove osd.$osd_id
echo
sleep 5s
#
###### Checking Ceph cluster health (On Controller node)
echo --- Checking Ceph cluster health.
echo
ceph -s
echo
#
echo "-----------------";
echo "--- IMPORTANT ---";
echo "-----------------";
echo
echo "--- Once the Ceph cluster health is HEALTH_OK (ceph -s), please run:";
echo "------ ceph auth del osd.$osd_id";
echo "------ ceph osd rm osd.$osd_id";
echo
echo "--- After all OSDs have been deleted the host $osd_host can be removed from the CRUSH map:";
echo "------ ceph osd crush remove $osd_host";
echo
#