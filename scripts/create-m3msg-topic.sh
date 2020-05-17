#!/bin/bash

curl -vvvsSf -H "Cluster-Environment-Name: default_env" -X POST http://localhost:7201/api/v1/services/m3aggregator/placement/init -d '{
    "num_shards": 64,
    "replication_factor": 1,
    "instances": [
        {
            "id": "m3aggregator01",
            "isolation_group": "node1",
            "zone": "embedded",
            "weight": 100,
            "endpoint": "m3aggregator01:6000",
            "hostname": "m3aggregator01",
            "port": 6000
        }
    ]
}'

echo "Initializing m3msg topic for m3coordinator ingestion from m3aggregators"
curl -vvvsSf -X POST -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/topic/init -d '{
    "numberOfShards": 64
}'

echo "Initializing m3coordinator topology"
curl -vvvsSf -X POST localhost:7201/api/v1/services/m3coordinator/placement/init -d '{
    "instances": [
        {
            "id": "m3coordinator01",
            "zone": "embedded",
            "endpoint": "m3coordinator01:7507",
            "hostname": "m3coordinator01",
            "port": 7507
        }
    ]
}'
echo "Done initializing m3coordinator topology"

echo "Validating m3coordinator topology"
[ "$(curl -sSf localhost:7201/api/v1/services/m3coordinator/placement | jq .placement.instances.m3coordinator01.id)" == '"m3coordinator01"' ]
echo "Done validating topology"

# Do this after placement for m3coordinator is created.
echo "Adding m3coordinator as a consumer to the aggregator topic"
curl -vvvsSf -X POST -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/topic -d '{
  "consumerService": {
    "serviceId": {
      "name": "m3coordinator",
      "environment": "default_env",
      "zone": "embedded"
    },
    "consumptionType": "SHARED",
    "messageTtlNanos": "600000000000"
  }
}'
