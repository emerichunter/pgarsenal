-- Checks last analyze, vacuum, autovacuum, autoanalyze from all tables in the cluster

select 
       relname, 
       last_vacuum, 
       last_autovacuum, 
       last_analyze, 
       last_autoanalyze 
from pg_stat_all_tables 
order by last_vacuum desc NULLS FIRST,last_analyze desc;
