# pg_perfavisor (rather a pg_bufferforensic ) 
=================


## Buffers
Run `extensions_needed.sql` first on every database needed

A full report is given by 
`./report_buffercache.sh`

Don't forget to give the script proper rights.

In simple and quick scripts, you may use : 

`buffercache_summary.sql` for determining if you have a lot of clean/dirty cache and how much of which tables are cached

`top10_buffers.sql` gives the table most found in cache (tables with most traffic)


`shared_buffers_gsmith.sql` is more nuanced as it prints out buffers by group.
It also differenciates them between clean and dirty

## Analyze, Vacuum and statistics
`last_analyze_vacuum.sql` tells you which tables never had vacuum or analyze (auto or manual)


## Raw statistics from BGWRITER
`bgwriter_vs_chkpt_snapshots.sql` is for creating and monitoring snapshots of pg_stat_bgwriter view raw data. 
This means buffer, background writer, and checkpoint activity.
Go check `/pg_bgwritercollector` for aggregates and human readable output.




TO DO : 
- improve report_buffercache.sh and fix bugs
- log evolution throuhout time of shared_buffers_gsmith.sql for graphing

