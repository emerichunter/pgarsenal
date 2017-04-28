SELECT pg_size_pretty(count(*) * 8192) as ideal_shared_buffers 
 
FROM pg_class c 
 
INNER JOIN pg_buffercache b ON b.relfilenode = c.relfilenode 
 
INNER JOIN pg_database d ON (b.reldatabase = d.oid AND d.datname = current_database()) 
 
WHERE usagecount >= 3;