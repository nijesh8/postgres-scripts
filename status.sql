select application_name, count(*) from lag_stats_from_primary group by application_name ; select slot_name, count(*) from lag_stats_from_secondary group by slot_name ; select application_name, sync_state, sync_priority from pg_stat_replication ; show synchronous_standby_names ; select now();
insert into hatest_local (tm) values (now()) returning tm ;
