-- ==============================================================================
-- Utility Script: Kill Inactive Locks & Long Running Sessions
-- Tập lệnh Tiện ích: Xóa các phiên Treo Khóa & Chạy quá lâu
-- ==============================================================================

-- A critical operational DBA script to identify and terminate (kill) sessions 
-- that are holding locks on rows for too long, blocking other users.
-- (Tập lệnh vận hành quan trọng của DBA để tìm và ngắt kết nối các phiên đang giữ khóa 
-- quá lâu gây nghẽn hệ thống).

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_blocking_sessions IS
        SELECT 
            blocking_session AS blocking_sid,
            sid AS blocked_sid,
            seconds_in_wait,
            event
        FROM 
            v$session
        WHERE 
            blocking_session IS NOT NULL 
            AND seconds_in_wait > 60; -- Blocked for more than 1 minute (Bị khóa trên 1 phút)
            
    v_serial# NUMBER;
    v_sql VARCHAR2(200);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting session deadlock & lock contention check...');
    
    FOR r IN c_blocking_sessions LOOP
        -- Get the Serial Number of the blocking session to safely kill it
        -- (Lấy Serial Number của phiên gây nghẽn để ngắt kết nối an toàn)
        SELECT serial# INTO v_serial# 
        FROM v$session 
        WHERE sid = r.blocking_sid;
        
        DBMS_OUTPUT.PUT_LINE('Found Blocking Session! SID: ' || r.blocking_sid || ' is blocking SID: ' || r.blocked_sid || ' for ' || r.seconds_in_wait || ' seconds.');
        
        -- INPUT VALIDATION & SANITIZATION (Chống lỗi cú pháp và SQL Injection động)
        -- Assert that both parameters are strictly positive numbers before dynamic SQL construction
        IF r.blocking_sid IS NULL OR v_serial# IS NULL OR r.blocking_sid <= 0 OR v_serial# <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, '❌ ERROR: Invalid Session ID or Serial Number detected. Aborting session termination.');
        END IF;

        -- Construct dynamic SQL safely using validated numbers
        -- (Dựng lệnh SQL động an toàn từ các biến số nguyên đã được xác thực)
        v_sql := 'ALTER SYSTEM KILL SESSION ''' || r.blocking_sid || ',' || v_serial# || ''' IMMEDIATE';
        
        DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sql);
        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE('Session killed successfully. Blocked session released.');
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No blocking sessions found. Database is healthy.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error processing blocking sessions: ' || SQLERRM);
END;
/
