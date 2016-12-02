#!/bin/bash
# This script is for a FUEL based OpenStack deployment with Stacklight Plugins
#
# Restart Log and Metric Collector on the StackLight node(s).
#
clear
#
echo
echo --- Restarting Log and Metric Collector services
#
for node_name in $(fuel node list | grep ready | awk '/controller/ {print $5}'); do	 
	echo
	echo --- Node $node_name
	ssh ${node_name} "crm resource restart log_collector ; sleep 5s ; crm resource restart metric_collector"
	sleep 5s;
	ssh ${node_name} "crm resource status log_collector ; crm resource status metric_collector"
	sleep 15s
done
#