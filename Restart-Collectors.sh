#!/bin/bash
# This script is for a FUEL based OpenStack deployment with Stacklight Plugins
#
# Restart Log and Metric Collector on the StackLight node(s).
#
echo --- Restarting Log and Metric Collector services
#
for node_num in $(fuel node list | grep ready | awk '/controller/ {print $1}'); do	 
	ssh node-${node_num} "crm resource restart log_collector"
	ssh node-${node_num} "crm resource restart metric_collector" 
done
#