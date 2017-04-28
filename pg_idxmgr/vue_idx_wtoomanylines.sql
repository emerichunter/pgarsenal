CREATE OR REPLACE VIEW report_idx_wtoomanylines 
AS 
SELECT pg_sui.relname, indexrelname, idx_scan, idx_tup_read, idx_tup_fetch, pg_c.reltuples as nb_lignes_table,
                        idx_tup_read/pg_c.reltuples/idx_scan as tx_efficacite,
                        idx_tup_read/idx_scan*100 as tx_scan_read,
                        idx_tup_fetch/idx_scan*100 as tx_scan_fetch
                FROM pg_stat_user_indexes pg_sui, pg_class pg_c
                WHERE pg_c.relname = pg_sui.relname
                AND idx_scan <> 0
                AND idx_tup_read/pg_c.reltuples/idx_scan  > 0.5
                GROUP BY pg_sui.relname, indexrelname, idx_scan, idx_tup_read, idx_tup_fetch, idx_tup_fetch/idx_scan*100, pg_c.reltuples
                HAVING (idx_tup_read/idx_scan> 1)
                --ORDER BY idx_scan DESC
                ORDER BY idx_tup_read/idx_scan*100 DESC
                 ;


