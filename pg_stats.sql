select psa.datname, psa.application_name, psa.client_addr, psa.query, psa.state from  pg_stat_activity psa where state = 'active'

select * from pg_statio_all_tables where schemaname = 'rtam1_poc_schema' order by heap_blks_hit desc


