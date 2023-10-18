

pg_repack

-- pg_repack is a PostgreSQL extension which lets you remove bloat from tables and indexes, and 
-- optionally restore the physical order of clustered indexes. 
-- Unlike CLUSTER and VACUUM FULL it works online, without holding 
-- an exclusive lock on the processed tables during processing. 
-- pg_repack is efficient to boot, with performance comparable to using CLUSTER directly.
-- https://reorg.github.io/pg_repack/


--  The postgres_fdw module enables you to use a Foreign Data Wrapper to access tables on remote Postgres servers (hence the name "fdw"). 
-- A Foreign Data Wrapper lets you create proxies for data stored in other Postgres databases, 
-- so that they may be queried as if they were coming from a table in the current database.
-- https://www.timescale.com/blog/top-5-postgresql-extensions/

CREATE EXTENSION postgres_fdw ;

