# pg_bgwritercollector

=========================


Collects stats from pg_stat_bgwriter 

`./bgwriter_gsmith.sh databasename` gives off statistics on how data is mostly written bgwriter, backend or checkpoints

`./collectwrites_gsmith.sh databasename` is more detailed in snapshots to collect over time

TODO: 
- create tables and collect stats over time from `collectwrites_gsmith.sh databasename`
