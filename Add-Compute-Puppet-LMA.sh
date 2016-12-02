#!/bin/bash
# This script is for a FUEL based OpenStack deployment with Stacklight Plugins
#
# Appplys a Puppet manifest on all Controller and Stacklight nodes.
#
clear
#
echo
echo --- Applying Puppet manifest on all Controller nodes
#
for node_name in $(fuel node list | grep ready | awk '/controller/ {print $5}'); do	 
	echo
	echo --- Node $node_name
	ssh ${node_name} "puppet apply -vd --modulepath=/etc/fuel/plugins/lma_collector-0.10/puppet/modules/:/etc/puppet/modules /etc/fuel/plugins/lma_collector-0.10/puppet/manifests/controller.pp"
done
#
echo
echo --- Applying Puppet manifest on all Stacklight nodes
#
for node_name in $(fuel node list | grep ready | awk '/lma/ {print $5}'); do	 
	echo
	echo --- Node $node_name
	ssh ${node_name} "puppet apply -vd --modulepath=/etc/fuel/plugins/lma_collector-0.10/puppet/modules/:/etc/puppet/modules /etc/fuel/plugins/lma_collector-0.10/puppet/manifests/lma_backends.pp"
done
#