#!/usr/bin/python3
############################### HAtester.py #####################################
#     Version 2.2    Jobin Augustine, Fernando Laudares Camargos (2017-2021)
#
# Program to test reads and writes in a PostgreSQL server, including
# connection retry on connection failure to test load-balancing capabilities
# 

# PREREQUISITES
# 1) PostgreSQL Python connector python3-psycopg2
# 2) Target table HATEST must have been created in advance:
#    CREATE TABLE HATEST (TM TIMESTAMP);
#    CREATE UNIQUE INDEX idx_hatext ON hatest (tm desc);
# 3) Monitor replication using : SELECT tm FROM hatest ORDER BY tm DESC LIMIT 1; 

import sys

# CONNECTION DETAILS
# host = "localhost"
host="haproxy-pgzktest1-sts-svc.postgresdba-stg.svc.130.tess.io"
dbname = "postgres"
user = "postgres"
password = "zalando"
connect_timeout = 5
# Port number can be optionally provided as first argument
if len(sys.argv)>1 and int(sys.argv[1]):
  port = int(sys.argv[1])
else:
  port = 5432

# Connection string
connectionString = "host=%s port=%i dbname=%s user=%s password=%s connect_timeout=%i" % (host, port, dbname, user, password, connect_timeout)

# Execute Insert statement against table if doDML is true.
# create a table in advance: 
doDML = True

# USAGE 
#
# - Execution:
#    ./HAtester.py <port>
#
# - Reconnection:
#    Ctrl+C will trigger a new connection to test load balancing.
#
# - Stop execution:
#    Ctrl+Z to pause the job, then terminate it with: kill %<job_id>
#
###############################################################################

import sys,time,psycopg2
def create_conn():
   try:
      conn = psycopg2.connect(connectionString)
   except psycopg2.Error as e:
      print("Unable to connect to database :")
      print(e)
      sys.exit(1)
   return conn

if __name__ == "__main__":
   conn = create_conn()
   if conn is not None:
      cur = conn.cursor()
      while True:
         try:
            # time.sleep(0.1)
            time.sleep(0.5)
            if conn is not None:
               cur = conn.cursor()
            else:
               raise Exception("Connection not ready")
            #Check connected to master or Slave
            ## cur.execute("select pg_is_in_recovery(),inet_server_addr()")
            cur.execute("select pg_is_in_recovery(),inet_server_addr(),replace( pg_read_file('/etc/hostname'), E'\n','')")
            rows = cur.fetchone()
            if (rows[0] == False):
               print (" Working with:   MASTER - [" + rows[1] + "] - " + rows[2] + "\n")
               cur.execute("SELECT setting from pg_settings where name = 'synchronous_standby_names'")
               rows = cur.fetchone()
               print ("synchronous_standby_names value is: %s" % rows[0]),
               print (" -------------------------------------------------------")
               if doDML:
                  colo = 'lvs'
                  ## cur.execute("INSERT INTO HATEST VALUES(CURRENT_TIMESTAMP, '" + colo + "') RETURNING TM")
                  cur.execute("INSERT INTO HATEST VALUES(CURRENT_TIMESTAMP, '" + colo + "') RETURNING TM, colo")
                  if cur.rowcount == 1 :
                     ## tmrow = str(cur.fetchone()[0])
                     tmrow = cur.fetchone()
                     inserted_row_tm = str(tmrow[0])
                     colo_inserted = str(tmrow[1])
                     ## print ('  Inserted into HATEST: %s\n' % tmrow)
                     print ("  Inserted into HATEST: " + inserted_row_tm  + " === COLO: " + colo_inserted + '\n')
                     cur.execute("select tm, colo from HATEST where tm = (select max(tm) from HATEST)")
                     rowsx = cur.fetchone()
                     print ("MAX data is " + str(rowsx[0]) + ' === COLO: ' + str(rowsx[1]) + '\n')
                  cur.execute("INSERT INTO lag_stats_from_primary (usename       , application_name , client_addr, client_hostname  , client_port, \
                                  backend_start , backend_xmin     , state  , \
                                  sent_lsn      , write_lsn        , flush_lsn  , replay_lsn       , \
                                  write_lag     , flush_lag        , replay_lag , \
                                  sync_priority , sync_state       , reply_time, creation_date) (Select usename       , \
                                  application_name , client_addr, client_hostname  , client_port, \
                                  backend_start , backend_xmin     , state  , \
                                  sent_lsn      , write_lsn        , flush_lsn  , replay_lsn       , \
                                  write_lag     , flush_lag        , replay_lag , \
                                  sync_priority , sync_state       , reply_time , now()     from pg_stat_replication )")
                  cur.execute("INSERT INTO sync_status 	    (select application_name, sync_state, now() from pg_stat_replication ) ")
                  cur.execute("INSERT INTO sync_names_status (select setting, now() from pg_settings where name = 'synchronous_standby_names' ) ")
                  conn.commit()
               else:
                  print ("No Attempt to insert data")
            else:
               cur.execute("select a.slot_name, b.log_delay from pg_stat_wal_receiver a , (SELECT CASE WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() \
                            THEN 0 \
                            ELSE EXTRACT (EPOCH FROM now() - pg_last_xact_replay_timestamp()) \
                            END AS log_delay) b " )
               rows = cur.fetchone()
               ## print (" Working with:    REPLICA - %s" % rows[1]),
               print (" Working with:    REPLICA - %s" % rows[0]),
               ## print (" LAG is:  %s" % rows[1]) ## Nijesh 1/9/2022 - Getting Negative values - receive_LSN is LESS than REPLAY_lsn -- How come ??? 
               if doDML:
                  # print ('Max Inserted TimeStamp from HATEST table is: ')
                  # cur.execute("SELECT MAX(TM) FROM HATEST")
                  cur.execute("select tm, colo from HATEST where tm = (select max(tm) from HATEST)")
                  row = cur.fetchone()
                  # print ("     Retrived: %s\n" % str(row[0]))
                  # print ("Max Inserted TimeStamp from HATEST table Retrived: %s\n" % str(row[0]))
                  print ("MAX Inserted TimeStamp from HATEST table Retrived: " + str(row[0]) + ' === COLO: ' + str(row[1]) + '\n')
               else:
                  print ("No Attempt to retrive data")

         except:
            print ("Trying to connect")
            if conn is not None:
               conn.close()
            conn = create_conn()
            if conn is not None:
                 cur = conn.cursor()

   conn.close()



