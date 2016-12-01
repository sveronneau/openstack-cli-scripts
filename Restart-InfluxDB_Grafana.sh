#!/bin/bash
# This script is for a FUEL based OpenStack deployment with Stacklight Plugins
#
# Restart InfluxdB and Grafana services on all StackLight node(s).
#
clear
#
echo
echo --- Restarting InfluxdB and Grafana services
#
for node_name in $(fuel node list | grep ready | awk '/influxdb_grafana/ {print $5}'); do
	echo
	echo --- Node $node_name
	ssh ${node_name} "service influxdb restart"
	sleep 5s;
	ssh ${node_name} "service grafana-server restart"
	sleep 15;
done
#