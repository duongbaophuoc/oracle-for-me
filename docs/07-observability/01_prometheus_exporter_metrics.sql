-- Custom Metrics for oracledb_exporter

-- 1. Transactions Per Second (TPS)
SELECT 'oracle_tps' as name, value 
FROM v$sysmetric 
WHERE metric_name = 'User Transaction Per Sec' AND group_id = 2;

-- 2. Buffer Cache Hit Ratio
SELECT 'oracle_buffer_cache_hit_ratio' as name, value
FROM v$sysmetric
WHERE metric_name = 'Buffer Cache Hit Ratio' AND group_id = 2;

-- 3. Redo Log Space Wait Time
SELECT 'oracle_redo_log_space_wait_ms' as name, time_waited
FROM v$system_event WHERE event = 'log file space wait';