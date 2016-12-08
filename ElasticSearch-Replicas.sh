#!/bin/bash
# This script shows you your current ElasticSearch Index Replicas and also allows you to set new values.
#
# ./ElasticSearch-Replicas.sh
# - Returns your current values
# ./ElasticSearch-Replicas.sh 2 0
# - Changes the current value (2) to the new one (0)
#
ES=$(lsof -u elasticsearch -a -i:9200 -sTCP:LISTEN -nP -Fn | grep '^n' | cut -c2-)
OLD_REPLICAS=$1
NEW_REPLICAS=$2
#
curl -s "$ES/_settings?pretty" | \
  jq -r 'to_entries[] | select(.value.settings.index.number_of_replicas=="'$OLD_REPLICAS'") | .key' | \
  while read -r index; do
    echo "Processing $index"
    curl -s -o /dev/null -XPUT "$ES/$index/_settings" -d '
{
    "index" : {
        "number_of_replicas" : '$NEW_REPLICAS'
    }
}'
  done
#
# Let's check
echo -e "\nCurrent value"
curl -s "$ES/_settings?pretty" | \
  jq -c -r 'to_entries[] | [ .key, .value.settings.index.number_of_replicas ]'
#
echo
#