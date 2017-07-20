#!/bin/bash

if [ -n "$1" ] ; then
    db="-d $1"
elif [ -n "${HPPTDATABASE}" ] ; then
    db="-d ${HPPTDATABASE}"
fi

psql $db ${HPPTOPTS} -x -c "
SELECT
  now() AS collected,
  round(1000 * block_size::numeric * buffers_checkpoint / (1024 * 1024 * seconds)) / 1000 AS checkpoint_mbps,
  round(1000 * block_size::numeric * buffers_clean / (1024 * 1024 * seconds)) / 1000 AS clean_mbps,
  round(1000 * block_size::numeric * buffers_backend/ (1024 * 1024 * seconds)) / 1000 AS backend_mbps,
  round(1000 * block_size::numeric * (buffers_checkpoint + buffers_clean + buffers_backend) / (1024 * 1024 * seconds)) / 1000 AS total_write_mbps,
  round(1000 * block_size::numeric * buffers_alloc / (1024 * 1024 * seconds)) / 1000 AS alloc_mbps
FROM
(
SELECT
  now() AS sample,
  now() - stats_reset AS uptime,
  EXTRACT(EPOCH FROM now()) - extract(EPOCH FROM stats_reset) AS seconds,
  b.*,
  p.setting::integer AS block_size
FROM
  pg_stat_bgwriter b,
  pg_settings p
  WHERE p.name='block_size'
) bgw;
"