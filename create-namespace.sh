#!/bin/bash
curl -X POST localhost:7201/api/v1/namespace -d '{
  "name": "test",
  "options": {
    "bootstrapEnabled": true,
    "flushEnabled": true,
    "writesToCommitLog": true,
    "cleanupEnabled": true,
    "snapshotEnabled": true,
    "repairEnabled": false,
    "retentionOptions": {
      "retentionPeriodDuration": "2160h",
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
