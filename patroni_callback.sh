#!/bin/bash

export PGVERSION=15
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/15/bin
export PATRONI_SCOPE=stmsstg1
export PATRONI_ZOOKEEPER_HOSTS='zk10-fss-lvs-1.postgresdba-stg.svc.130.tess.io:2181','zk10-fss-slc-2.postgresdba-stg.svc.140.tess.io:2181','zk10-fss-slc-3.postgresdba-stg.svc.140.tess.io:2181'
export LOG_FILE=/tmp/post_failover.txt

date >> ${LOG_FILE}

/usr/local/bin/patronictl list ${PATRONI_SCOPE}    >> ${LOG_FILE}
/usr/local/bin/patronictl history ${PATRONI_SCOPE} >> ${LOG_FILE}

curl -s http://stmsstg1-fss-lvs-2.postgresdba-stg.svc.130.tess.io:8008/cluster|jq >> ${LOG_FILE}

date >> ${LOG_FILE}
