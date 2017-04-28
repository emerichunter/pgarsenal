INSERT INTO sharedbuffers_usage (time, buffersize) 
SELECT current_timestamp, count(*) * 8192 as buffersize

FROM pg_class c

INNER JOIN pg_buffercache b ON b.relfilenode = c.relfilenode

INNER JOIN pg_database d ON (b.reldatabase = d.oid AND d.datname = current_database())

WHERE usagecount >= 3;

