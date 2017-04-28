\echo INDEX FULL REPORT 
\echo  
\echo Summary
\i indexsummary.sql
\echo  
\echo ==============================================================
\echo  
\echo Most Full Scans 

\i idx_mostfullscans.sql

\echo  
\echo ==============================================================
\echo INDEX USAGE
\echo  
\i indexusage.sql

\echo  
\echo ==============================================================
\echo UNUSED INDEXES
\echo  
\i unusedindexes.sql

\echo  
\echo ==============================================================
\echo  
\echo DUPLICATE INDEXES
\echo  
\i duplicateindexes.sql

\echo  
\echo ==============================================================
\echo  
\echo INDEXES READING TOO MANY TUPLES
\echo  
\i idx_wtoomanylines.sql

\echo  
\echo ==============================================================
\echo  
\echo REDUNDANT INDEXES (COLUMNS IN COMMON)
\echo  
\i redundantindexes.sql


\echo  
\echo ==============================================================
\echo END OF REPORT
