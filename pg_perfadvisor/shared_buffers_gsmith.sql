
SELECT current_timestamp,
-- Split into 32 bins of data
round(bufferid / (cast((select setting from pg_settings where
name='shared_buffers') as int) / (32 - 1.0)))
as section, round(
-- Average usage count, capped at 5
case when avg(usagecount)>5 then 5 else avg(usagecount) end *
-- -1 when the majority are clean records, 1 when most are dirty
(case when sum(case when isdirty then 1 else -1 end)>0 then 1 else -1
end)) as color_intensity
FROM pg_buffercache GROUP BY
round(bufferid / (cast((select setting from pg_settings where
name='shared_buffers') as int) / (32 - 1.0)));