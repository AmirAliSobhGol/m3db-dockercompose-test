#!/bin/bash

curl -sSf -X POST localhost:7201/api/v1/placement/init -d '{
    "num_shards": 32,
    "replication_factor": 1,
    "instances": [
        {
            "id": "m3db-01",
            "isolation_group": "node1",
            "zone": "embedded",
            "weight": 100,
            "endpoint": "m3db:9000",
            "hostname": "m3db-01",
            "port": 9000
        }
    ]
}'
