-- ==============================================================================
-- Stage 3: Performance Engineering - AWR & ASH Diagnostics
-- Giai đoạn 3: Kỹ thuật Hiệu suất - Chẩn đoán AWR & ASH
-- ==============================================================================

-- AWR (Automatic Workload Repository) takes snapshots of the database every hour.
-- To diagnose a performance issue that happened between 2 PM and 3 PM yesterday,
-- you generate an AWR report comparing the 2 PM snapshot and the 3 PM snapshot.
-- (AWR chụp lại toàn bộ hệ thống mỗi giờ. Để chẩn đoán lỗi lúc 2-3h chiều qua, bạn so sánh 2 snapshot đó).

-- 1. Find the Snapshots for yesterday
SELECT 
    snap_id, 
    begin_interval_time, 
    end_interval_time 
FROM 
    dba_hist_snapshot 
ORDER BY 
    snap_id DESC;

-- 2. Generate the Report (Typically run via SQL*Plus)
-- @$ORACLE_HOME/rdbms/admin/awrrpt.sql
-- You input the Start Snap ID and End Snap ID. It generates an HTML report.

-- ==============================================================================
-- ASH (Active Session History)
-- While AWR is an hourly summary, ASH samples every ACTIVE session every 1 second.
-- It is the ultimate tool for diagnosing micro-spikes and transient lock issues.
-- (ASH lấy mẫu mọi phiên ĐANG HOẠT ĐỘNG mỗi 1 giây. Đây là công cụ tối thượng để chẩn đoán các lỗi giật lag chớp nhoáng).

-- Find what the database was waiting on the most in the last 15 minutes:
-- (Tìm xem CSDL đang chờ đợi điều gì nhiều nhất trong 15 phút qua)
SELECT 
    event, 
    COUNT(*) AS total_wait_seconds
FROM 
    v$active_session_history
WHERE 
    sample_time > SYSDATE - 15/1440
    AND session_state = 'WAITING'
GROUP BY 
    event
ORDER BY 
    total_wait_seconds DESC;

-- Find which SQL statement was burning the most CPU in the last hour:
-- (Tìm câu lệnh SQL ngốn nhiều CPU nhất trong giờ qua)
SELECT 
    sql_id, 
    COUNT(*) AS cpu_seconds
FROM 
    v$active_session_history
WHERE 
    sample_time > SYSDATE - 1/24
    AND session_state = 'ON CPU'
GROUP BY 
    sql_id
ORDER BY 
    cpu_seconds DESC
FETCH FIRST 5 ROWS ONLY;

-- Once you have the sql_id, you can pull its text:
-- SELECT sql_text FROM v$sql WHERE sql_id = 'your_sql_id';
