CREATE OR REPLACE VIEW report_mostfullscaned
AS 
SELECT pg_sut.relname as nom_table, seq_scan, COALESCE(seq_tup_read,0) as fullscan_tuples,
                COALESCE(idx_scan,0) as idx_scan, COALESCE(idx_tup_fetch,0) as idxscan_tuples,
                COALESCE(ROUND((seq_scan*1.0)/(NULLIF(idx_scan,0)*1.0),2),0) as ratio_scan,
                COALESCE(ROUND((seq_tup_read*1.0)/(NULLIF(idx_tup_fetch,0)*1.0),2),0) as ratio_tup,
                (COALESCE(float4(seq_tup_read),0)*1.0/(NULLIF(pg_c.reltuples,0)*1.0)) as ratio_tot_seq,
                (COALESCE(float4(idx_tup_fetch),0)*1.0/(NULLIF(pg_c.reltuples,0)*1.0)) as ratio_tot_idx,
                COALESCE(pg_c.reltuples,0) as est_tuple,
                greatest(last_autoanalyze, last_analyze) as last_analyze
        FROM pg_stat_user_tables pg_sut, pg_class pg_c
        WHERE pg_sut.relname = pg_c.relname
        AND ( seq_tup_read > 3*pg_c.reltuples
        OR idx_scan < 100*seq_scan)
        AND pg_c.reltuples >500
        AND seq_tup_read <> 0
        AND seq_tup_read IS NOT NULL
        AND ((COALESCE(float4(idx_tup_fetch),0)*1.0/(NULLIF(pg_c.reltuples,0)*1.0)) >0.01
        OR  COALESCE(ROUND((seq_tup_read*1.0)/(NULLIF(idx_tup_fetch,0)*1.0),2),0)> 0.01)
        AND seq_scan <> (date_part('day', now()) - date_part('day', GREATEST(last_analyze,last_autoanalyze )))+1
        ORDER BY seq_scan DESC
        ;

