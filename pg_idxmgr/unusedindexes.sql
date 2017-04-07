 SELECT pg_sui.relname, indexrelname, pg_c.reltuples ,pg_sui.idx_scan as idx_scan_count,  pg_sut.idx_scan as tot_idx_scan_table, pg_sut.seq_scan
        FROM pg_stat_user_indexes pg_sui, pg_class pg_c, pg_stat_user_tables pg_sut
        WHERE (pg_sui.idx_scan = 0 OR (pg_sut.idx_scan < seq_scan AND  pg_sui.idx_scan < seq_scan) )
        AND pg_sut.seq_scan <> 0
        AND pg_sui.relname = pg_c.relname
        AND pg_c.relname = pg_sut.relname
        AND pg_c.reltuples > 500
        AND seq_scan <> (date_part('day', now()) - date_part('day', GREATEST(last_analyze,last_autoanalyze )))+1
        ORDER BY relname
        ;

