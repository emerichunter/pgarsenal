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





