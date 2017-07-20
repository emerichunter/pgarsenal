#!/bin/bash
# collect_writes
#
# Collect data for tracking table writes
# Right now this just reports the data, without saving it the way collect_hotspot does
#
# Copyright 2013-2016 Gregory Smith gsmith@westnet.com

if [ -n "$1" ] ; then
    db="-d $1"
elif [ -n "${HPPTDATABASE}" ] ; then
    db="-d ${HPPTDATABASE}"
fi

# Totals per table
psql $db ${HPPTOPTS} -c "
SELECT
   current_timestamp as collected,
   TS.spcname tbl_space,
   nspname,
   relname,
   pg_stat_get_tuples_returned(C.oid) AS n_tup_read,
   pg_stat_get_tuples_inserted(C.oid) AS n_tup_ins,
   pg_stat_get_tuples_updated(C.oid) AS n_tup_upd,
   pg_stat_get_tuples_deleted(C.oid) AS n_tup_del,
   pg_stat_get_tuples_inserted(C.oid) + pg_stat_get_tuples_updated(C.oid) +
     pg_stat_get_tuples_deleted(C.oid) AS n_tup_write,
   round((pg_stat_get_tuples_inserted(C.oid) + pg_stat_get_tuples_updated(C.oid) +
     pg_stat_get_tuples_deleted(C.oid))::numeric * pg_total_relation_size(C.oid) /
    (pg_stat_get_live_tuples(C.oid) + pg_stat_get_dead_tuples(C.oid))) AS est_write_bytes,
   pg_total_relation_size(C.oid) AS size_raw,
   pg_size_pretty(pg_total_relation_size(C.oid)) AS size
FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  LEFT JOIN pg_tablespace TS ON (C.reltablespace = TS.oid)
  WHERE C.relkind IN ('r', 't')
    AND N.nspname NOT IN ('pg_catalog', 'information_schema') AND
    N.nspname !~ '^pg_toast'
    AND (pg_stat_get_live_tuples(C.oid) + pg_stat_get_dead_tuples(C.oid)) > 0
  ORDER BY 
   pg_stat_get_tuples_inserted(C.oid) + pg_stat_get_tuples_updated(C.oid) +
     pg_stat_get_tuples_deleted(C.oid) DESC
  LIMIT 20
"
# Per-second data per table
psql $db ${HPPTOPTS} -c "
SELECT
  collected,
  tbl_space,
  nspname,
  relname,
  round(n_tup_returned / sec_since_reset) AS returned_per_sec,
  round(n_tup_fetched / sec_since_reset) AS fetched_per_sec,
  round(n_tup_inserted / sec_since_reset) AS inserted_per_sec,
  round(n_tup_updated / sec_since_reset) AS updated_per_sec,
  round(n_tup_deleted / sec_since_reset) AS deleted_per_sec,
  round(n_tup_write / sec_since_reset) AS write_per_sec,
  round((n_tup_inserted + n_tup_updated +
     n_tup_deleted)::numeric * size_raw /
    (n_live_tup + n_dead_tup) / sec_since_reset) AS est_write_bytes,
  size_raw,
  size
FROM
(SELECT
   current_timestamp as collected,
   TS.spcname tbl_space,
   nspname,
   relname,
   pg_stat_get_tuples_returned(C.oid) AS n_tup_returned,
   pg_stat_get_tuples_fetched(C.oid) AS n_tup_fetched,
   pg_stat_get_tuples_inserted(C.oid) AS n_tup_inserted,
   pg_stat_get_tuples_updated(C.oid) AS n_tup_updated,
   pg_stat_get_tuples_deleted(C.oid) AS n_tup_deleted,
   pg_stat_get_tuples_inserted(C.oid) + pg_stat_get_tuples_updated(C.oid) +
     pg_stat_get_tuples_deleted(C.oid) AS n_tup_write,
   pg_stat_get_live_tuples(C.oid) AS n_live_tup,
   pg_stat_get_dead_tuples(C.oid) AS n_dead_tup,
   pg_total_relation_size(C.oid) AS size_raw,
   pg_size_pretty(pg_total_relation_size(C.oid)) AS size,
   (SELECT
     extract(epoch from (current_timestamp - stats_reset)) AS sec_since_reset
     FROM pg_stat_database WHERE datname=current_database()) AS sec_since_reset
FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  LEFT JOIN pg_tablespace TS ON (C.reltablespace = TS.oid)
  WHERE C.relkind IN ('r', 't')
    AND N.nspname NOT IN ('pg_catalog', 'information_schema') AND
    N.nspname !~ '^pg_toast'
    AND (pg_stat_get_live_tuples(C.oid) + pg_stat_get_dead_tuples(C.oid)) > 0
) AS s
  ORDER BY 
   n_tup_write DESC
--  LIMIT 20
;
"

# Database wide stats
psql $db ${HPPTOPTS} -x -c "
SELECT
  round(tup_returned / sec_since_reset) AS returned_per_sec,
  round(tup_fetched / sec_since_reset) AS fetched_per_sec,
  round(tup_inserted / sec_since_reset) AS inserted_per_sec,
  round(tup_updated / sec_since_reset) AS updated_per_sec,
  round(tup_deleted / sec_since_reset) AS deleted_per_sec,
  round(tup_write / sec_since_reset) AS write_per_sec,
  round((xact_commit + xact_rollback) / sec_since_reset) AS xacts_per_sec,
  round((xact_commit + xact_rollback) / tup_write) AS xacts_per_write
FROM
(
SELECT
  xact_commit,
  xact_rollback,
  tup_returned,
  tup_fetched,
  tup_inserted,
  tup_updated,
  tup_deleted,
  tup_inserted + tup_updated + tup_deleted as tup_write,
  extract(epoch from (current_timestamp - stats_reset)) AS sec_since_reset
FROM pg_stat_database
WHERE datname=current_database()
) d
;
"