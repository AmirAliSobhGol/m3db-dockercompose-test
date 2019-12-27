before running set the kernel and docker parameters according to below link:
https://m3db.github.io/m3/operational_guide/kernel_configuration/


then after running docker-compose up, run the following:
```
curl -X POST http://localhost:7201/api/v1/database/create -d '{
  "type": "local",
  "namespaceName": "default",
  "retentionTime": "12h"
}'
```


