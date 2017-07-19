DATABASE=$1
PORT=$2

echo --DATABASE--

psql -d $1 -p $2 -f databasesize.sql

echo --SQL USAGE--
psql -d $1 -p $2 -f sqlusage.sql

echo --COMPLETE SIZE-- 
psql -d $1 -p $2 -f complete_size_tables_top50.sql

echo --TOTAL REL SIZE--
psql -d $1 -p $2 -f totalrelationsize.sql

echo --BIGGEST REL--
psql -d $1 -p $2 -f biggestrelation.sql

echo --BLOAT APPROX--
psql -d $1 -p $2 -f bloatapprox.sql
