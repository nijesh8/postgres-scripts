                  SELECT dblink_connect('conn_db_link','server_patronidemo2_1_remote') ;
                  INSERT INTO LAG_STATS (SELECT * from dblink('conn_db_link', 'select sender_host, 
                        slot_name, status, written_lsn, flushed_lsn, 
                                                   last_msg_send_time, last_msg_receipt_time, latest_end_lsn, latest_end_time, 
                                                   pg_wal_lsn_diff(pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn()), 
                                                   pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn(), 
                                                   pg_last_xact_replay_timestamp() from pg_stat_wal_receiver')  
                                                AS x(           
                                                        sender_host   text,     
                                                        slot_name     text,     
                                                        status        text,     
                                                        written_lsn   pg_lsn,   
                                                        flushed_lsn   pg_lsn,   
                                                        last_msg_send_time          timestamp with time zone,   
                                                        last_msg_receipt_time   timestamp with time zone,       
                                                        latest_end_lsn      pg_lsn,                                             
                                                        latest_end_time     timestamp with time zone,           
                                                        pg_wal_lsn_diff     int,                                                        
                                                        pg_last_wal_receive_lsn     pg_lsn,                             
                                                        pg_last_wal_replay_lsn      pg_lsn,                             
                                                        pg_last_xact_replay_timestamp timestamp with time zone)) ;
                  SELECT dblink_disconnect('conn_db_link') ;
