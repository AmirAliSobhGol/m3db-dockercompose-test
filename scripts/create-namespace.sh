#!/bin/bash
curl -X POST localhost:7201/api/v1/namespace -d '{
  "name": "unagg",
  "options": {
    "bootstrapEnabled": true,
    "flushEnabled": true,
    "writesToCommitLog": true,
    "cleanupEnabled": true,
    "snapshotEnabled": true,
    "repairEnabled": false,
    "retentionOptions": {
      "retentionPeriodDuration": "3h",
      "blockSizeDuration": "1h",
      "bufferFutureDuration": "10m",
      "bufferPastDuration": "10m",
      "blockDataExpiry": true,
      "blockDataExpiryAfterNotAccessPeriodDuration": "5m"
    },
    "indexOptions": {
      "enabled": true,
      "blockSizeDuration": "2h"
    }
  }
}'

sleep 1
echo --- NEXT NAMESPACE ---

curl -X POST localhost:7201/api/v1/namespace -d '{
  "name": "metrics_1m_24h",
  "options": {
    "bootstrapEnabled": true,
    "flushEnabled": true,
    "writesToCommitLog": true,
    "cleanupEnabled": true,
    "snapshotEnabled": true,
    "repairEnabled": false,
    "retentionOptions": {
      "retentionPeriodDuration": "24h",
      "blockSizeDuration": "12h",
      "bufferFutureDuration": "1h",
      "bufferPastDuration": "1h",
      "blockDataExpiry": true,
      "blockDataExpiryAfterNotAccessPeriodDuration": "5m"
    },
    "indexOptions": {
      "enabled": true,
      "blockSizeDuration": "12h"
    }
  }
}'
