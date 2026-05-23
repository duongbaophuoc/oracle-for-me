-- ==============================================================================
-- Stage 3: Oracle Internals - Memory Analysis (SGA & PGA)
-- Giai đoạn 3: Cấu trúc bên trong - Phân tích Bộ nhớ
-- ==============================================================================

-- 1. SGA (System Global Area) Overview
-- V$SGASTAT gives a detailed breakdown of where the shared memory is allocated.
-- (V$SGASTAT cung cấp chi tiết vùng nhớ chung đang được cấp phát ở đâu.)
SELECT 
    pool, 
    name, 
    bytes / 1024 / 1024 AS MB
FROM 
    v$sgastat
WHERE 
    pool IS NULL 
    OR pool IN ('shared pool', 'java pool', 'large pool')
ORDER BY 
    MB DESC
FETCH FIRST 20 ROWS ONLY;

-- Check the Database Buffer Cache (Vùng đệm dữ liệu)
-- A high Cache Hit Ratio (e.g., > 95%) means Oracle is successfully reading from RAM instead of Disk.
-- (Tỉ lệ Hit Ratio cao nghĩa là Oracle đọc dữ liệu từ RAM thành công thay vì phải xuống Đĩa.)
SELECT 
    name, 
    value 
FROM 
    v$sysstat 
WHERE 
    name IN ('physical reads', 'db block gets', 'consistent gets');

-- 2. PGA (Program Global Area) Overview
-- PGA is private memory for each user session.
-- (PGA là bộ nhớ riêng tư cho mỗi phiên người dùng.)
SELECT 
    name, 
    value / 1024 / 1024 AS MB
FROM 
    v$pgastat
WHERE 
    name IN (
        'aggregate PGA target parameter', 
        'total PGA allocated', 
        'maximum PGA allocated', 
        'over allocation count'
    );
    
-- Check active sessions using the most PGA memory right now
-- (Kiểm tra các phiên đang dùng nhiều PGA nhất hiện tại, thường là do đang chạy ORDER BY/HASH JOIN lớn)
SELECT 
    s.sid, 
    s.serial#, 
    s.username, 
    p.spid, 
    pm.allocated / 1024 / 1024 AS pga_allocated_mb
FROM 
    v$session s
JOIN 
    v$process p ON s.paddr = p.addr
JOIN 
    v$process_memory pm ON p.pid = pm.pid
WHERE 
    s.username IS NOT NULL
ORDER BY 
    pga_allocated_mb DESC;
