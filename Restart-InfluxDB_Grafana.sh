#!/bin/bash
# This script is for a FUEL based OpenStack deployment with Stacklight Plugins
#
# Restart InfluxdB and Grafana services on all StackLight node(s).
#
echo --- Restarting Log and Metric Collector services
#
for node_num in $(fuel node list | grep ready | awk '/stacklight/ {print $1}'); do	 
	ssh node-${node_num} "service influxdb restart"
	ssh node-${node_num} "service grafana-server restart"
done
#