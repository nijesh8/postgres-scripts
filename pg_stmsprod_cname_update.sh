#!/bin/bash 

export PGVERSION=16
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/16/bin
export PATRONI_SCOPE=stmsprod
export PATRONI_ZOOKEEPER_HOSTS='zookeeper-stms-fss-lvs-1.postgresdba-prod.svc.134.tess.io','zookeeper-stms-fss-slc-2.postgresdba-prod.svc.137.tess.io','zookeeper-stms-fss-slc-3.postgresdba-prod.svc.137.tess.io'
export LOG_FILE=/tmp/post_failover.txt
export db_vip=pgstmsprod.db.ebay.com

export leader_host=`patronictl list | grep "Leader" | cut -d"|" -f3 | awk '{print $NF}'`
export v=`host ${leader_host} | awk '{print $NF}'`
export leader_svc=${v::-1}

/usr/local/bin/patronictl list ${PATRONI_SCOPE}    >> ${LOG_FILE}


date >> ${LOG_FILE}
curl -k -X POST -H "Authorization: cqX0sEAAaznsrYMm9eNywjo/isM6y0Fd4XyaQGfG9Dh46c4uN4ZnhQMeddJSpLGYn3rQOl3B7bw=" -H "Content-Type: application/x-www-form-urlencoded" -d "dns=${db_vip}&cname=${leader_svc}"   https://dbinabox.vip.ebay.com/udns/api/update/cname/update >> ${LOG_FILE} 2>&1

sleep 5
nslookup ${db_vip} >> ${LOG_FILE}
date >> ${LOG_FILE}

/usr/local/bin/patronictl list ${PATRONI_SCOPE}    >> ${LOG_FILE}
/usr/local/bin/patronictl history ${PATRONI_SCOPE} >> ${LOG_FILE}

curl -s http://localhost:8008/cluster|jq >> ${LOG_FILE}
date >> ${LOG_FILE}

