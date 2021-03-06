-- tables candidate for autovacuum
-- shows tables which are near autovacuum threshold
-- a table above the thresahold and with a lot of activity could find it hard to autovacuum
-- you should then consider these tables for a little tuning of autovacuum

SELECT psut.relname,
     to_char(psut.last_vacuum, 'YYYY-MM-DD HH24:MI') as last_vacuum,
     to_char(psut.last_autovacuum, 'YYYY-MM-DD HH24:MI') as last_autovacuum,
     to_char(pg_class.reltuples,  '9G999G999G999')  AS n_tup,
     psut.n_dead_tup AS dead_tup,
     (CAST(current_setting('autovacuum_vacuum_threshold') AS bigint)
         + (CAST(current_setting('autovacuum_vacuum_scale_factor') AS numeric)
            * pg_class.reltuples)) AS av_threshold,
     CASE
         WHEN CAST(current_setting('autovacuum_vacuum_threshold') AS bigint)
             + (CAST(current_setting('autovacuum_vacuum_scale_factor') AS numeric)
                * pg_class.reltuples) < psut.n_dead_tup
         THEN '*'
         ELSE ''
     END AS expect_av
 FROM pg_stat_all_tables psut
     JOIN pg_class on psut.relid = pg_class.oid
ORDER BY  n_dead_tup DESC;
 
