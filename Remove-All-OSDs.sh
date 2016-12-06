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
echo "Please enter the Ceph Host Name you want to remove all OSDs from: "
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
echo "Hit ENTER to start the listed OSDs removal process"
read 
#
##### Loop that removes all OSDs from selected host
ceph osd tree | awk '/'$host_name'/{flag=1;next}/host/{flag=0}flag' | grep -v "rack" | awk '{print $1}' | tr -d ' ' > /tmp/osd_list
filename='/tmp/osd_list'
filelines=`cat $filename`
#
echo
echo Removing all OSDs from $host_name
#
for line in $filelines ; do
	echo
    echo --- osd $line out
	ceph osd out $line
	echo
	sleep 2s
	echo --- osd.$line stoppped on host $host_name
	ssh root@$host_name "stop ceph-osd id=$line";
	echo
	sleep 2s
	echo --- osd crush remove osd.$line
	ceph osd crush remove osd.$line
done
#
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