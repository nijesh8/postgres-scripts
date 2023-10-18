\x auto 
select pg_is_in_recovery() ;
select application_name, sync_state, sync_priority, write_lag, flush_lag, replay_lag  from pg_stat_replication ;
select application_name, client_addr from pg_stat_activity ;
select * from pg_stat_wal_receiver ;
