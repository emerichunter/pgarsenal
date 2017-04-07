select pg.oid, pg.relname, pi.indrelid, pi.indkey from pg_index pi JOIN pg_class pg ON pg.oid= pi.indrelid ;
