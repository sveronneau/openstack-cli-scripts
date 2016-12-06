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
echo "Please enter the Ceph Host Name you want to remove OSDs from: "
read host_name
#
###### Validate if node exist
echo
ok_host=$(ceph osd tree | grep -c $host_name | grep -v grep);
if [ $ok_host = 0 ]; then
	echo '*** Invalid Ceph Host name - Script will exit'
	echo
	exit
fi
#
###### Showing list of OSDs for the selected Ceph Host (On Controller node)
echo --- List of OSDs for Host: $host_name
echo
ceph osd tree | awk '/'$host_name'/{flag=1;next}/host/{flag=0}flag' | grep -v "rack"
echo
#
echo
echo "Please enter the Ceph OSD ID you want to remove: "
read osd_id
#
###### Validate if OSD.id exist on Ceph Host
echo
ok_host_osd=$(ceph osd tree | awk '/'$host_name'/{flag=1;next}/host/{flag=0}flag' | grep -c osd.$osd_id);
if [ $ok_host_osd = 0 ]; then
	echo '*** OSD ID '$osd_id' is not on Host '$host_name' - Script will exit'
	echo
	exit
fi
#
###### Remove OSD from Ceph cluster (On Controller node)
echo --- Removing OSD.$osd_id from Ceph cluster
echo
ceph osd out $osd_id
echo
sleep 5s
#
###### Stopping Ceph OSD (On Storage node)
echo --- Stopping Ceph OSD.$osd_id on host $host_name
echo
ssh root@$host_name "stop ceph-osd id=$osd_id";
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
echo --- Process done
echo
#
echo --- Checking Ceph cluster health.
echo
ceph -s
echo
#