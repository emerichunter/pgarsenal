
-- Statements distribution
SELECT
 d.datname::text,
 case when
   (tup_returned + tup_inserted + tup_updated + tup_deleted) > 0
 then round(1000000.0 * tup_returned / (tup_returned + tup_inserted + tup_updated + tup_deleted)) / 10000
 else 0
 end::numeric(1000, 4) as select_pct,

 case when (tup_returned + tup_inserted + tup_updated + tup_deleted) > 0
 then
 round(1000000.0 * tup_inserted / (tup_returned + tup_inserted + tup_updated + tup_deleted)) / 10000
 else 0
 end::numeric(1000, 4) as insert_pct ,

 case when (tup_returned + tup_inserted + tup_updated + tup_deleted) > 0
 then
 round(1000000.0 * tup_updated / (tup_returned + tup_inserted + tup_updated + tup_deleted)) / 10000
 else 0
 end::numeric(1000, 4) as update_pct,

 case when (tup_returned + tup_inserted + tup_updated + tup_deleted) > 0
 then round(1000000.0 * tup_deleted / (tup_returned + tup_inserted + tup_updated + tup_deleted)) / 10000
 else 0
 end::numeric(1000, 4) as delete_pct
from
  pg_stat_database d
right join
  pg_database on d.datname=pg_database.datname
where
  not datistemplate and d.datname != 'postgres';

