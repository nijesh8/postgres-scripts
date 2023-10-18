while(true) ; 
do  
	sleep 2 ; 
	echo ============================= ; 
	tail -40 $PGDATA/log/postgresql.log | egrep -v 'host=\[local\]|application_name=psql'; 
	echo ; echo "Time now : " `date`; echo ;
	ls -tlr $PGDATA/standby.signal ; echo ;
	psql -c "select application_name, sync_state, sync_priority from pg_stat_replication" 
	echo ; 
	psql << EOF
\! echo ; echo "Active Sessions"; echo
:activ
\! echo; echo "Sessions - START Times" ; echo 
:activ2
\c rtmspocdb rtmspoc_app
\! echo;
:ix_usage
\q   
EOF
echo
echo PROCESS LIST
ps -ef |grep rtmspoc_app | grep -v grep
done
