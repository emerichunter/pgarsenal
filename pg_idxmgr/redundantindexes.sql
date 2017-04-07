-- WORK IN PROGRESS
-- Finds indexes with columns in common in a table

-- Ajouter check pg_constraints


\echo " "
\echo " "
\echo "Candidates for redondant indexes"
\echo "==============================="


SELECT
DISTINCT
--DISTINCT ON (pi.indkey,pa.attname, pa.attnum) 
	pg.oid, 
	pg.relname AS table_name, 
--	pi.indrelid, 
	pi.indkey AS overlapping_columns,
--	pa.attrelid, 
	array_agg(pa.attname) AS columns_name,
	array_agg(pa.attnum) AS columns_ident,
--	pi.indnatts,
	pi.indisunique,
	pi.indisprimary,
	pi.indisclustered,
	pt.schemaname
	 
FROM pg_index pi 
JOIN pg_class pg ON pg.oid= pi.indrelid
JOIN pg_index pi2 ON pi2.indrelid = pi.indrelid
JOIN pg_attribute pa ON pa.attrelid = pg.oid  
JOIN pg_tables pt ON pt.tablename = pg.relname AND pt.schemaname<>'pg_catalog'
WHERE 
    pi.indkey && pi2.indkey
AND array_length(pi.indkey, 1) <> array_length(pi2.indkey, 1)
AND pa.attnum IN (SELECT unnest(pi2.indkey) FROM pg_index pi2 WHERE  pi2.indrelid = pi.indrelid )
AND NOT pi.indisclustered 
AND NOT pi.indisprimary
GROUP BY pg.oid,pg.relname,pi.indkey,pi.indisunique,pi.indisprimary,pi.indisclustered,pt.schemaname
ORDER BY pg.oid	 
; 
