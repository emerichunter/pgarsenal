# About pgarsenal
==================


pgarsenal is a basic set of view and SQL statements for different purposes of maintenance and auditing : 
managing indexes (missing or useless indexes), bloating, performance, security, replication and so on.

It is a basis for a larger tool pgtoolbox (like pt-toolkit or oak-toolkit) for MySQL (and its forks)

 
# pg_idxmgr 
============

Either use the views or SQL. 

	psql -d mydatabase -f nameOfScript.sql

for a one shot report

or

	psql -d mydatabase -f vue_nameOfScript.sql

for a built-in view in your Postgres instance

You can also use complete_idxreport.sh like this for complete audit on the fly :
	
	psql -d mydatabase -f complete_idxreport.sh


# pg_checksettings 
============

Check for settings in pg_settings view in your instance that are different from default


# pg_sizes 
============

Finding databases sizes (like \l+), biggest relations by size, biggest total relation size (data+index), approximation of bloat from check_postgres

Needs an exact bloat count with pg_stattuples and script

# pg_perfavisor 
============

EXTENSIONS NEEDED pg_buffercache & pg_stattuples

Help for analyzing buffer caching.


# pg_stat_statements
===============




-- SQL statements with the greatest I/O consumption
-- Run the following command to list the top five SQL statements which consume the most I/O resources in one call. 

    select 'Top 5 I/O consuming queries in 1 call' as "Top 5 I/O consuming queries in 1 call"; 
    select userid::regrole,pgd.datname, (blk_read_time+blk_write_time)/calls as ios_per_call, query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid
    order by (blk_read_time+blk_write_time)/calls 
    desc limit 5;

-- Run the following command to list the top five SQL statements which consume the most I/O resources in total.

    select 'Top 5 I/O consuming queries in total' as "I/O total"; 
    select userid::regrole, datname, (blk_read_time+blk_write_time) as total_ios, query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid
    order by (blk_read_time+blk_write_time) desc limit 5;

-- SQL statements with the greatest time consumption
-- Run the following command to list the top five SQL statements which consume the most time in one call.

    select 'Top 5 average time consuming queries in 1 call' as "Most time consuming single call"; 
    select userid::regrole, datname, mean_time, query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid 
    order by mean_time desc limit 5;

-- Run the following command to list the top five SQL statements which consume the most time in total.

    select 'Top 5 time consuming queries in total' as "Most time consuming total"; 
    select userid::regrole, datname, total_time, query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid 
    order by total_time desc limit 5;

-- Run the following command to list the top five SQL statements which consume the most time in total and have the most calls.

    select 'Top 5 time consuming queries in total with the most calls' as "Most time consuming with most calls"; 
    select userid::regrole, datname, query, total_time, calls 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid 
    order by total_time desc,calls desc limit 5;

-- SQL statements with the most severe response jitter
-- Run the following command to list the top five SQL statements with the most severe response jitter.

    select 'Top 5 inconsistent time queries ' as "Inconsistent timing"; 
    select userid::regrole, datname, stddev_time as jitter, query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid
    order by stddev_time desc limit 5;

-- SQL statements with the greatest consumption of shared memory
-- Run the following command to list the top five SQL statements which consume the most shared memory resources.

    select 'Top 5 shared memory consuming queries' as "Memory usage" ; 
    select userid::regrole, datname, pg_size_pretty((shared_blks_hit+shared_blks_dirtied)*8) as memory_usage, query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid
    order by (shared_blks_hit+shared_blks_dirtied) desc limit 5;

-- SQL statements with the greatest consumption of temporary space
-- Run the following command to list the top five SQL statements which consume the most temporary space.

    select 'Top 5 temporary space consuming queries' as "Temp files"; 
    select userid::regrole, datname, temp_blks_written, pg_size_pretty(temp_blks_written*8) as temp_space_used,  query 
    from pg_stat_statements pgss
    join pg_database pgd ON pgd.oid = pgss.dbid
    order by temp_blks_written desc limit 5;


