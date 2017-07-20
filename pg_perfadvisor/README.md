# pg_perfavisor (pg_perfmonitor) 
=================

Run `extensions_needed.sql` first on every database needed

A full report is given by 
`./report_buffercache.sh`

Don't forget to give the script proper rights

`top10_buffers.sql` gives the table most found in cache (tables with most traffic)

`last_analyze_vacuum.sql` tells you which tables never had vacuum or analyze (auto or manual)

`bgwriter_vs_chkpt_snapshots.sql` is for creating and monitoring snapshots of pg_stat_bgwriter view raw data. 
This means buffer, background writer, and checkpoint activity.
Go check `/pg_bgwritercollector` for aggregates and human readable output.

`shared_buffers_gsmith.sql` is more nuanced as it prints out buffers by group.
It also differenciates them between clean and dirty


TO DO : 
- improve report_buffercache.sh and fix bugs
- log evolution throuhout time of shared_buffers_gsmith.sql
