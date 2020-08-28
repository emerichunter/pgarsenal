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


SQL statements with the greatest I/O consumption

Run the following command to list the top five SQL statements which consume the most I/O resources in one call.

    select userid::regrole, dbid, query from pg_stat_statements order by (blk_read_time+blk_write_time)/calls desc limit 5;

Run the following command to list the top five SQL statements which consume the most I/O resources in total.

    select userid::regrole, dbid, query from pg_stat_statements order by (blk_read_time+blk_write_time) desc limit 5;

SQL statements with the greatest time consumption

Run the following command to list the top five SQL statements which consume the most time in one call.

    select userid::regrole, dbid, query from pg_stat_statements order by mean_time desc limit 5;

Run the following command to list the top five SQL statements which consume the most time in total.

    select userid::regrole, dbid, query from pg_stat_statements order by total_time desc limit 5;

SQL statements with the most severe response jitter

Run the following command to list the top five SQL statements with the most severe response jitter.

    select userid::regrole, dbid, query from pg_stat_statements order by stddev_time desc limit 5;

SQL statements with the greatest consumption of shared memory

Run the following command to list the top five SQL statements which consume the most shared memory resources.

    select userid::regrole, dbid, query from pg_stat_statements order by (shared_blks_hit+shared_blks_dirtied) desc limit 5;

SQL statements with the greatest consumption of temporary space

Run the following command to list the top five SQL statements which consume the most temporary space.

    select userid::regrole, dbid, query from pg_stat_statements order by temp_blks_written desc limit 5;

