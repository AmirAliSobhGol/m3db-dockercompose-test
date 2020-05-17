before running set the kernel and docker parameters according to below link:
https://m3db.github.io/m3/operational_guide/kernel_configuration/


then after running docker-compose up, run the following from script directory:
```
./create-placement.sh
./create-namespace.sh
./create-m3msg-topic.sh
```


