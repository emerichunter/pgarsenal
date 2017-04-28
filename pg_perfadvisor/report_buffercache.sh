#!/bin/bash -x

# Shell script to run some queries against a pgbench 
# database and execute sample buffer cache queries
# showing what's inside afterwards

DBNAME="pgbench"

# Run a benchmark to put some typical data in the buffer cache
#pgbench -S -c 8 -t 25000 $DBNAME

# Print basic configuration information
psql -d $DBNAME -c "
SELECT 
  setting AS shared_buffers
  pg_size_pretty(8192 * setting::integer) AS size 
FROM pg_settings WHERE name='shared_buffers'
"
psql -d $DBNAME -c "
SELECT pg_size_pretty(count(*) * 8192) as advised_minimum_shared_buffers
 FROM pg_class c
 INNER JOIN pg_buffercache b ON b.relfilenode = c.relfilenode
 INNER JOIN pg_database d ON (b.reldatabase = d.oid AND d.datname = current_database())
 WHERE usagecount >= 3;
"


psql -d $DBNAME -c "
SELECT pg_size_pretty(pg_database_size(current_database())) AS current_database_size
"


# Top 10, from the pg_buffercache README:
psql -d $DBNAME -c "
SELECT
  c.relname,
  count(*) AS buffers
FROM pg_class c 
  INNER JOIN pg_buffercache b
    ON b.relfilenode=c.relfilenode 
  INNER JOIN pg_database d
    ON (b.reldatabase=d.oid AND d.datname=current_database())
GROUP BY c.relname
ORDER BY 2 DESC
LIMIT 10
"

# Simple breakdown by usage count
psql -d $DBNAME -c "
SELECT 
  usagecount,count(*),isdirty
FROM pg_buffercache 
GROUP BY isdirty,usagecount 
ORDER BY isdirty,usagecount
"

# Buffer contents summary, with percentages
psql -d $DBNAME -c "
SELECT 
  c.relname,
  pg_size_pretty(count(*) * 8192) as buffered,
  round(100.0 * count(*) / 
    (SELECT setting FROM pg_settings WHERE name='shared_buffers')::integer,1) 
    AS buffers_percent,
  round(100.0 * count(*) * 8192 / pg_relation_size(c.oid),1) 
    AS percent_of_relation
FROM pg_class c
  INNER JOIN pg_buffercache b 
    ON b.relfilenode = c.relfilenode
  INNER JOIN pg_database d
    ON (b.reldatabase = d.oid AND d.datname = current_database())
GROUP BY c.oid,c.relname
ORDER BY 3 DESC
LIMIT 10
"

# Buffer usage count distribution
psql -d $DBNAME -c "
SELECT
  c.relname, count(*) AS buffers,usagecount
FROM pg_class c
  INNER JOIN pg_buffercache b 
    ON b.relfilenode = c.relfilenode
  INNER JOIN pg_database d
    ON (b.reldatabase = d.oid AND d.datname = current_database())
GROUP BY c.relname,usagecount
ORDER BY c.relname,usagecount
"

