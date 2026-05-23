-- ==============================================================================
-- Stage 4: Data Guard - Switchover & Monitoring
-- Giai đoạn 4: Data Guard - Đảo vai trò & Giám sát
-- ==============================================================================

-- When Data Guard is running, it's crucial to monitor the "Lag".
-- Lag is how far behind the Standby database is compared to the Primary.
-- (Khi Data Guard chạy, cần phải giám sát độ trễ Lag để biết CSDL Dự phòng đang chậm hơn CSDL chính bao nhiêu).

-- 1. Check Data Guard Process Status (Run on Standby)
-- MRP0 (Managed Recovery Process) is the process applying the redo to the standby.
-- (MRP0 là tiến trình đang nạp redo log vào CSDL dự phòng).
SELECT 
    process, 
    status, 
    thread#, 
    sequence#, 
    block#, 
    blocks 
FROM 
    v$managed_standby 
WHERE 
    process LIKE 'MRP%';

-- 2. Check the Apply Lag (Run on Standby)
-- This tells you how old the data is on the standby database.
-- (Cho biết dữ liệu trên CSDL Dự phòng đang cũ bao nhiêu).
SELECT 
    name, 
    value, 
    time_computed 
FROM 
    v$dataguard_stats 
WHERE 
    name IN ('transport lag', 'apply lag');

-- ==============================================================================
-- SWITCHOVER PROCESS (Quy trình Đảo vai trò)
-- ==============================================================================

-- A switchover is a planned operation. Zero data loss is guaranteed.
-- (Đây là thao tác có kế hoạch, Đảm bảo KHÔNG mất dữ liệu).

-- Step 1: Using DGMGRL (Recommended way)
-- (Cách khuyên dùng qua Broker)
-- DGMGRL> SWITCHOVER TO 'standby_db';

-- Step 2: Manual SQL Way (The old way)
-- (Cách thủ công bằng SQL)

-- On Primary:
-- Verify it can switch to standby:
SELECT switchover_status FROM v$database; -- Should return 'TO STANDBY'
-- Execute the switch:
ALTER DATABASE COMMIT TO SWITCHOVER TO PHYSICAL STANDBY WITH SESSION SHUTDOWN;
-- Restart the old primary:
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

-- On Standby:
-- Verify it can become primary:
SELECT switchover_status FROM v$database; -- Should return 'TO PRIMARY'
-- Execute the switch:
ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY WITH SESSION SHUTDOWN;
-- Open it for business:
ALTER DATABASE OPEN;
