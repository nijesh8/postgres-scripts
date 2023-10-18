psql -c "CREATE USER pmm_user WITH ENCRYPTED PASSWORD 'pmm_user'"

psql -c "GRANT pg_monitor to pmm_user"

psql -c "CREATE DATABASE pmm_user"

psql -d pmm_user -c "CREATE EXTENSION pg_stat_statements SCHEMA public"

psql -c "ALTER SYSTEM SET shared_preload_libraries TO 'pg_stat_statements'"

