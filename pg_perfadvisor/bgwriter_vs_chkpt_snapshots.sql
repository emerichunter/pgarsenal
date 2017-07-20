-- CREATE UNLOGGED TABLE
-- Buffer, background writer, and checkpoint activity
/*
CREATE VIEW pg_stat_bgwriter AS
SELECT
    pg_stat_get_bgwriter_timed_checkpoints() AS checkpoints_timed,
    pg_stat_get_bgwriter_requested_checkpoints() AS checkpoints_req,
    pg_stat_get_bgwriter_buf_written_checkpoints() AS buffers_checkpoint,
    pg_stat_get_bgwriter_buf_written_clean() AS buffers_clean,
    pg_stat_get_bgwriter_maxwritten_clean() AS maxwritten_clean,
    pg_stat_get_buf_written_backend() AS buffers_backend,
    pg_stat_get_buf_alloc() AS buffers_alloc;

*/

CREATE UNLOGGED TABLE pg_stat_bgwriter_snapshot AS SELECT current_timestamp,* FROM pg_stat_bgwriter;

-- IF NEEDED
--delete from pg_stat_bgwriter_snapshot;

-- cron every hour, day or any relevant timeframe depending on traffic
INSERT INTO pg_stat_bgwriter_snapshot (SELECT current_timestamp,* FROM pg_stat_bgwriter);

SELECT
    cast(date_trunc('minute',start) AS timestamp) AS start,
    date_trunc('second',elapsed) AS elapsed,
    date_trunc('second',elapsed / (checkpoints_timed + checkpoints_req)) AS avg_checkpoint_interval,
    (100 * checkpoints_req) / (checkpoints_timed + checkpoints_req) AS checkpoints_req_pct,
    100 * buffers_checkpoint / (buffers_checkpoint + buffers_clean + buffers_backend) AS checkpoint_write_pct,
    100 * buffers_backend / (buffers_checkpoint + buffers_clean + buffers_backend) AS backend_write_pct,
    pg_size_pretty(buffers_checkpoint * block_size / (checkpoints_timed + checkpoints_req)) AS avg_checkpoint_write,
    pg_size_pretty(cast(block_size * (buffers_checkpoint + buffers_clean + buffers_backend) / extract(epoch FROM elapsed) AS int8)) AS written_per_sec,
    pg_size_pretty(cast(block_size * (buffers_alloc) / extract(epoch FROM elapsed) AS int8)) AS alloc_per_sec
FROM
(
    SELECT
        one.now AS start,
        two.now - one.now AS elapsed,
        two.checkpoints_timed - one.checkpoints_timed AS checkpoints_timed,
        two.checkpoints_req - one.checkpoints_req AS checkpoints_req,
        two.buffers_checkpoint - one.buffers_checkpoint AS buffers_checkpoint,
        two.buffers_clean - one.buffers_clean AS buffers_clean,
        two.maxwritten_clean - one.maxwritten_clean AS maxwritten_clean,
        two.buffers_backend - one.buffers_backend AS buffers_backend,
        two.buffers_alloc - one.buffers_alloc AS buffers_alloc,
        (SELECT cast(current_setting('block_size') AS integer)) AS block_size
    FROM pg_stat_bgwriter_snapshot one
        INNER JOIN pg_stat_bgwriter_snapshot two
    ON two.now > one.now
) bgwriter_diff
WHERE (checkpoints_timed + checkpoints_req) > 0;

