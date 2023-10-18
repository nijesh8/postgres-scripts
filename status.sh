while(true) ; do date ; psql -h 172.17.0.2 -p 5000 -d postgres -U testuser -f status.sql | tee -a status.log  ; sleep 0.5 ; date  ; done
