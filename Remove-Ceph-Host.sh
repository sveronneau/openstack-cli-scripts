#!/bin/bash
# Before running this, openrc must be loaded.
# > source openrc
#
rm -f /tmp/osd_list
clear
#
echo --- Getting list of Hosts and OSDs
echo
ceph osd tree
echo
echo "Please enter the Ceph Host Name you want to remove from cluster: "
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
ok_osd=$(ceph osd tree | awk '/'$host_name'/{flag=1;next}/host/{flag=0}flag' | grep -v "rack" | grep -c up);
if [ $ok_osd != 0 ]; then
	ceph osd tree | awk '/'$host_name'/{flag=1;next}/host/{flag=0}flag' | grep -v "rack" | grep up
	echo
	echo '*** Host still as OSDs in UP state - Script will exit'	
	echo
	exit
fi
###### Showing list of OSDs for the selected Ceph Host (On Controller node)
echo --- List of OSDs for Host: $host_name
echo
ceph osd tree | awk '/'$host_name'/{flag=1;next}/host/{flag=0}flag' | grep -v "rack"
echo
echo "Hit any key to start the removal process"
read 
#
##### Loop that removes all OSDs from selected host
ceph osd tree | awk '/'$host_name'/{flag=1;next}/storage/{flag=0}flag' | grep -v "rack" | grep down | awk -F '' '$0=$2' | tr -d ' ' > /tmp/osd_list
filename='/tmp/osd_list'
filelines=`cat $filename`
#
echo Removing all OSDs from $host_name
#
for line in $filelines ; do
    echo --- del osd.$line from $host_name
	ceph auth del osd.$line
	sleep 2s
	echo --- rm osd.$line from $host_name
	ceph osd rm osd.$line
done
#
##### Remove Host from CRUSH Map
#
echo
echo Removing $host_name from CRUSH Map
ceph osd crush remove $host_name
echo
echo --- Process done
echo
#