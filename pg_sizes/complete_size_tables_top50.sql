--size with toast (top 50 for current database) ==--
-- This seems wrong, not MECE, because it adds index size to tables, but then shows indexes.

SELECT
  nspname as schemaname,
  c.relname::text,
  case
    when
      c.relkind='r'
    then
      'table'
    when
      c.relkind='i'
    then
      'index'
    else
      lower(c.relkind)
  end as "type",
  pg_size_pretty(pg_relation_size(c.oid)) as "size",
  pg_size_pretty
  (
   case when c.reltoastrelid > 0
   then
   pg_relation_size(c.reltoastrelid)
   else 0 end
   +
   case when t.reltoastidxid > 0
   then
   pg_relation_size(t.reltoastidxid)
   else 0 end
  ) as toast,
  pg_size_pretty(cast((
    SELECT
      coalesce(sum(pg_relation_size(i.indexrelid)), 0)
    FROM
      pg_index i
    WHERE
      i.indrelid = c.oid
  )
  as int8)) as associated_idx_size,
  pg_size_pretty(pg_total_relation_size(c.oid)) as "total"
FROM
 pg_class c
LEFT JOIN
 pg_namespace n ON (n.oid = c.relnamespace)
LEFT JOIN
  pg_class t on (c.reltoastrelid=t.oid)
WHERE
  nspname not in ('pg_catalog', 'information_schema') AND
  nspname !~ '^pg_toast' AND
  -- c.relkind in ('r','i')
  c.relkind in ('r')
ORDER BY
  pg_total_relation_size(c.oid) DESC
LIMIT
  100;
