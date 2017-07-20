-- Checks last analyze, vacuum, autovacuum, autoanalyze from database

select 
       relname, 
       last_vacuum, 
       last_autovacuum, 
       last_analyze, 
       last_autoanalyze 
from pg_stat_user_tables 
order by last_vacuum desc NULLS FIRST,last_analyze desc;
