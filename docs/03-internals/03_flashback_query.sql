-- ==============================================================================
-- Stage 3: Oracle Internals - Flashback Query & UNDO Health Checks
-- Giai đoạn 3: Cấu trúc bên trong - Truy vấn Quá khứ & Kiểm tra Bộ nhớ Hoàn tác
-- ==============================================================================

-- Problem: A junior developer accidentally executed:
-- UPDATE customers SET status = 'INACTIVE'; (Forgot the WHERE clause!)
-- (Vấn đề: Lập trình viên lỡ tay cập nhật toàn bộ bảng mà quên mệnh đề WHERE!)

-- ------------------------------------------------------------------------------
-- STEP 0: Enterprise Best Practice - Pre-flashback UNDO Verification
-- Before executing a flashback which might trigger the infamous ORA-01555 
-- (Snapshot too old), we must check the Undo retention configuration and current pressure.
--
-- (BƯỚC 0: Kinh nghiệm thực tế - Kiểm tra sức khỏe hệ thống UNDO
-- Trước khi chạy Flashback tránh lỗi ORA-01555 (Snapshot too old), ta phải kiểm tra tham số
-- cấu hình giữ lại dữ liệu Undo và áp lực tài nguyên ghi hiện tại của CSDL).
-- ------------------------------------------------------------------------------

-- 0.1 Check the configured minimum retention period in seconds (e.g. 900 for 15 minutes)
-- (Kiểm tra tham số cấu hình thời gian giữ dữ liệu Undo tối thiểu)
SHOW PARAMETER UNDO_RETENTION;

-- 0.2 Query actual historical max query length and retention capacity from V$UNDOSTAT
-- (Kiểm tra dung lượng lịch sử thực tế mà Undo segment có thể đáp ứng không gây lỗi ORA-01555)
SELECT 
    begin_time,
    end_time,
    tuned_undoretention AS "Max Undo Sustained (Sec)",
    maxquerylen AS "Max Query Duration (Sec)",
    nospaceerrcnt AS "OutOfSpace Errors Count"
FROM 
    v$undostat 
ORDER BY 
    begin_time DESC 
FETCH FIRST 10 ROWS ONLY;

-- 0.3 Verify Undo Tablespace allocation & active/expired/unexpired extents status
-- (Kiểm tra trạng thái sử dụng của Undo Tablespace - Active extents đang bận không thể ghi đè)
SELECT 
    tablespace_name,
    status,
    ROUND(SUM(bytes)/(1024*1024), 2) AS status_size_mb,
    COUNT(*) as extent_count
FROM 
    dba_undo_extents
GROUP BY 
    tablespace_name, status;

-- ------------------------------------------------------------------------------
-- STEP 1: Execute Flashback Recovery
-- ------------------------------------------------------------------------------

-- 1. View the data exactly as it was 15 minutes ago
-- (Chỉ tiến hành khi Max Undo Sustained > 900 giây để tránh ORA-01555)
SELECT * 
FROM customers 
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '15' MINUTE);

-- 2. Restore the original data using Enterprise-grade FLASHBACK TABLE
-- (Khôi phục dữ liệu gốc trực tiếp bằng FLASHBACK TABLE - tốc độ tối đa)

-- Step 2.1: Enable Row Movement (Mandatory before flashback table)
-- (Bước 2.1: Bật tính năng dịch chuyển hàng - Bắt buộc trước khi khôi phục bảng)
ALTER TABLE customers ENABLE ROW MOVEMENT;

-- Step 2.2: Recover the table directly to the timestamp
-- (Bước 2.2: Khôi phục trực tiếp bảng về thời điểm 15 phút trước)
FLASHBACK TABLE customers TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '15' MINUTE);

-- Step 2.3: Disable Row Movement after completion (Security best practice)
-- (Bước 2.3: Tắt dịch chuyển hàng sau khi hoàn tất để bảo mật tối ưu)
ALTER TABLE customers DISABLE ROW MOVEMENT;
