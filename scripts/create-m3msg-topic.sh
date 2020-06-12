#!/bin/bash

echo "Initializing aggregator topology"
curl -vvvsSf -X POST -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/services/m3aggregator/placement/init -d '{
    "num_shards": 64,
    "replication_factor": 1,
    "instances": [
        {
            "id": "m3aggregator01",
            "isolation_group": "availability-zone-a",
            "zone": "embedded",
            "weight": 100,
            "endpoint": "m3aggregator01:6000",
            "hostname": "m3aggregator01",
            "port": 6000
        }
    ]
}'

echo "Initializing m3msg inbound topic for m3aggregator ingestion from m3coordinators"
curl -vvvsSf -X POST -H "Topic-Name: aggregator_ingest" -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/topic/init -d '{
    "numberOfShards": 64
}'

# Do this after placement and topic for m3aggregator is created.
echo "Adding m3aggregator as a consumer to the aggregator ingest topic"
curl -vvvsSf -X POST -H "Topic-Name: aggregator_ingest" -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/topic -d '{
  "consumerService": {
    "serviceId": {
      "name": "m3aggregator",
      "environment": "default_env",
      "zone": "embedded"
    },
    "consumptionType": "REPLICATED",
    "messageTtlNanos": "600000000000"
  }
}' # msgs will be discarded after 600000000000ns = 10mins

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
echo "Initializing m3msg outbound topic for m3coordinator ingestion from m3aggregators"
curl -vvvsSf -X POST -H "Topic-Name: aggregated_metrics" -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/topic/init -d '{
    "numberOfShards": 64
}'

echo "Adding m3coordinator as a consumer to the aggregator publish topic"
curl -vvvsSf -X POST -H "Topic-Name: aggregated_metrics" -H "Cluster-Environment-Name: default_env" localhost:7201/api/v1/topic -d '{
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


