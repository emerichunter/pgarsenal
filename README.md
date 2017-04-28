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

