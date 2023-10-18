while(true) ;
do
  sleep 2 ;
echo PROCESS LIST
ps -ef |grep citus | grep -v grep
  psql citus << EOF
\! echo ; echo "Active Sessions"; echo
:activ3
-- :ix_usage
select usename,  substr(application_name,1,15) "APP", client_addr, state, count(1) 
    from pg_stat_activity
    where usename not in ( 'standby' )
    group by usename, substr(application_name,1,15),  client_addr, state
order by count ;
\q
EOF
echo
done
